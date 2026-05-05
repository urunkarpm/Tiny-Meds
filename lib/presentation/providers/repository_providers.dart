import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database/app_database.dart';
import '../../data/repositories/medicine_repository_impl.dart';
import '../../data/repositories/alert_repository_impl.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/services/notification_service.dart';

/// Provider for the AppDatabase instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Provider for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Provider for MedicineRepository
final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return MedicineRepositoryImpl(database);
});

/// Provider for ProfileRepository
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ProfileRepositoryImpl(database);
});

/// Provider for AlertRepository
final alertRepositoryProvider = Provider<AlertRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return AlertRepositoryImpl(database);
});
