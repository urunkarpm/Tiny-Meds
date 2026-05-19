import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/profile.dart';
import '../../data/repositories/profile_repository.dart';
import 'repository_providers.dart';

/// Provider for the list of all profiles
final profilesProvider = StreamProvider<List<Profile>>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.watchAllProfiles();
});

/// Provider for the currently active profile ID
/// Defaults to null, but will be set to the first profile in the list if null
final activeProfileIdProvider = StateProvider<int?>((ref) {
  // Try to find the first profile if not set
  final profilesAsync = ref.watch(profilesProvider);
  return profilesAsync.when(
    data: (profiles) => profiles.isNotEmpty ? profiles.first.id : null,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider for the currently active profile entity
final activeProfileProvider = Provider<Profile?>((ref) {
  final activeId = ref.watch(activeProfileIdProvider);
  final profilesAsync = ref.watch(profilesProvider);

  return profilesAsync.when(
    data: (profiles) {
      if (activeId == null && profiles.isNotEmpty) return profiles.first;
      return profiles.cast<Profile?>().firstWhere(
            (p) => p?.id == activeId,
            orElse: () => profiles.isNotEmpty ? profiles.first : null,
          );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Notifier for profile-related actions
final profileActionsProvider = Provider((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileActions(ref, repository);
});

class ProfileActions {
  final Ref _ref;
  final ProfileRepository _repository;

  ProfileActions(this._ref, this._repository);

  Future<int> addProfile(String name, int colorValue) async {
    final profile = Profile(
      name: name,
      colorValue: colorValue,
      createdAt: DateTime.now(),
    );
    final id = await _repository.insertProfile(profile);
    // Switch to new profile automatically?
    _ref.read(activeProfileIdProvider.notifier).state = id;
    return id;
  }

  Future<void> switchProfile(int id) async {
    _ref.read(activeProfileIdProvider.notifier).state = id;
  }

  Future<void> updateProfile(Profile profile) async {
    await _repository.updateProfile(profile);
  }

  Future<void> deleteProfile(int id) async {
    await _repository.deleteProfile(id);
    // If deleted active profile, reset
    final activeId = _ref.read(activeProfileIdProvider);
    if (activeId == id) {
      _ref.read(activeProfileIdProvider.notifier).state = null;
    }
  }
}
