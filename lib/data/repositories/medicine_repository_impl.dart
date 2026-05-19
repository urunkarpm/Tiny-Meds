import 'package:drift/drift.dart';

import '../../data/models/enums.dart';
import '../../domain/entities/medicine.dart';
import '../database/app_database.dart';

/// Repository interface for medicine inventory operations
abstract class MedicineRepository {
  /// Watch all medicines sorted by expiry date
  Stream<List<Medicine>> watchAllMedicines();

  /// Watch medicines for a specific profile
  Stream<List<Medicine>> watchMedicinesForProfile(int profileId);

  /// Watch medicines filtered by status
  Stream<List<Medicine>> watchMedicinesByStatus(MedicineStatus status);

  /// Search medicines by name or brand
  Stream<List<Medicine>> searchMedicines(String query);

  /// Get a single medicine by ID
  Future<Medicine?> getMedicineById(int id);

  /// Insert a new medicine
  Future<int> insertMedicine(Medicine medicine);

  /// Update an existing medicine
  Future<bool> updateMedicine(Medicine medicine);

  /// Delete a medicine
  Future<bool> deleteMedicine(int id);

  /// Mark a medicine as disposed
  Future<bool> markAsDisposed(int id);

  /// Watch low stock medicines
  Stream<List<Medicine>> watchLowStockMedicines();

  /// Clear all data
  Future<void> clearAllData();
}

/// Implementation of MedicineRepository using Drift database
class MedicineRepositoryImpl implements MedicineRepository {
  final AppDatabase _database;

  MedicineRepositoryImpl(this._database);

  @override
  Future<void> clearAllData() async {
    await _database.clearAllData();
  }

  @override
  Stream<List<Medicine>> watchAllMedicines() {
    return _database.watchAllMedicines().map(_mapMedicines);
  }

  @override
  Stream<List<Medicine>> watchMedicinesForProfile(int profileId) {
    return _database.watchMedicinesForProfile(profileId).map(_mapMedicines);
  }

  @override
  Stream<List<Medicine>> watchMedicinesByStatus(MedicineStatus status) {
    return _database.watchMedicinesByStatus(status).map(_mapMedicines);
  }

  @override
  Stream<List<Medicine>> searchMedicines(String query) {
    return _database.searchMedicines(query).map(_mapMedicines);
  }

  @override
  Future<Medicine?> getMedicineById(int id) async {
    final result = await _database.getMedicineById(id);
    return result != null ? _mapMedicine(result) : null;
  }

  @override
  Future<int> insertMedicine(Medicine medicine) async {
    return _database.insertMedicine(_toCompanion(medicine));
  }

  @override
  Future<bool> updateMedicine(Medicine medicine) async {
    return _database.updateMedicine(_toCompanion(medicine, forUpdate: true));
  }

  @override
  Future<bool> deleteMedicine(int id) async {
    return _database.deleteMedicine(id);
  }

  @override
  Future<bool> markAsDisposed(int id) async {
    return _database.markAsDisposed(id);
  }

  @override
  Stream<List<Medicine>> watchLowStockMedicines() {
    return _database.watchLowStockMedicines().map(_mapMedicines);
  }

  MedicineInventoryCompanion _toCompanion(Medicine m,
      {bool forUpdate = false}) {
    return MedicineInventoryCompanion(
      id: m.id != null ? Value(m.id!) : const Value.absent(),
      profileId:
          m.profileId != null ? Value(m.profileId!) : const Value.absent(),
      name: Value(m.name),
      brand: m.brand != null ? Value(m.brand) : const Value.absent(),
      form: Value(m.form),
      strength: m.strength != null ? Value(m.strength) : const Value.absent(),
      quantity: Value(m.quantity),
      unit: Value(m.unit),
      expiryDate: Value(m.expiryDate),
      openedDate:
          m.openedDate != null ? Value(m.openedDate) : const Value.absent(),
      location: m.location != null ? Value(m.location) : const Value.absent(),
      lowStockThreshold: m.lowStockThreshold != null
          ? Value(m.lowStockThreshold)
          : const Value.absent(),
      frequency:
          m.frequency != null ? Value(m.frequency) : const Value.absent(),
      doseAmount:
          m.doseAmount != null ? Value(m.doseAmount) : const Value.absent(),
      needsRefill: Value(m.needsRefill),
      isDisposed: Value(m.isDisposed),
      createdAt: forUpdate ? const Value.absent() : Value(m.createdAt),
      updatedAt: Value(DateTime.now()),
    );
  }

  /// Map database entity to domain entity
  List<Medicine> _mapMedicines(List<MedicineInventoryData> items) {
    return items.map(_mapMedicine).toList();
  }

  Medicine _mapMedicine(MedicineInventoryData item) {
    return Medicine(
      id: item.id,
      profileId: item.profileId,
      name: item.name,
      brand: item.brand,
      form: item.form,
      strength: item.strength,
      quantity: item.quantity,
      unit: item.unit,
      expiryDate: item.expiryDate,
      openedDate: item.openedDate,
      location: item.location,
      lowStockThreshold: item.lowStockThreshold,
      frequency: item.frequency,
      doseAmount: item.doseAmount,
      needsRefill: item.needsRefill,
      isDisposed: item.isDisposed,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}
