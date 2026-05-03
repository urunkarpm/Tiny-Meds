import '../../domain/entities/alert.dart';
import '../database/app_database.dart';

/// Repository interface for alert operations
abstract class AlertRepository {
  /// Watch all active alerts
  Stream<List<Alert>> watchActiveAlerts();

  /// Watch alerts for a specific medicine
  Stream<List<Alert>> watchAlertsForMedicine(int medicineId);

  /// Get an alert by ID
  Future<Alert?> getAlertById(int id);

  /// Insert a new alert
  Future<int> insertAlert(Alert alert);

  /// Update an existing alert
  Future<bool> updateAlert(Alert alert);

  /// Delete an alert
  Future<bool> deleteAlert(int id);

  /// Update last notified time for an alert
  Future<bool> updateLastNotified(int id, DateTime time);

  /// Toggle alert active state
  Future<bool> toggleAlertActive(int id, bool isActive);

  /// Enable or disable all alerts
  Future<void> setAllAlertsActive(bool isActive);
}

/// Implementation of AlertRepository using Drift database
class AlertRepositoryImpl implements AlertRepository {
  final AppDatabase _database;

  AlertRepositoryImpl(this._database);

  @override
  Stream<List<Alert>> watchActiveAlerts() {
    return _database.watchActiveAlerts().map(_mapAlerts);
  }

  @override
  Stream<List<Alert>> watchAlertsForMedicine(int medicineId) {
    return _database.watchAlertsForMedicine(medicineId).map(_mapAlerts);
  }

  @override
  Future<Alert?> getAlertById(int id) async {
    // Note: This requires adding a method to the database or querying differently
    // For now, we'll fetch all active alerts and filter (not ideal for large datasets)
    final alerts = await _database.watchActiveAlerts().first;
    final result = alerts.where((a) => a.id == id).toList();
    return result.isNotEmpty ? _mapAlert(result.first) : null;
  }

  @override
  Future<int> insertAlert(Alert alert) async {
    return _database.insertAlert(alert.toCompanion());
  }

  @override
  Future<bool> updateAlert(Alert alert) async {
    return _database.updateAlert(alert.toCompanion(forUpdate: true));
  }

  @override
  Future<bool> deleteAlert(int id) async {
    return _database.deleteAlert(id);
  }

  @override
  Future<bool> updateLastNotified(int id, DateTime time) async {
    return _database.updateLastNotified(id, time);
  }

  @override
  Future<bool> toggleAlertActive(int id, bool isActive) async {
    return _database.toggleAlertActive(id, isActive);
  }

  @override
  Future<void> setAllAlertsActive(bool isActive) async {
    return _database.setAllAlertsActive(isActive);
  }

  /// Map database entity to domain entity
  List<Alert> _mapAlerts(List<Alerts> items) {
    return items.map(_mapAlert).toList();
  }

  Alert _mapAlert(Alerts item) {
    return Alert(
      id: item.id,
      medicineId: item.medicineId,
      type: item.type,
      triggerDate: item.triggerDate,
      recurrence: item.recurrence,
      isActive: item.isActive,
      lastNotified: item.lastNotified,
      createdAt: item.createdAt,
    );
  }
}
