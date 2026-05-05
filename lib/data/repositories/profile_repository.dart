import 'package:drift/drift.dart';
import '../../domain/entities/profile.dart' as domain;
import '../database/app_database.dart';

/// Repository interface for profile operations
abstract class ProfileRepository {
  /// Watch all profiles
  Stream<List<domain.Profile>> watchAllProfiles();

  /// Insert a new profile
  Future<int> insertProfile(domain.Profile profile);

  /// Update an existing profile
  Future<bool> updateProfile(domain.Profile profile);

  /// Delete a profile and all its associated data
  Future<void> deleteProfile(int id);
}

/// Implementation of ProfileRepository using Drift database
class ProfileRepositoryImpl implements ProfileRepository {
  final AppDatabase _database;

  ProfileRepositoryImpl(this._database);

  @override
  Stream<List<domain.Profile>> watchAllProfiles() {
    return _database.watchAllProfiles().map(_mapProfiles);
  }

  @override
  Future<int> insertProfile(domain.Profile profile) {
    return _database.insertProfile(_toCompanion(profile));
  }

  @override
  Future<bool> updateProfile(domain.Profile profile) {
    return _database.updateProfile(_toCompanion(profile, forUpdate: true));
  }

  @override
  Future<void> deleteProfile(int id) {
    return _database.deleteProfile(id);
  }

  ProfilesCompanion _toCompanion(domain.Profile p, {bool forUpdate = false}) {
    return ProfilesCompanion(
      id: p.id != null ? Value(p.id!) : const Value.absent(),
      name: Value(p.name),
      colorValue: Value(p.colorValue),
      createdAt: forUpdate ? const Value.absent() : Value(p.createdAt),
    );
  }

  List<domain.Profile> _mapProfiles(List<ProfileData> items) {
    return items.map(_mapProfile).toList();
  }

  domain.Profile _mapProfile(ProfileData item) {
    return domain.Profile(
      id: item.id,
      name: item.name,
      colorValue: item.colorValue,
      createdAt: item.createdAt,
    );
  }
}
