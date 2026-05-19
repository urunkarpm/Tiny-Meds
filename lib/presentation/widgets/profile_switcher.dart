import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_provider.dart';

class ProfileSwitcher extends ConsumerWidget {
  const ProfileSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProfile = ref.watch(activeProfileProvider);
    final profilesAsync = ref.watch(profilesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return profilesAsync.when(
      data: (profiles) => PopupMenuButton<int>(
        initialValue: activeProfile?.id,
        onSelected: (id) {
          if (id == -1) {
            _showAddProfileDialog(context, ref);
          } else {
            ref.read(profileActionsProvider).switchProfile(id);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: activeProfile != null
                    ? Color(activeProfile.colorValue)
                    : colorScheme.primary,
                child: Text(
                  activeProfile?.name.substring(0, 1).toUpperCase() ?? '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                activeProfile?.name ?? 'Profiles',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Icon(Icons.arrow_drop_down_rounded),
            ],
          ),
        ),
        itemBuilder: (context) => [
          ...profiles.map((p) => PopupMenuItem<int>(
                value: p.id,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Color(p.colorValue),
                      child: Text(
                        p.name.substring(0, 1).toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(p.name),
                    const Spacer(),
                    if (p.id == activeProfile?.id)
                      Icon(Icons.check_rounded,
                          color: colorScheme.primary, size: 18),
                  ],
                ),
              )),
          const PopupMenuDivider(),
          const PopupMenuItem<int>(
            value: -1,
            child: Row(
              children: [
                Icon(Icons.add_rounded, size: 20),
                SizedBox(width: 12),
                Text('Add Profile'),
              ],
            ),
          ),
        ],
      ),
      loading: () => const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(strokeWidth: 2)),
      error: (_, __) => const Icon(Icons.error_outline),
    );
  }

  void _showAddProfileDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    int selectedColor = 0xFF2196F3; // Default Blue

    final colors = [
      0xFF2196F3, // Blue
      0xFF4CAF50, // Green
      0xFFFF9800, // Orange
      0xFFF44336, // Red
      0xFF9C27B0, // Purple
      0xFFE91E63, // Pink
      0xFF00BCD4, // Cyan
      0xFFFFEB3B, // Yellow
    ];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Profile Name',
                  hintText: 'e.g. Son, Daughter, Mother',
                ),
                autofocus: true,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              const Text('Choose Color'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: colors
                    .map((c) => GestureDetector(
                          onTap: () => setState(() => selectedColor = c),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Color(c),
                              shape: BoxShape.circle,
                              border: selectedColor == c
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref.read(profileActionsProvider).addProfile(
                        controller.text.trim(),
                        selectedColor,
                      );
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
