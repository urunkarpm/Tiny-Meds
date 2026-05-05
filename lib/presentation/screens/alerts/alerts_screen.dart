import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/date_utils.dart' as app_date_utils;
import '../../../data/models/enums.dart';
import '../../../domain/entities/medicine.dart';
import '../../../domain/entities/alert.dart';
import '../../providers/inventory_provider.dart';

/// Alerts screen — expiry, low stock, dose alerts
/// Design spec: 06-Alerts
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
    
    final expiredAsync = ref.watch(expiredMedicinesProvider);
    final lowStockAsync = ref.watch(lowStockMedicinesProvider);
    final upcomingAsync = ref.watch(activeAlertsProvider);

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
                        _buildSummaryText(expiredAsync, lowStockAsync, upcomingAsync),
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
              child: _buildAlertList(context, expiredAsync, lowStockAsync, upcomingAsync),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryText(
      AsyncValue<List<Medicine>> expired,
      AsyncValue<List<Medicine>> lowStock,
      AsyncValue<List<Alert>> upcoming) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return expired.when(
      data: (exp) {
        return lowStock.when(
          data: (low) {
            return upcoming.when(
              data: (up) {
                final totalToday = exp.length + low.length;
                final totalUpcoming = up.length;
                
                if (totalToday == 0 && totalUpcoming == 0) {
                  return Text(
                    'No active alerts',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: colorScheme.onSurfaceVariant),
                  );
                }
                
                String text = '';
                if (totalToday > 0) {
                  text += '$totalToday today';
                }
                if (totalUpcoming > 0) {
                  if (text.isNotEmpty) text += ' · ';
                  text += '$totalUpcoming coming up';
                }
                
                return Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildAlertList(
      BuildContext context,
      AsyncValue<List<Medicine>> expired,
      AsyncValue<List<Medicine>> lowStock,
      AsyncValue<List<Alert>> upcoming) {
    
    return expired.when(
      data: (expItems) => lowStock.when(
        data: (lowItems) => upcoming.when(
          data: (upItems) {
            final filteredExp = _selectedFilter == 'all' || _selectedFilter == 'expiry' ? expItems : [];
            final filteredLow = _selectedFilter == 'all' || _selectedFilter == 'low_stock' ? lowItems : [];
            final filteredUp = upItems.where((a) {
              if (_selectedFilter == 'all') return true;
              if (_selectedFilter == 'expiry' && a.type == AlertType.expiry) return true;
              if (_selectedFilter == 'doses' && a.type == AlertType.doseReminder) return true;
              return false;
            }).toList();

            if (filteredExp.isEmpty && filteredLow.isEmpty && filteredUp.isEmpty) {
              return _buildEmptyState(context);
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                if (filteredExp.isNotEmpty || filteredLow.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
                    child: Text(
                      'TODAY',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  ...filteredExp.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildExpiredCard(context, m),
                  )),
                  ...filteredLow.map((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildLowStockCard(context, m),
                  )),
                  const SizedBox(height: 16),
                ],

                if (filteredUp.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                    child: Text(
                      'UPCOMING',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  ...filteredUp.map((a) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildUpcomingCard(context, a),
                  )),
                ],
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, 
              size: 64, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No alerts found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
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

  Widget _buildExpiredCard(BuildContext context, Medicine medicine) {
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
                      '${medicine.name} expired',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Expired ${DateFormat('MMM d').format(medicine.expiryDate)}${medicine.location != null ? ' · ${medicine.location}' : ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 52),
              FilledButton(
                onPressed: () => ref.read(inventoryProvider.notifier).markAsDisposed(medicine.id!),
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

  Widget _buildLowStockCard(BuildContext context, Medicine medicine) {
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
                      '${medicine.name} running low',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${medicine.quantity} ${medicine.unit} left${medicine.location != null ? ' · ${medicine.location}' : ''}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
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

  Widget _buildUpcomingCard(BuildContext context, Alert alert) {
    final colorScheme = Theme.of(context).colorScheme;
    
    IconData icon;
    String title = '';
    String subtitle = '';
    
    switch (alert.type) {
      case AlertType.expiry:
        icon = Icons.access_time_rounded;
        title = 'Medicine expires soon';
        subtitle = 'In ${alert.triggerDate.difference(DateTime.now()).inDays} days · ${DateFormat('MMM d').format(alert.triggerDate)}';
        break;
      case AlertType.doseReminder:
        icon = Icons.notifications_rounded;
        title = 'Dose reminder';
        subtitle = alert.recurrence?.displayName ?? 'One-time';
        break;
      case AlertType.lowStock:
        icon = Icons.inventory_2_rounded;
        title = 'Low stock alert';
        subtitle = 'Triggered when quantity low';
        break;
    }

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
            DateFormat('E').format(alert.triggerDate),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
