import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Settings screen - App preferences and configuration
/// Matches design spec 08-Settings
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
          children: [
            // Header
            Text(
              'Settings',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            
            // You card
            _buildYouCard(context),
            const SizedBox(height: 24),
            
            // Notifications group
            Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 8),
            _buildNotificationsGroup(context),
            const SizedBox(height: 24),
            
            // Defaults group
            Text(
              'Defaults',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 8),
            _buildDefaultsGroup(context),
            const SizedBox(height: 24),
            
            // Your data group
            Text(
              'Your data',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 8),
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
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 3,
        onDestinationSelected: (index) {
          // Handle navigation
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Cabinet'),
          NavigationDestination(icon: Icon(Icons.notifications_rounded), label: 'Alerts'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildYouCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      color: colorScheme.primaryContainer,
      child: ListTile(
        leading: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'P',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        title: Text(
          'Your cabinet',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          '22 medicines · since April 2026',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () {
          // Navigate to profile
        },
      ),
    );
  }

  Widget _buildNotificationsGroup(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.access_time_rounded),
            title: const Text('Expiry alerts'),
            value: true,
            onChanged: (value) {},
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          SwitchListTile(
            secondary: const Icon(Icons.inventory_2_rounded),
            title: const Text('Low stock alerts'),
            value: true,
            onChanged: (value) {},
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_rounded),
            title: const Text('Dose reminders'),
            value: false,
            onChanged: (value) {},
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          ListTile(
            leading: const Icon(Icons.bedtime_rounded),
            title: const Text('Quiet hours'),
            subtitle: const Text('Mute between 10:00 PM and 7:00 AM'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          ListTile(
            leading: const Icon(Icons.music_note_rounded),
            title: const Text('Notification sound'),
            subtitle: const Text('Soft chime'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultsGroup(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.schedule_rounded),
            title: const Text('Default lead time'),
            subtitle: const Text('7 days'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          ListTile(
            leading: const Icon(Icons.inventory_2_rounded),
            title: const Text('Low-stock threshold'),
            subtitle: const Text('3 doses'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          ListTile(
            leading: const Icon(Icons.location_on_rounded),
            title: const Text('Default location'),
            subtitle: const Text('Kitchen'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildYourDataGroup(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.download_rounded, color: colorScheme.primary),
            title: const Text('Export as CSV'),
            subtitle: const Text('Download your medicine list'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('Medical disclaimer'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          ListTile(
            leading: Icon(Icons.delete_forever_rounded, color: colorScheme.error),
            title: Text(
              'Reset cabinet',
              style: TextStyle(color: colorScheme.error),
            ),
            subtitle: const Text('Permanently delete all data'),
            trailing: Icon(Icons.chevron_right_rounded, color: colorScheme.error),
            onTap: () {
              _showResetConfirmation(context);
            },
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset cabinet?'),
        content: const Text(
          'This will permanently delete all your medicine data. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Reset all data
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
