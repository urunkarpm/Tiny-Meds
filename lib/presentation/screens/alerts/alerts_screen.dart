import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Alerts screen — expiry, low stock, dose alerts
/// Design spec: 06-Alerts
/// Nav bar is provided by MainShell — not rendered here.
class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  String _selectedFilter = 'all';

  static const _expireSoon = Color(0xFFFF9800);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Large top app bar ─────────────────────────────────
            Container(
              color: colorScheme.surface,
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      Semantics(
                        label: 'Search alerts',
                        child: IconButton(
                          icon: const Icon(Icons.search_rounded),
                          onPressed: () {},
                          tooltip: 'Search',
                        ),
                      ),
                      Semantics(
                        label: 'More options',
                        child: IconButton(
                          icon: const Icon(Icons.more_vert_rounded),
                          onPressed: () {},
                          tooltip: 'More',
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Alerts',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '2 today · 3 coming up',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Filter chips ─────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                children: [
                  _filterChip(context, 'all', 'All', null),
                  const SizedBox(width: 8),
                  _filterChip(context, 'expiry', 'Expiry',
                      Icons.access_time_rounded),
                  const SizedBox(width: 8),
                  _filterChip(context, 'low_stock', 'Low stock',
                      Icons.inventory_2_rounded),
                  const SizedBox(width: 8),
                  _filterChip(context, 'doses', 'Doses',
                      Icons.notifications_rounded),
                ],
              ),
            ),

            // ── Alert list ────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                children: [
                  // TODAY section header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
                    child: Text(
                      'TODAY',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.error,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),

                  // Expired alert card
                  _buildExpiredCard(context),
                  const SizedBox(height: 8),

                  // Low-stock card
                  _buildLowStockCard(context),
                  const SizedBox(height: 24),

                  // UPCOMING section header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                    child: Text(
                      'UPCOMING',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),

                  _buildUpcomingCard(
                    context,
                    icon: Icons.access_time_rounded,
                    title: 'Amoxicillin expires soon',
                    subtitle: 'In 4 days · May 7',
                    when: 'Wed',
                  ),
                  const SizedBox(height: 8),
                  _buildUpcomingCard(
                    context,
                    icon: Icons.notifications_rounded,
                    title: 'Vitamin D3 · daily',
                    subtitle: 'Every day at 9:00 AM',
                    when: '9:00',
                  ),
                  const SizedBox(height: 8),
                  _buildUpcomingCard(
                    context,
                    icon: Icons.access_time_rounded,
                    title: 'Ibuprofen expires',
                    subtitle: 'In 3 weeks · May 24',
                    when: 'May 24',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(
      BuildContext context, String key, String label, IconData? icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _selectedFilter == key;
    return FilterChip(
      avatar: icon != null
          ? Icon(icon,
              size: 16,
              color: selected
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant)
          : null,
      label: Text(label),
      selected: selected,
      onSelected: (v) => setState(() => _selectedFilter = v ? key : 'all'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedColor: colorScheme.surfaceContainerHigh,
      showCheckmark: selected && icon == null,
      side: selected
          ? BorderSide.none
          : BorderSide(color: colorScheme.outline),
      labelStyle: TextStyle(
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
        fontSize: 14,
      ),
    );
  }

  Widget _buildExpiredCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(
            left: BorderSide(color: colorScheme.error, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.warning_rounded,
                    color: colorScheme.error, size: 22),
              ),
              const SizedBox(width: 12),
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
              Text(
                '2h ago',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 52),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  Widget _buildLowStockCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: const Border(
            left: BorderSide(color: _expireSoon, width: 4)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _expireSoon.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_rounded,
                    color: _expireSoon, size: 22),
              ),
              const SizedBox(width: 12),
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
              Text(
                '5h ago',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 52),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }

  Widget _buildUpcomingCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String when,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          Text(
            when,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
