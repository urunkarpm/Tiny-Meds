import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/enums.dart';
import '../../data/database/app_database.dart';
import '../../domain/entities/medicine.dart';
import '../../domain/entities/alert.dart';
import '../providers/repository_providers.dart';
import 'profile_provider.dart';

/// Notifier for managing medicine inventory state
class InventoryNotifier extends AsyncNotifier<List<Medicine>> {
  @override
  Future<List<Medicine>> build() async {
    // Return empty list initially, will be populated by stream
    return [];
  }

  /// Watch all medicines for the active profile as a stream
  Stream<List<Medicine>> watchAllMedicines() {
    final repository = ref.read(medicineRepositoryProvider);
    final activeId = ref.watch(activeProfileIdProvider);
    if (activeId == null) return Stream.value([]);
    return repository.watchMedicinesForProfile(activeId);
  }

  /// Watch medicines filtered by status and active profile
  Stream<List<Medicine>> watchMedicinesByStatus(MedicineStatus status) {
    final repository = ref.read(medicineRepositoryProvider);
    final activeId = ref.watch(activeProfileIdProvider);
    if (activeId == null) return Stream.value([]);
    
    // Repository method currently doesn't filter by profile + status simultaneously in DB
    // We can filter in memory for now, or update database queries later
    return repository.watchMedicinesByStatus(status).map((list) => 
      list.where((m) => m.profileId == activeId).toList());
  }

  /// Search medicines by query for active profile
  Stream<List<Medicine>> searchMedicines(String query) {
    final repository = ref.read(medicineRepositoryProvider);
    final activeId = ref.watch(activeProfileIdProvider);
    if (activeId == null) return Stream.value([]);
    
    if (query.isEmpty) {
      return repository.watchMedicinesForProfile(activeId);
    }
    
    return repository.searchMedicines(query).map((list) => 
      list.where((m) => m.profileId == activeId).toList());
  }

  /// Add a new medicine to the active profile
  Future<int> addMedicine(Medicine medicine) async {
    final repository = ref.read(medicineRepositoryProvider);
    final activeId = ref.read(activeProfileIdProvider);
    
    final medWithProfile = medicine.copyWith(
      profileId: activeId,
      updatedAt: DateTime.now(),
    );
    
    return await repository.insertMedicine(medWithProfile);
  }

  /// Update an existing medicine
  Future<bool> updateMedicine(Medicine medicine) async {
    final repository = ref.read(medicineRepositoryProvider);
    return await repository.updateMedicine(medicine);
  }

  /// Delete a medicine
  Future<bool> deleteMedicine(int id) async {
    final repository = ref.read(medicineRepositoryProvider);
    return await repository.deleteMedicine(id);
  }

  /// Mark a medicine as disposed
  Future<bool> markAsDisposed(int id) async {
    final repository = ref.read(medicineRepositoryProvider);
    return await repository.markAsDisposed(id);
  }

  /// Toggle needs refill status (shopping list)
  Future<bool> toggleNeedsRefill(int id, bool needsRefill) async {
    final repository = ref.read(medicineRepositoryProvider);
    final medicine = await repository.getMedicineById(id);
    if (medicine == null) return false;
    
    return await repository.updateMedicine(
      medicine.copyWith(needsRefill: needsRefill, updatedAt: DateTime.now()),
    );
  }
}

/// Notifier for managing alerts and notifications
class AlertNotifier extends AsyncNotifier<List<Alert>> {
  @override
  Future<List<Alert>> build() async {
    return [];
  }

  /// Add a new alert and schedule notification
  Future<int> addAlert(Alert alert, Medicine medicine) async {
    final repository = ref.read(alertRepositoryProvider);
    final id = await repository.insertAlert(alert);
    
    // Schedule notification
    final notificationService = ref.read(notificationServiceProvider);
    if (alert.type == AlertType.dose && alert.recurrence == RecurrencePattern.daily) {
      await notificationService.scheduleDailyNotification(
        id: id,
        title: 'Time for ${medicine.name}',
        body: 'Take ${medicine.doseAmount ?? 1} ${medicine.unit} of ${medicine.name}',
        time: TimeOfDay.fromDateTime(alert.triggerDate),
      );
    } else {
      await notificationService.scheduleNotification(
        id: id,
        title: _getAlertTitle(alert, medicine),
        body: _getAlertBody(alert, medicine),
        scheduledDate: alert.triggerDate,
        channelId: _getChannelId(alert.type),
      );
    }
    
    return id;
  }

  /// Delete an alert and cancel notification
  Future<bool> deleteAlert(int id) async {
    final repository = ref.read(alertRepositoryProvider);
    final success = await repository.deleteAlert(id);
    if (success) {
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.cancelNotification(id);
    }
    return success;
  }

  String _getAlertTitle(Alert alert, Medicine medicine) {
    switch (alert.type) {
      case AlertType.expiry:
        return 'Medicine Expiry Warning';
      case AlertType.lowStock:
        return 'Low Stock Warning';
      case AlertType.dose:
        return 'Dose Reminder';
    }
  }

  String _getAlertBody(Alert alert, Medicine medicine) {
    switch (alert.type) {
      case AlertType.expiry:
        return '${medicine.name} is expiring soon on ${_formatDate(medicine.expiryDate)}';
      case AlertType.lowStock:
        return 'You are running low on ${medicine.name}. Only ${medicine.quantity} ${medicine.unit} left.';
      case AlertType.dose:
        return 'Time to take your dose of ${medicine.name}.';
    }
  }

  String _getChannelId(AlertType type) {
    switch (type) {
      case AlertType.expiry:
        return 'expiry_alerts';
      case AlertType.lowStock:
        return 'stock_alerts';
      case AlertType.dose:
        return 'dose_reminders';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Provider for the alert notifier
final alertsNotifierProvider =
    AsyncNotifierProvider<AlertNotifier, List<Alert>>(() {
  return AlertNotifier();
});

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

/// Provider for the current sort order
final sortOrderProvider = StateProvider<SortOrder>((ref) => SortOrder.name);

/// Provider for the current bottom navigation index
final bottomNavProvider = StateProvider<int>((ref) => 0);

/// Provider for filtered and searched medicines for the active profile
final filteredMedicinesProvider = StreamProvider<List<Medicine>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final status = ref.watch(filterStatusProvider);
  final sortOrder = ref.watch(sortOrderProvider);
  final notifier = ref.read(inventoryProvider.notifier);
  final activeId = ref.watch(activeProfileIdProvider);

  if (activeId == null) return Stream.value([]);

  Stream<List<Medicine>> stream;
  if (query.isNotEmpty) {
    stream = notifier.searchMedicines(query);
  } else if (status != MedicineStatus.all) {
    stream = notifier.watchMedicinesByStatus(status);
  } else {
    stream = notifier.watchAllMedicines();
  }

  return stream.map((medicines) {
    final sorted = List<Medicine>.from(medicines);
    if (sortOrder == SortOrder.name) {
      sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else {
      sorted.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    }
    return sorted;
  });
});

/// Provider for active alerts for the active profile
final activeAlertsProvider = StreamProvider<List<Alert>>((ref) {
  final repository = ref.watch(alertRepositoryProvider);
  final activeId = ref.watch(activeProfileIdProvider);
  if (activeId == null) return Stream.value([]);
  
  return repository.watchActiveAlerts().asyncMap((alerts) async {
    final medRepo = ref.read(medicineRepositoryProvider);
    final filteredAlerts = <Alert>[];
    for (final alert in alerts) {
      final med = await medRepo.getMedicineById(alert.medicineId);
      if (med?.profileId == activeId) {
        filteredAlerts.add(alert);
      }
    }
    return filteredAlerts;
  });
});

/// Provider for expired medicines for the active profile
final expiredMedicinesProvider = StreamProvider<List<Medicine>>((ref) {
  final activeId = ref.watch(activeProfileIdProvider);
  if (activeId == null) return Stream.value([]);
  
  final repository = ref.watch(medicineRepositoryProvider);
  return repository.watchMedicinesByStatus(MedicineStatus.expired).map((list) => 
    list.where((m) => m.profileId == activeId).toList());
});

/// Provider for low stock medicines for the active profile
final lowStockMedicinesProvider = StreamProvider<List<Medicine>>((ref) {
  final activeId = ref.watch(activeProfileIdProvider);
  if (activeId == null) return Stream.value([]);
  
  final repository = ref.watch(medicineRepositoryProvider);
  return repository.watchLowStockMedicines().map((list) => 
    list.where((m) => m.profileId == activeId).toList());
});

/// Provider for medicines that need refill (shopping list) for the active profile
final shoppingListProvider = StreamProvider<List<Medicine>>((ref) {
  final activeId = ref.watch(activeProfileIdProvider);
  if (activeId == null) return Stream.value([]);
  
  final repository = ref.watch(medicineRepositoryProvider);
  return repository.watchMedicinesForProfile(activeId).map((list) => 
    list.where((m) => m.needsRefill && !m.isDisposed).toList());
});

/// Provider for medicine inventory summary (count and oldest date) for active profile
final inventorySummaryProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final activeId = ref.watch(activeProfileIdProvider);
  if (activeId == null) return Stream.value({'count': 0, 'since': null});
  
  final repository = ref.watch(medicineRepositoryProvider);
  return repository.watchMedicinesForProfile(activeId).map((medicines) {
    if (medicines.isEmpty) {
      return {'count': 0, 'since': null};
    }
    
    // Find earliest createdAt date
    final oldest = medicines.reduce((a, b) => 
      a.createdAt.isBefore(b.createdAt) ? a : b
    );
    
    return {
      'count': medicines.length,
      'since': oldest.createdAt,
    };
  });
});
