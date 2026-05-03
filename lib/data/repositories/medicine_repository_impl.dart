import 'package:drift/drift.dart';

import '../../domain/entities/medicine.dart';
import '../database/app_database.dart';

/// Repository interface for medicine inventory operations
abstract class MedicineRepository {
  /// Watch all medicines sorted by expiry date
  Stream<List<Medicine>> watchAllMedicines();

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
}

/// Implementation of MedicineRepository using Drift database
class MedicineRepositoryImpl implements MedicineRepository {
  final AppDatabase _database;

  MedicineRepositoryImpl(this._database);

  @override
  Stream<List<Medicine>> watchAllMedicines() {
    return _database.watchAllMedicines().map(_mapMedicines);
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
    return _database.insertMedicine(medicine.toCompanion());
  }

  @override
  Future<bool> updateMedicine(Medicine medicine) async {
    return _database.updateMedicine(medicine.toCompanion(forUpdate: true));
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

  /// Map database entity to domain entity
  List<Medicine> _mapMedicines(List<MedicineInventory> items) {
    return items.map(_mapMedicine).toList();
  }

  Medicine _mapMedicine(MedicineInventory item) {
    return Medicine(
      id: item.id,
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
      isDisposed: item.isDisposed,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}
