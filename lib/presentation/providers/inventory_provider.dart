import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../domain/entities/medicine.dart';
import '../providers/repository_providers.dart';

/// Notifier for managing medicine inventory state
class InventoryNotifier extends AsyncNotifier<List<Medicine>> {
  @override
  Future<List<Medicine>> build() async {
    // Return empty list initially, will be populated by stream
    return [];
  }

  /// Watch all medicines as a stream
  Stream<List<Medicine>> watchAllMedicines() {
    final repository = ref.read(medicineRepositoryProvider);
    return repository.watchAllMedicines();
  }

  /// Watch medicines filtered by status
  Stream<List<Medicine>> watchMedicinesByStatus(MedicineStatus status) {
    final repository = ref.read(medicineRepositoryProvider);
    return repository.watchMedicinesByStatus(status);
  }

  /// Search medicines by query
  Stream<List<Medicine>> searchMedicines(String query) {
    final repository = ref.read(medicineRepositoryProvider);
    if (query.isEmpty) {
      return repository.watchAllMedicines();
    }
    return repository.searchMedicines(query);
  }

  /// Add a new medicine
  Future<int> addMedicine(Medicine medicine) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(medicineRepositoryProvider);
      final id = await repository.insertMedicine(medicine);
      state = await AsyncValue.guard(() => repository.watchAllMedicines().first);
      return id;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Update an existing medicine
  Future<bool> updateMedicine(Medicine medicine) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(medicineRepositoryProvider);
      final success = await repository.updateMedicine(medicine);
      state = await AsyncValue.guard(() => repository.watchAllMedicines().first);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Delete a medicine
  Future<bool> deleteMedicine(int id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(medicineRepositoryProvider);
      final success = await repository.deleteMedicine(id);
      state = await AsyncValue.guard(() => repository.watchAllMedicines().first);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Mark a medicine as disposed
  Future<bool> markAsDisposed(int id) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(medicineRepositoryProvider);
      final success = await repository.markAsDisposed(id);
      state = await AsyncValue.guard(() => repository.watchAllMedicines().first);
      return success;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Provider for the inventory notifier
final inventoryProvider =
    AsyncNotifierProvider<InventoryNotifier, List<Medicine>>(() {
  return InventoryNotifier();
});

/// Provider for the current search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for the current filter status
final filterStatusProvider = StateProvider<MedicineStatus>((ref) {
  return MedicineStatus.all;
});

/// Provider for filtered and searched medicines
final filteredMedicinesProvider = StreamProvider<List<Medicine>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final status = ref.watch(filterStatusProvider);
  final notifier = ref.read(inventoryProvider.notifier);

  if (query.isNotEmpty) {
    return notifier.searchMedicines(query);
  } else if (status != MedicineStatus.all) {
    return notifier.watchMedicinesByStatus(status);
  } else {
    return notifier.watchAllMedicines();
  }
});
