import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/inventory_provider.dart';

/// Settings screen — app preferences and configuration
/// Design spec: 08-Settings
/// Nav bar is provided by MainShell — not rendered here.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 24, 4, 24),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),

            // You card
            _buildYouCard(context, ref),
            const SizedBox(height: 24),

            // Notifications group
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            _buildNotificationsGroup(context),
            const SizedBox(height: 24),

            // Defaults group
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Text(
                'Defaults',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            _buildDefaultsGroup(context),
            const SizedBox(height: 24),

            // Your data group
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
              child: Text(
                'Your data',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            _buildYourDataGroup(context),
            const SizedBox(height: 32),

            // Footer
            Center(
              child: Text(
                'Tiny Meds v0.1 · Everything stays on this phone',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildYouCard(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final medicinesAsync = ref.watch(allMedicinesProvider);

    final subtitle = medicinesAsync.when(
      loading: () => '',
      error: (_, __) => 'Your medicine cabinet',
      data: (medicines) {
        if (medicines.isEmpty) return 'No medicines yet';
        final count = medicines.length;
        final earliest = medicines
            .map((m) => m.createdAt)
            .reduce((a, b) => a.isBefore(b) ? a : b);
        const months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        final since =
            '${months[earliest.month - 1]} ${earliest.year}';
        return '$count medicine${count == 1 ? '' : 's'} · since $since';
      },
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'P',
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your cabinet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                  ),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
              color: colorScheme.onPrimaryContainer),
        ],
      ),
    );
  }

  Widget _buildNotificationsGroup(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _switchRow(context, Icons.access_time_rounded, 'Expiry alerts',
              null, true, false),
          _divider(colorScheme),
          _switchRow(context, Icons.inventory_2_rounded, 'Low stock alerts',
              null, true, false),
          _divider(colorScheme),
          _switchRow(context, Icons.notifications_rounded, 'Dose reminders',
              null, false, false),
          _divider(colorScheme),
          _navRow(context, Icons.bedtime_rounded, 'Quiet hours',
              'Mute between 10:00 PM and 7:00 AM', null, false),
          _divider(colorScheme),
          _navRow(context, Icons.music_note_rounded, 'Notification sound',
              null, 'Soft chime', true),
        ],
      ),
    );
  }

  Widget _buildDefaultsGroup(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _navRow(context, Icons.schedule_rounded, 'Default lead time',
              null, '7 days', false),
          _divider(colorScheme),
          _navRow(context, Icons.inventory_2_rounded, 'Low-stock threshold',
              null, '3 doses', false),
          _divider(colorScheme),
          _navRow(context, Icons.location_on_outlined, 'Default location',
              null, 'Kitchen', true),
        ],
      ),
    );
  }

  Widget _buildYourDataGroup(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _navRow(context, Icons.download_rounded, 'Export as CSV',
              'Download your medicine list', null, false),
          _divider(colorScheme),
          _navRow(context, Icons.info_outline_rounded, 'Medical disclaimer',
              null, null, false),
          _divider(colorScheme),
          _dangerRow(context),
        ],
      ),
    );
  }

  Widget _switchRow(BuildContext context, IconData icon, String label,
      String? sub, bool value, bool isLast) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 22, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context).textTheme.bodyLarge),
                if (sub != null) ...[
                  const SizedBox(height: 2),
                  Text(sub,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          )),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _navRow(BuildContext context, IconData icon, String label,
      String? sub, String? trailing, bool isLast) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {},
      borderRadius: isLast
          ? const BorderRadius.vertical(bottom: Radius.circular(16))
          : BorderRadius.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodyLarge),
                  if (sub != null) ...[
                    const SizedBox(height: 2),
                    Text(sub,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            )),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              Text(trailing,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      )),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _dangerRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => _showResetConfirmation(context),
      borderRadius:
          const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(Icons.delete_forever_rounded,
                size: 22, color: colorScheme.error),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reset cabinet',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.error,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Permanently delete all data',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: colorScheme.error, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _divider(ColorScheme colorScheme) {
    return Divider(
      height: 1,
      indent: 52,
      color: colorScheme.outlineVariant,
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset cabinet?'),
        content: const Text(
          'This will permanently delete all your medicine data. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
