import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../domain/entities/alert.dart';
import '../../../domain/entities/medicine.dart';
import '../../providers/inventory_provider.dart';

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

  static const _orange = Color(0xFFFF9800);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final medicinesAsync = ref.watch(allMedicinesProvider);
    final alertsAsync = ref.watch(activeAlertsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: medicinesAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Error loading medicines',
                style: TextStyle(color: colorScheme.error)),
          ),
          data: (medicines) => alertsAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('Error loading alerts',
                  style: TextStyle(color: colorScheme.error)),
            ),
            data: (alerts) =>
                _buildContent(context, medicines, alerts),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Medicine> medicines,
    List<Alert> alerts,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();

    final expiredMeds = medicines
        .where((m) => m.isExpired && !m.isDisposed)
        .toList();
    final lowStockMeds = medicines
        .where((m) => m.isLowStock && !m.isExpired && !m.isDisposed)
        .toList();
    final upcomingAlerts = alerts
        .where((a) => a.triggerDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.triggerDate.compareTo(b.triggerDate));

    // Apply filter
    final filteredExpired =
        (_selectedFilter == 'all' || _selectedFilter == 'expiry')
            ? expiredMeds
            : <Medicine>[];
    final filteredLowStock =
        (_selectedFilter == 'all' || _selectedFilter == 'low_stock')
            ? lowStockMeds
            : <Medicine>[];
    final filteredUpcoming = upcomingAlerts.where((a) {
      switch (_selectedFilter) {
        case 'expiry':
          return a.type == AlertType.expiry;
        case 'low_stock':
          return a.type == AlertType.lowStock;
        case 'doses':
          return a.type == AlertType.doseReminder;
        default:
          return true;
      }
    }).toList();

    final todayCount = filteredExpired.length + filteredLowStock.length;
    final upcomingCount = filteredUpcoming.length;

    final hasAnyAlerts = expiredMeds.isNotEmpty ||
        lowStockMeds.isNotEmpty ||
        upcomingAlerts.isNotEmpty;

    String subtitle;
    if (!hasAnyAlerts) {
      subtitle = 'All clear';
    } else {
      final parts = <String>[];
      if (filteredExpired.isNotEmpty || filteredLowStock.isNotEmpty) {
        parts.add('$todayCount today');
      }
      if (filteredUpcoming.isNotEmpty) {
        parts.add('$upcomingCount coming up');
      }
      subtitle = parts.isEmpty ? 'All clear' : parts.join(' · ');
    }

    return Column(
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
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
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
              _filterChip(
                  context, 'expiry', 'Expiry', Icons.access_time_rounded),
              const SizedBox(width: 8),
              _filterChip(context, 'low_stock', 'Low stock',
                  Icons.inventory_2_rounded),
              const SizedBox(width: 8),
              _filterChip(
                  context, 'doses', 'Doses', Icons.notifications_rounded),
            ],
          ),
        ),

        // ── Alert list ────────────────────────────────────────
        if (!hasAnyAlerts)
          Expanded(child: _buildEmptyState(context))
        else if (todayCount == 0 && upcomingCount == 0)
          Expanded(child: _buildFilteredEmptyState(context))
        else
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                if (filteredExpired.isNotEmpty ||
                    filteredLowStock.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 4, 12),
                    child: Text(
                      'TODAY',
                      style:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: colorScheme.error,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                  for (final m in filteredExpired) ...[
                    _buildExpiredCard(context, m),
                    const SizedBox(height: 8),
                  ],
                  for (final m in filteredLowStock) ...[
                    _buildLowStockCard(context, m),
                    const SizedBox(height: 8),
                  ],
                  const SizedBox(height: 16),
                ],
                if (filteredUpcoming.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 12),
                    child: Text(
                      'UPCOMING',
                      style:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                  ),
                  for (int i = 0; i < filteredUpcoming.length; i++) ...[
                    _buildUpcomingCard(
                        context, filteredUpcoming[i], medicines),
                    if (i < filteredUpcoming.length - 1)
                      const SizedBox(height: 8),
                  ],
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              'All clear',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'No expired, low-stock, or upcoming alerts.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilteredEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Text(
        'No alerts match this filter.',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }

  Widget _buildExpiredCard(BuildContext context, Medicine medicine) {
    final colorScheme = Theme.of(context).colorScheme;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final expiryLabel =
        'Expired ${months[medicine.expiryDate.month - 1]} ${medicine.expiryDate.day}';
    final subtitle = medicine.location != null
        ? '$expiryLabel · ${medicine.location}'
        : expiryLabel;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: colorScheme.error, width: 4)),
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
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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
    final stockLabel =
        'About ${medicine.quantity} ${medicine.unit} left';
    final subtitle = medicine.location != null
        ? '$stockLabel · ${medicine.location}'
        : stockLabel;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: const Border(left: BorderSide(color: _orange, width: 4)),
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
                  color: _orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_rounded,
                    color: _orange, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${medicine.name} running low',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
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

  Widget _buildUpcomingCard(
    BuildContext context,
    Alert alert,
    List<Medicine> medicines,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final medicine =
        medicines.where((m) => m.id == alert.medicineId).firstOrNull;
    final name = medicine?.name ?? 'Medicine';

    final icon = switch (alert.type) {
      AlertType.expiry => Icons.access_time_rounded,
      AlertType.lowStock => Icons.inventory_2_rounded,
      AlertType.doseReminder => Icons.notifications_rounded,
    };

    final title = switch (alert.type) {
      AlertType.expiry => '$name expires soon',
      AlertType.lowStock => '$name running low',
      AlertType.doseReminder =>
        alert.recurrence == RecurrencePattern.daily
            ? '$name · daily'
            : '$name reminder',
    };

    final subtitle = switch (alert.type) {
      AlertType.expiry => _expirySubtitle(alert.triggerDate),
      AlertType.lowStock => 'Low stock alert',
      AlertType.doseReminder => _doseSubtitle(alert),
    };

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
            child:
                Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
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
            _formatWhen(alert.triggerDate),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  String _expirySubtitle(DateTime triggerDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(
        triggerDate.year, triggerDate.month, triggerDate.day);
    final diff = target.difference(today).inDays;
    final dateLabel = _shortDate(triggerDate);
    if (diff == 0) return 'Expires today · $dateLabel';
    if (diff == 1) return 'In 1 day · $dateLabel';
    return 'In $diff days · $dateLabel';
  }

  String _doseSubtitle(Alert alert) {
    final h = alert.triggerDate.hour;
    final m = alert.triggerDate.minute.toString().padLeft(2, '0');
    final period = h >= 12 ? 'PM' : 'AM';
    final display = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    if (alert.recurrence == RecurrencePattern.daily) {
      return 'Every day at $display:$m $period';
    }
    return 'At $display:$m $period';
  }

  String _formatWhen(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;

    if (diff == 0) {
      final h = date.hour;
      final m = date.minute.toString().padLeft(2, '0');
      final display = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      return '$display:$m';
    } else if (diff <= 6) {
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      return days[(date.weekday - 1) % 7];
    } else {
      return _shortDate(date);
    }
  }

  String _shortDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
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
      onSelected: (v) =>
          setState(() => _selectedFilter = v ? key : 'all'),
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedColor: colorScheme.surfaceContainerHigh,
      showCheckmark: selected && icon == null,
      side: selected
          ? BorderSide.none
          : BorderSide(color: colorScheme.outline),
      labelStyle: TextStyle(
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        color:
            selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
        fontSize: 14,
      ),
    );
  }
}
