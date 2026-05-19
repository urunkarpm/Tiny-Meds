import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/enums.dart';
import '../../../domain/entities/medicine.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/med_tile.dart';
import '../../widgets/status_pill.dart';
import 'widgets/medicine_list_item.dart';
import 'widgets/add_medicine_bottom_sheet.dart';
import '../search/search_screen.dart';
import '../alerts/set_alert_screen.dart';
import '../../widgets/profile_switcher.dart';

/// Cabinet home screen — main medicine inventory list
/// Design spec: 02-Cabinet
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  MedicineStatus _selectedFilter = MedicineStatus.all;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final medicinesAsync = ref.watch(filteredMedicinesProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: medicinesAsync.when(
        data: (medicines) => _buildBody(context, medicines),
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (error, _) => Center(
          child:
              Text('Error: $error', style: TextStyle(color: colorScheme.error)),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMedicineSheet,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add medicine'),
        tooltip: 'Add medicine',
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<Medicine> medicines) {
    final colorScheme = Theme.of(context).colorScheme;
    final expiredCount = medicines.where((m) => m.isExpired).length;
    final lowStockCount =
        medicines.where((m) => m.isLowStock && !m.isExpired).length;
    final attentionCount = expiredCount + lowStockCount;

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // ── Large top app bar ──────────────────────────────────────
          Container(
            color: colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icons row
                Row(
                  children: [
                    const ProfileSwitcher(),
                    const Spacer(),
                    Semantics(
                      label: 'Search medicines',
                      child: IconButton(
                        icon: const Icon(Icons.search_rounded),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreen()),
                        ),
                        tooltip: 'Search',
                      ),
                    ),
                    Semantics(
                      label: attentionCount > 0
                          ? '$attentionCount alerts need attention'
                          : 'Alerts',
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            onPressed: () {
                              ref.read(bottomNavProvider.notifier).state = 1;
                            },
                            tooltip: 'Alerts',
                          ),
                          if (attentionCount > 0)
                            Positioned(
                              top: 10,
                              right: 10,
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(bottomNavProvider.notifier).state =
                                      1;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 0),
                                  constraints: const BoxConstraints(
                                      minWidth: 16, minHeight: 16),
                                  decoration: BoxDecoration(
                                    color: colorScheme.error,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$attentionCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Title block
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cabinet',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        attentionCount > 0
                            ? '${medicines.length} medicines in total\n$attentionCount items need your attention'
                            : '${medicines.length} medicines tracked',
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

          // ── Filter chips row ────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              children: [
                _buildFilterChip(
                    context, MedicineStatus.all, 'All · ${medicines.length}'),
                const SizedBox(width: 8),
                _buildFilterChip(
                    context, MedicineStatus.expiringSoon, 'Expiring'),
                const SizedBox(width: 8),
                _buildFilterChip(context, MedicineStatus.lowStock, 'Low stock'),
                const SizedBox(width: 8),
                _buildFilterChip(context, MedicineStatus.expired, 'Expired'),
                const SizedBox(width: 8),
                _buildLocationChip(context, medicines),
              ],
            ),
          ),

          // ── Scrollable list ─────────────────────────────────────
          Expanded(
            child: medicines.isEmpty
                ? _buildEmptyState(context)
                : RefreshIndicator(
                    onRefresh: () async =>
                        await Future.delayed(const Duration(milliseconds: 300)),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                      children: [
                        // Attention card
                        if (attentionCount > 0) ...[
                          _buildAttentionCard(
                              context, expiredCount, lowStockCount),
                          const SizedBox(height: 16),
                        ],
                        // Section header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                'Recently added',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              InkWell(
                                onTap: () {
                                  final current = ref.read(sortOrderProvider);
                                  ref.read(sortOrderProvider.notifier).state =
                                      current == SortOrder.name
                                          ? SortOrder.expiryDate
                                          : SortOrder.name;
                                },
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  child: Text(
                                    'SORT: ${ref.watch(sortOrderProvider).displayName}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Medicine list items
                        ...medicines.map(
                          (m) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: MedicineListItem(
                              medicine: m,
                              onTap: () => _showDetail(context, m),
                              onEdit: () => _showEditSheet(m),
                              onDelete: () => _confirmDelete(context, m),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context, MedicineStatus status, String label) {
    final isSelected = _selectedFilter == status;
    final colorScheme = Theme.of(context).colorScheme;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? status : MedicineStatus.all;
        });
        ref.read(filterStatusProvider.notifier).state =
            selected ? status : MedicineStatus.all;
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedColor: colorScheme.surfaceContainerHigh,
      checkmarkColor: colorScheme.onSurface,
      labelStyle: TextStyle(
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color:
            isSelected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
        fontSize: 14,
      ),
      side:
          isSelected ? BorderSide.none : BorderSide(color: colorScheme.outline),
      showCheckmark: isSelected,
    );
  }

  Widget _buildLocationChip(BuildContext context, List<Medicine> medicines) {
    final colorScheme = Theme.of(context).colorScheme;
    final locations = medicines
        .map((m) => m.location)
        .whereType<String>()
        .where((l) => l.isNotEmpty)
        .toSet()
        .toList()
      ..sort();

    return PopupMenuButton<String>(
      tooltip: 'Filter by location',
      onSelected: (loc) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Filtering by $loc (Coming soon)')),
        );
      },
      itemBuilder: (context) => locations.isEmpty
          ? [
              const PopupMenuItem(
                  enabled: false, child: Text('No locations found'))
            ]
          : locations
              .map((loc) => PopupMenuItem(value: loc, child: Text(loc)))
              .toList(),
      child: FilterChip(
        avatar: Icon(Icons.location_on_outlined,
            size: 16, color: colorScheme.onSurfaceVariant),
        label: const Text('By location'),
        selected: false,
        onSelected: (_) {}, // Handled by PopupMenuButton
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
        side: BorderSide(color: colorScheme.outline),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildAttentionCard(
      BuildContext context, int expiredCount, int lowStockCount) {
    final colorScheme = Theme.of(context).colorScheme;
    final total = expiredCount + lowStockCount;
    final parts = <String>[];
    if (expiredCount > 0) {
      parts.add('$expiredCount expired');
    }
    if (lowStockCount > 0) {
      parts.add('$lowStockCount running low');
    }

    return InkWell(
      onTap: () {
        ref.read(bottomNavProvider.notifier).state = 1;
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.error, width: 2),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.error,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_rounded,
                  color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$total ${total == 1 ? 'item needs' : 'items need'} attention',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    parts.join(' · '),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: colorScheme.onErrorContainer, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.medication_outlined,
              size: 64,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'No medicines yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Tap the button below to add your first medicine and start tracking your inventory.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMedicineSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const AddMedicineBottomSheet(),
    );
  }

  void _showEditSheet(Medicine medicine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddMedicineBottomSheet(medicine: medicine),
    );
  }

  void _showDetail(BuildContext context, Medicine medicine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedicineDetailScreen(medicine: medicine),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Medicine medicine) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete medicine'),
        content: Text('Delete "${medicine.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(inventoryProvider.notifier).deleteMedicine(medicine.id!);
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Medicine detail screen ────────────────────────────────────────────────────
/// Design spec: 04-Detail
class MedicineDetailScreen extends ConsumerStatefulWidget {
  final Medicine medicine;
  const MedicineDetailScreen({super.key, required this.medicine});

  @override
  ConsumerState<MedicineDetailScreen> createState() =>
      _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends ConsumerState<MedicineDetailScreen> {
  late Medicine _medicine;

  @override
  void initState() {
    super.initState();
    _medicine = widget.medicine;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final days = _medicine.daysUntilExpiry;
    final statusColor = _getStatusColor(colorScheme, days);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── App bar ─────────────────────────────────────────────
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  Semantics(
                    label: 'Back',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Back',
                    ),
                  ),
                  const Spacer(),
                  Semantics(
                    label: 'Edit medicine',
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showEditSheet(context),
                      tooltip: 'Edit',
                    ),
                  ),
                  Semantics(
                    label: 'More options',
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded),
                      tooltip: 'More options',
                      onSelected: (value) {
                        if (value == 'delete') _confirmDelete(context);
                        if (value == 'dispose') {
                          ref
                              .read(inventoryProvider.notifier)
                              .markAsDisposed(_medicine.id!);
                          Navigator.pop(context);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          value: 'dispose',
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded,
                                  color: colorScheme.primary, size: 20),
                              const SizedBox(width: 12),
                              const Text('Mark as disposed'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded,
                                  color: colorScheme.error, size: 20),
                              const SizedBox(width: 12),
                              Text('Delete',
                                  style: TextStyle(color: colorScheme.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable body ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero block
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MedTile(
                                form: _medicine.form.name,
                                hue: _medicine.medHue,
                                size: 88,
                                rounded: 22,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _medicine.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        [
                                          if (_medicine.strength != null)
                                            _medicine.strength!,
                                          _medicine.form.displayName,
                                        ].join(' · '),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                      if (_medicine.brand != null) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          'by ${_medicine.brand}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      StatusPill(
                                        kind: _medicine.statusPillKind,
                                        label: _medicine.statusPillLabel,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Stat cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  label: 'QUANTITY',
                                  value: '${_medicine.quantity}',
                                  unit: _medicine.unit,
                                  progress: _medicine.lowStockThreshold != null
                                      ? (_medicine.quantity /
                                              (_medicine.lowStockThreshold! *
                                                  3))
                                          .clamp(0.0, 1.0)
                                      : null,
                                  progressColor: statusColor,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildExpiryCard(
                                    context, days, statusColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Details list
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Details',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                if (_medicine.location != null)
                                  _buildDetailRow(
                                    context,
                                    icon: Icons.location_on_outlined,
                                    label: 'Where',
                                    value: _medicine.location!,
                                    isLast: false,
                                  ),
                                if (_medicine.openedDate != null)
                                  _buildDetailRow(
                                    context,
                                    icon: Icons.calendar_today_outlined,
                                    label: 'Opened',
                                    value: _formatDate(_medicine.openedDate!),
                                    isLast: false,
                                  ),
                                _buildDetailRow(
                                  context,
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Expires',
                                  value: _formatDate(_medicine.expiryDate),
                                  isLast: _medicine.lowStockThreshold == null,
                                ),
                                if (_medicine.lowStockThreshold != null)
                                  _buildDetailRow(
                                    context,
                                    icon: Icons.inventory_2_outlined,
                                    label: 'Alert below',
                                    value:
                                        '${_medicine.lowStockThreshold} ${_medicine.unit}',
                                    isLast: _medicine.frequency == null &&
                                        _medicine.doseAmount == null,
                                  ),
                                if (_medicine.doseAmount != null)
                                  _buildDetailRow(
                                    context,
                                    icon: Icons.medication_outlined,
                                    label: 'Dose',
                                    value:
                                        '${_medicine.doseAmount} ${_medicine.unit}',
                                    isLast: _medicine.frequency == null,
                                  ),
                                if (_medicine.frequency != null)
                                  _buildDetailRow(
                                    context,
                                    icon: Icons.repeat_rounded,
                                    label: 'Frequency',
                                    value: '${_medicine.frequency} times / day',
                                    isLast: true,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // AI Summary section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Summary',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          _buildAISummaryCard(context, ref),
                        ],
                      ),
                    ),

                    // Alerts section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Alerts',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SetAlertScreen(medicine: _medicine),
                                  ),
                                ),
                                child: const Text('+ Add alert'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.notifications_outlined,
                                    color: colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'No alerts set up yet.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Sticky footer ────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border:
                    Border(top: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _takeDose,
                      icon: const Icon(Icons.remove_rounded, size: 18),
                      label: const Text('Take dose'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _showEditSheet(context),
                      style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 48)),
                      child: const Text('Refill'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
    double? progress,
    required Color progressColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 6),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: colorScheme.outlineVariant,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExpiryCard(BuildContext context, int days, Color statusColor) {
    final colorScheme = Theme.of(context).colorScheme;
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final expDate = _medicine.expiryDate;
    final expLabel =
        '${months[expDate.month - 1]} ${expDate.day}, ${expDate.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPIRES',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                days < 0 ? '–' : '$days',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
              ),
              if (days >= 0) ...[
                const SizedBox(width: 6),
                Text(
                  days == 1 ? 'day' : 'days',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            days < 0 ? 'Expired' : expLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isLast,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            indent: 50,
            color: colorScheme.outlineVariant,
          ),
      ],
    );
  }

  Widget _buildAISummaryCard(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsAsync = ref.watch(settingsProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: settingsAsync.when(
        data: (settings) {
          final apiKey = settings.geminiApiKey;

          if (_medicine.summary != null && _medicine.summary!.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _medicine.summary!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (_medicine.chemicalComposition != null &&
                    _medicine.chemicalComposition!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Composition',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _medicine.chemicalComposition!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ],
            );
          } else if (apiKey == null || apiKey.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI summaries are not configured.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    // Navigate to settings tab (index 3)
                    Navigator.pop(context); // Close detail screen
                    ref.read(bottomNavProvider.notifier).state = 3;
                  },
                  icon: const Icon(Icons.settings_outlined, size: 18),
                  label: const Text('Configure in Settings'),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Generating AI Summary...',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            );
          }
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        ),
        error: (err, _) => Text(
          'Error loading settings',
          style: TextStyle(color: colorScheme.error),
        ),
      ),
    );
  }

  Color _getStatusColor(ColorScheme cs, int days) {
    if (days < 0) return cs.error;
    if (days == 0) return Colors.red;
    if (days <= AppConstants.expiringVerySoonThresholdDays) {
      return const Color(0xFFFF9800);
    }
    if (days <= AppConstants.expiringSoonThresholdDays) {
      return const Color(0xFFFFA726);
    }
    return cs.primary;
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _takeDose() {
    final dose = _medicine.doseAmount ?? 1.0;
    if (_medicine.quantity < dose) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Not enough ${_medicine.unit} for a full dose.')),
      );
      return;
    }

    final newQuantity = (_medicine.quantity - dose).toInt();
    bool needsRefill = _medicine.needsRefill;
    if (_medicine.lowStockThreshold != null &&
        newQuantity <= _medicine.lowStockThreshold!) {
      needsRefill = true;
    }

    final updated = _medicine.copyWith(
      quantity: newQuantity,
      needsRefill: needsRefill,
    );
    ref.read(inventoryProvider.notifier).updateMedicine(updated);
    setState(() => _medicine = updated);
  }

  void _showEditSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => AddMedicineBottomSheet(medicine: _medicine),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete medicine'),
        content: Text('Delete "${_medicine.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(inventoryProvider.notifier)
                  .deleteMedicine(_medicine.id!);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
