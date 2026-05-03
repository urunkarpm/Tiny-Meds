import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Alerts screen - Shows expiry, low stock, and dose alerts
/// Matches design spec 06-Alerts
class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Column(
        children: [
          // Large top app bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alerts',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '2 today · 3 coming up',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search_rounded),
                      onPressed: () {},
                      color: colorScheme.onSurface,
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert_rounded),
                      onPressed: () {},
                      color: colorScheme.onSurface,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('all', 'All', Icons.filter_list_rounded, true),
                const SizedBox(width: 8),
                _buildFilterChip('expiry', 'Expiry', Icons.access_time_rounded, false),
                const SizedBox(width: 8),
                _buildFilterChip('low_stock', 'Low stock', Icons.inventory_2_rounded, false),
                const SizedBox(width: 8),
                _buildFilterChip('doses', 'Doses', Icons.notifications_rounded, false),
              ],
            ),
          ),
          // Alert list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
              children: [
                // TODAY section
                Row(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      size: 16,
                      color: colorScheme.error,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'TODAY',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.error,
                            letterSpacing: 1,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Expired alert card
                _buildExpiredAlertCard(context),
                const SizedBox(height: 12),
                // Low stock alert card
                _buildLowStockAlertCard(context),
                const SizedBox(height: 24),
                // UPCOMING section
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'UPCOMING',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 1,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Upcoming alerts
                _buildUpcomingAlertCard(
                  context,
                  'Amoxicillin expires soon',
                  'In 4 days · May 7',
                  Icons.access_time_rounded,
                ),
                _buildUpcomingAlertCard(
                  context,
                  'Vitamin D3 · daily',
                  'Every day at 9:00 AM',
                  Icons.notifications_rounded,
                ),
                _buildUpcomingAlertCard(
                  context,
                  'Ibuprofen expires',
                  'In 3 weeks · May 24',
                  Icons.access_time_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
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

  Widget _buildFilterChip(String key, String label, IconData icon, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return FilterChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      selected: _selectedFilter == key,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? key : 'all';
        });
      },
      selectedColor: isSelected && _selectedFilter == key 
          ? colorScheme.primary 
          : null,
      labelStyle: TextStyle(
        fontWeight: _selectedFilter == key ? FontWeight.w600 : FontWeight.normal,
        color: _selectedFilter == key && isSelected
            ? colorScheme.onPrimary
            : null,
      ),
    );
  }

  Widget _buildExpiredAlertCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colorScheme.error,
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.errorContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: colorScheme.error,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loratadine expired',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Expired Mar 14 · Kitchen drawer',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '2h ago',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Toss & remove'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Snooze'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLowStockAlertCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final expireSoonColor = const Color(0xFFFF9800);
    
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: expireSoonColor,
              width: 4,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: expireSoonColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2_rounded,
                      color: expireSoonColor,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cough Syrup running low',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'About 2 doses left · Bathroom',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  FilledButton(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Add to shopping'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Mark refilled'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingAlertCard(BuildContext context, String title, String subtitle, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      child: ListTile(
        leading: Icon(icon, color: colorScheme.onSurfaceVariant),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          '',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
        ),
      ),
    );
  }
}
