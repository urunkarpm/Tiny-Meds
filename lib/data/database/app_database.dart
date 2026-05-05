import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../models/enums.dart';
import 'tables/medicine_inventory_table.dart';
import 'tables/alerts_table.dart';
import 'tables/profiles_table.dart';

part 'app_database.g.dart';

/// Main Drift database class for Tiny-Meds
@DriftDatabase(tables: [MedicineInventory, Alerts, Profiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        // Insert default profile on fresh install
        await into(profiles).insert(ProfilesCompanion.insert(
          name: 'Primary Profile',
          colorValue: 0xFF2196F3, // Default Blue
          createdAt: Value(DateTime.now()),
        ));
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Add needsRefill column
          await m.addColumn(medicineInventory, medicineInventory.needsRefill);
        }
        if (from < 3) {
          // 1. Create profiles table
          await m.createTable(profiles);
          
          // 2. Add profileId column to medicineInventory
          await m.addColumn(medicineInventory, medicineInventory.profileId);
          
          // 3. Insert default profile
          final defaultProfileId = await into(profiles).insert(ProfilesCompanion.insert(
            name: 'Primary Profile',
            colorValue: 0xFF2196F3,
            createdAt: Value(DateTime.now()),
          ));
          
          // 4. Assign all existing medicines to this default profile
          await (update(medicineInventory)..where((t) => t.profileId.isNull()))
              .write(MedicineInventoryCompanion(profileId: Value(defaultProfileId)));
        }
      },
    );
  }

  /// Get all profiles
  Stream<List<ProfileData>> watchAllProfiles() {
    return select(profiles).watch();
  }

  /// Insert a new profile
  Future<int> insertProfile(ProfilesCompanion profile) {
    return into(profiles).insert(profile);
  }

  /// Update a profile
  Future<bool> updateProfile(ProfilesCompanion profile) {
    return update(profiles).replace(profile);
  }

  /// Delete a profile (and its medicines)
  Future<void> deleteProfile(int id) async {
    await transaction(() async {
      // Delete alerts for medicines in this profile
      final meds = await (select(medicineInventory)..where((t) => t.profileId.equals(id))).get();
      for (final med in meds) {
        await (delete(alerts)..where((t) => t.medicineId.equals(med.id))).go();
      }
      // Delete medicines
      await (delete(medicineInventory)..where((t) => t.profileId.equals(id))).go();
      // Delete profile
      await (delete(profiles)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Get all medicines for a specific profile, sorted by expiry date
  Stream<List<MedicineInventoryData>> watchMedicinesForProfile(int profileId) {
    return (select(medicineInventory)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.expiryDate),
          ]))
        .watch();
  }

  /// Get all medicines sorted by expiry date (soonest first)
  Stream<List<MedicineInventoryData>> watchAllMedicines() {
    return (select(medicineInventory)
          ..orderBy([
            (t) => OrderingTerm.asc(t.expiryDate),
          ]))
        .watch();
  }

  /// Get medicines by status filter
  Stream<List<MedicineInventoryData>> watchMedicinesByStatus(MedicineStatus status) {
    final now = DateTime.now();
    final expiringSoon = now.add(const Duration(days: 30));
    final expiringVerySoon = now.add(const Duration(days: 7));

    return (select(medicineInventory)
          ..where((t) {
            switch (status) {
              case MedicineStatus.all:
                return t.isDisposed.equals(false);
              case MedicineStatus.active:
                return t.expiryDate.isBiggerThanValue(expiringSoon) &
                    t.isDisposed.equals(false);
              case MedicineStatus.expiringSoon:
                return t.expiryDate.isBiggerOrEqualValue(now) &
                    t.expiryDate.isSmallerOrEqualValue(expiringVerySoon) &
                    t.isDisposed.equals(false);
              case MedicineStatus.expired:
                return t.expiryDate.isSmallerThanValue(now) &
                    t.isDisposed.equals(false);
              case MedicineStatus.lowStock:
                return t.isDisposed.equals(false) &
                    t.lowStockThreshold.isNotNull() &
                    t.quantity.isSmallerOrEqual(t.lowStockThreshold.dartCast<int>());
            }
          })
          ..orderBy([(t) => OrderingTerm.asc(t.expiryDate)]))
        .watch();
  }

  /// Search medicines by name or brand
  Stream<List<MedicineInventoryData>> searchMedicines(String query) {
    final searchTerm = '%${query.toLowerCase()}%';
    return (select(medicineInventory)
          ..where((t) {
            final nameMatch = t.name.lower().like(searchTerm);
            final brandMatch = t.brand.lower().like(searchTerm);
            return (nameMatch | brandMatch) & t.isDisposed.equals(false);
          })
          ..orderBy([(t) => OrderingTerm.asc(t.expiryDate)]))
        .watch();
  }

  /// Insert a new medicine
  Future<int> insertMedicine(MedicineInventoryCompanion medicine) {
    return into(medicineInventory).insert(medicine);
  }

  /// Update an existing medicine
  Future<bool> updateMedicine(MedicineInventoryCompanion medicine) {
    return update(medicineInventory).replace(medicine);
  }

  /// Delete a medicine
  Future<bool> deleteMedicine(int id) {
    return (delete(medicineInventory)..where((t) => t.id.equals(id))).go()
        .then((_) => true);
  }

  /// Mark medicine as disposed
  Future<bool> markAsDisposed(int id) {
    return (update(medicineInventory)..where((t) => t.id.equals(id)))
        .write(const MedicineInventoryCompanion(isDisposed: Value(true)))
        .then((count) => count > 0);
  }

  /// Get a single medicine by ID
  Future<MedicineInventoryData?> getMedicineById(int id) {
    return (select(medicineInventory)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get low stock medicines
  Stream<List<MedicineInventoryData>> watchLowStockMedicines() {
    return (select(medicineInventory)
          ..where((t) =>
              t.lowStockThreshold.isNotNull() &
              t.quantity.isSmallerOrEqual(t.lowStockThreshold.dartCast<int>()) &
              t.isDisposed.equals(false))
          ..orderBy([(t) => OrderingTerm.asc(t.expiryDate)]))
        .watch();
  }

  /// Insert a new alert
  Future<int> insertAlert(AlertsCompanion alert) {
    return into(alerts).insert(alert);
  }

  /// Update an existing alert
  Future<bool> updateAlert(AlertsCompanion alert) {
    return update(alerts).write(alert).then((count) => count > 0);
  }

  /// Delete an alert
  Future<bool> deleteAlert(int id) {
    return (delete(alerts)..where((t) => t.id.equals(id))).go()
        .then((_) => true);
  }

  /// Get alerts for a specific medicine
  Stream<List<AlertData>> watchAlertsForMedicine(int medicineId) {
    return (select(alerts)..where((t) => t.medicineId.equals(medicineId)))
        .watch();
  }

  /// Get all active alerts
  Stream<List<AlertData>> watchActiveAlerts() {
    return (select(alerts)..where((t) => t.isActive.equals(true)))
        .watch();
  }

  /// Update last notified time for an alert
  Future<bool> updateLastNotified(int id, DateTime time) {
    return (update(alerts)..where((t) => t.id.equals(id)))
        .write(AlertsCompanion(lastNotified: Value(time)))
        .then((count) => count > 0);
  }

  /// Toggle alert active state
  Future<bool> toggleAlertActive(int id, bool isActive) {
    return (update(alerts)..where((t) => t.id.equals(id)))
        .write(AlertsCompanion(isActive: Value(isActive)))
        .then((count) => count > 0);
  }

  /// Enable or disable all alerts
  Future<void> setAllAlertsActive(bool isActive) {
    return (update(alerts)).write(AlertsCompanion(isActive: Value(isActive)));
  }

  /// Clear all data from the database
  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(alerts).go();
      await delete(medicineInventory).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tiny_meds.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
