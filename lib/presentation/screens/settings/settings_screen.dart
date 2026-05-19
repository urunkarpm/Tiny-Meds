import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:csv/csv.dart';

import '../../providers/inventory_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/repository_providers.dart';
import '../../providers/profile_provider.dart';
import '../../../domain/entities/profile.dart';

/// Settings screen — app preferences and configuration
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: settingsAsync.when(
          data: (settings) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 24, 4, 24),
                child: Text(
                  'Settings',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),

              // You card
              _buildYouCard(context, ref),
              const SizedBox(height: 24),

              // Notifications group
              _buildSectionHeader(context, 'Notifications'),
              _buildNotificationsGroup(context, ref, settings),
              const SizedBox(height: 24),

              // Defaults group
              _buildSectionHeader(context, 'Defaults'),
              _buildDefaultsGroup(context, ref, settings),
              const SizedBox(height: 24),

              // AI features group
              _buildSectionHeader(context, 'AI Features'),
              _buildAIFeaturesGroup(context, ref, settings),
              const SizedBox(height: 24),

              // Your data group
              _buildSectionHeader(context, 'Your data'),
              _buildYourDataGroup(context, ref),
              const SizedBox(height: 32),

              // Footer
              Center(
                child: Text(
                  'Tiny Meds v1.3 · Everything stays on this phone',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildYouCard(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final summaryAsync = ref.watch(inventorySummaryProvider);
    final activeProfile = ref.watch(activeProfileProvider);

    return InkWell(
      onTap: activeProfile != null
          ? () => _showEditProfileDialog(context, ref, activeProfile)
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Container(
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
                color: activeProfile != null
                    ? Color(activeProfile.colorValue)
                    : colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  activeProfile?.name.substring(0, 1).toUpperCase() ?? 'Y',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: summaryAsync.when(
                data: (summary) {
                  final count = summary['count'] as int;
                  final since = summary['since'] as DateTime?;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activeProfile?.name ?? 'Your cabinet',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        since != null
                            ? '$count medicines · since ${DateFormat('MMMM yyyy').format(since)}'
                            : 'Empty cabinet',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.8),
                            ),
                      ),
                    ],
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const Text('Error loading summary'),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: colorScheme.onPrimaryContainer),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context, WidgetRef ref, Profile profile) {
    final controller = TextEditingController(text: profile.name);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit profile name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            hintText: 'e.g. John',
          ),
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                ref.read(profileActionsProvider).updateProfile(
                      profile.copyWith(name: controller.text.trim()),
                    );
                Navigator.pop(ctx);
              }
            },
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsGroup(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = ref.read(settingsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _switchRow(
            context,
            Icons.access_time_rounded,
            'Expiry alerts',
            null,
            settings.expiryAlertsEnabled,
            (val) => notifier.updateSetting('expiry_alerts_enabled', val),
          ),
          _divider(colorScheme),
          _switchRow(
            context,
            Icons.inventory_2_rounded,
            'Low stock alerts',
            null,
            settings.lowStockAlertsEnabled,
            (val) => notifier.updateSetting('low_stock_alerts_enabled', val),
          ),
          _divider(colorScheme),
          _switchRow(
            context,
            Icons.notifications_rounded,
            'Dose reminders',
            null,
            settings.doseRemindersEnabled,
            (val) => notifier.updateSetting('dose_reminders_enabled', val),
          ),
          _divider(colorScheme),
          _navRow(
            context,
            Icons.bedtime_rounded,
            'Quiet hours',
            'Mute between ${settings.quietHoursStart} and ${settings.quietHoursEnd}',
            settings.quietHoursEnabled ? 'On' : 'Off',
            () => _showQuietHoursDialog(context, ref, settings),
          ),
          _divider(colorScheme),
          _navRow(
            context,
            Icons.music_note_rounded,
            'Notification sound',
            null,
            settings.notificationSound,
            () => _showSoundDialog(context, ref, settings),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultsGroup(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _navRow(
            context,
            Icons.schedule_rounded,
            'Default lead time',
            null,
            '${settings.defaultLeadTime} days',
            () => _showLeadTimeDialog(context, ref, settings),
          ),
          _divider(colorScheme),
          _navRow(
            context,
            Icons.inventory_2_rounded,
            'Low-stock threshold',
            null,
            '${settings.lowStockThreshold} units',
            () => _showThresholdDialog(context, ref, settings),
          ),
          _divider(colorScheme),
          _navRow(
            context,
            Icons.location_on_outlined,
            'Default location',
            null,
            settings.defaultLocation,
            () => _showLocationDialog(context, ref, settings),
          ),
        ],
      ),
    );
  }

  Widget _buildAIFeaturesGroup(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _navRow(
            context,
            Icons.auto_awesome_rounded,
            'Gemini API Key',
            settings.geminiApiKey != null && settings.geminiApiKey!.isNotEmpty
                ? 'Configured'
                : 'Not configured',
            null,
            () => _showGeminiKeyDialog(context, ref, settings),
          ),
        ],
      ),
    );
  }

  Widget _buildYourDataGroup(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _navRow(
            context,
            Icons.download_rounded,
            'Export as CSV',
            'Download your medicine list',
            null,
            () => _exportAsCSV(context, ref),
          ),
          _divider(colorScheme),
          _navRow(
            context,
            Icons.info_outline_rounded,
            'Medical disclaimer',
            null,
            null,
            () => _showDisclaimer(context),
          ),
          _divider(colorScheme),
          _dangerRow(context, ref),
        ],
      ),
    );
  }

  Widget _switchRow(BuildContext context, IconData icon, String label,
      String? sub, bool value, Function(bool) onChanged) {
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
          Switch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _navRow(BuildContext context, IconData icon, String label, String? sub,
      String? trailing, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
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

  Widget _dangerRow(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => _showResetConfirmation(context, ref),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
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

  // ─── Dialogs & Actions ──────────────────────────────────────────────────

  void _showQuietHoursDialog(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quiet hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Enable quiet hours'),
              value: settings.quietHoursEnabled,
              onChanged: (val) {
                notifier.updateSetting('quiet_hours_enabled', val);
                Navigator.pop(ctx);
                _showQuietHoursDialog(
                    context, ref, settings.copyWith(quietHoursEnabled: val));
              },
            ),
            ListTile(
              title: const Text('Start time'),
              trailing: Text(settings.quietHoursStart),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: int.parse(settings.quietHoursStart.split(':')[0]),
                    minute: int.parse(settings.quietHoursStart.split(':')[1]),
                  ),
                );
                if (time != null) {
                  notifier.updateSetting('quiet_hours_start',
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                }
              },
            ),
            ListTile(
              title: const Text('End time'),
              trailing: Text(settings.quietHoursEnd),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: int.parse(settings.quietHoursEnd.split(':')[0]),
                    minute: int.parse(settings.quietHoursEnd.split(':')[1]),
                  ),
                );
                if (time != null) {
                  notifier.updateSetting('quiet_hours_end',
                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}');
                  if (!ctx.mounted) return;
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showSoundDialog(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);
    final sounds = ['Soft chime', 'Bell', 'Digital', 'None'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Notification sound'),
        content: RadioGroup<String>(
          groupValue: settings.notificationSound,
          onChanged: (val) {
            if (val != null) notifier.updateSetting('notification_sound', val);
            Navigator.pop(ctx);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: sounds
                .map((s) => RadioListTile<String>(
                      title: Text(s),
                      value: s,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showLeadTimeDialog(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);
    final options = [1, 3, 7, 14, 30];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Default lead time'),
        content: RadioGroup<int>(
          groupValue: settings.defaultLeadTime,
          onChanged: (val) {
            if (val != null) notifier.updateSetting('default_lead_time', val);
            Navigator.pop(ctx);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((o) => RadioListTile<int>(
                      title: Text('$o days'),
                      value: o,
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }

  void _showThresholdDialog(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);
    final controller =
        TextEditingController(text: settings.lowStockThreshold.toString());

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Low-stock threshold'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(suffixText: 'units'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null) {
                notifier.updateSetting('low_stock_threshold', val);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLocationDialog(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);
    final controller = TextEditingController(text: settings.defaultLocation);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Default location'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. Kitchen'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              notifier.updateSetting('default_location', controller.text);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showGeminiKeyDialog(
      BuildContext context, WidgetRef ref, SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);
    final controller = TextEditingController(text: settings.geminiApiKey ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Gemini API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your Google Gemini API key to automatically fetch AI summaries for medicines.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'AIzaSy...',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              notifier.updateSetting('gemini_api_key', '');
              Navigator.pop(ctx);
            },
            child: const Text('Clear'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              notifier.updateSetting('gemini_api_key', controller.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDisclaimer(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Medical Disclaimer'),
        content: const SingleChildScrollView(
          child: Text(
            'Tiny-Meds is a tool for personal health organization and does not provide medical advice, diagnosis, or treatment. '
            'Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition. '
            'Never disregard professional medical advice or delay in seeking it because of something you have read or tracked in this application.\n\n'
            'The accuracy of the data entered is the responsibility of the user. Do not rely solely on notifications for critical medication timing.',
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('I understand')),
        ],
      ),
    );
  }

  Future<void> _exportAsCSV(BuildContext context, WidgetRef ref) async {
    final repository = ref.read(medicineRepositoryProvider);
    final medicines = await repository.watchAllMedicines().first;

    if (medicines.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No medicines to export')),
        );
      }
      return;
    }

    final profiles = await ref.read(profilesProvider.future);

    final List<List<dynamic>> rows = [];

    // Add header
    rows.add([
      'Name',
      'Brand',
      'Form',
      'Strength',
      'Quantity',
      'Unit',
      'Expiry Date',
      'Location',
      'Profile Name',
      'Profile Color'
    ]);

    for (final m in medicines) {
      final profile = profiles.firstWhere((p) => p.id == m.profileId,
          orElse: () => profiles.first);

      rows.add([
        m.name,
        m.brand ?? '',
        m.form.name,
        m.strength ?? '',
        m.quantity,
        m.unit,
        m.expiryDate.toIso8601String().split('T')[0],
        m.location ?? '',
        profile.name,
        profile.colorValue
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/tiny_meds_export.csv');
    await file.writeAsString(csv);

    if (context.mounted) {
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Export saved to device'),
            action: SnackBarAction(
              label: 'Share',
              onPressed: () {
                SharePlus.instance.share(ShareParams(
                  files: [XFile(finalPath)],
                  subject: 'My Tiny-Meds Cabinet Export',
                ));
              },
            ),
          ),
        );
      }
    }
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
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
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final repository = ref.read(medicineRepositoryProvider);
              await repository.clearAllData();
              if (context.mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cabinet reset successfully')),
                );
              }
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
