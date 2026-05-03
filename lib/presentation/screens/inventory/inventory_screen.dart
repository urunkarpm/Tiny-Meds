import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../data/models/enums.dart';
import '../../../domain/entities/medicine.dart';
import '../../providers/inventory_provider.dart';
import 'widgets/medicine_list_item.dart';
import 'widgets/add_medicine_bottom_sheet.dart';

/// Main inventory screen displaying all medicines
class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Medicines'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              showSearch(context: context, delegate: MedicineSearchDelegate());
            },
            tooltip: 'Search medicines',
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips with improved spacing
          _buildFilterChips(),
          // Medicine list
          Expanded(
            child: ref.watch(filteredMedicinesProvider).when(
                  data: (medicines) => _buildMedicineList(medicines),
                  loading: () => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading your medicines...',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading medicines',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: colorScheme.error,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$error',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMedicineSheet(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Medicine'),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.screenPadding,
        vertical: 12,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: MedicineStatus.values.map((status) {
            final isSelected = ref.watch(filterStatusProvider) == status;
            final colorScheme = Theme.of(context).colorScheme;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_getStatusLabel(status)),
                selected: isSelected,
                onSelected: (selected) {
                  ref.read(filterStatusProvider.notifier).state =
                      selected ? status : MedicineStatus.all;
                },
                checkmarkColor: isSelected ? colorScheme.onPrimary : null,
                selectedColor: isSelected ? colorScheme.primary : null,
                labelStyle: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMedicineList(List<Medicine> medicines) {
    if (medicines.isEmpty) {
      return _buildEmptyState();
    }

    // Group expired items at the top
    final expired = medicines.where((m) => m.isExpired && !m.isDisposed).toList();
    final active = medicines.where((m) => !m.isExpired && !m.isDisposed).toList();

    return RefreshIndicator(
      onRefresh: () async {
        // Trigger a refresh (in real app, this might sync with cloud)
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: (expired.isNotEmpty ? 1 : 0) + active.length,
        itemBuilder: (context, index) {
          if (expired.isNotEmpty && index == 0) {
            // Expired section header and items
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_rounded,
                        size: 20,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Expired Medicines',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                ...expired.map((medicine) => MedicineListItem(
                      medicine: medicine,
                      onTap: () => _showMedicineDetail(medicine),
                      onEdit: () => _showEditMedicineSheet(medicine),
                      onDelete: () => _confirmDelete(medicine),
                    )),
              ],
            );
          }

          final adjustedIndex = expired.isNotEmpty ? index - 1 : index;
          final medicine = active[adjustedIndex];

          return MedicineListItem(
            medicine: medicine,
            onTap: () => _showMedicineDetail(medicine),
            onEdit: () => _showEditMedicineSheet(medicine),
            onDelete: () => _confirmDelete(medicine),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
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
              'Tap the button below to add your first medicine and start tracking your inventory',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _showAddMedicineSheet,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Medicine'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(MedicineStatus status) {
    switch (status) {
      case MedicineStatus.all:
        return 'All';
      case MedicineStatus.active:
        return 'Active';
      case MedicineStatus.expiringSoon:
        return 'Expiring Soon';
      case MedicineStatus.expired:
        return 'Expired';
      case MedicineStatus.lowStock:
        return 'Low Stock';
    }
  }

  void _showAddMedicineSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AddMedicineBottomSheet(),
    );
  }

  void _showEditMedicineSheet(Medicine medicine) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddMedicineBottomSheet(medicine: medicine),
    );
  }

  void _showMedicineDetail(Medicine medicine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MedicineDetailScreen(medicine: medicine),
      ),
    );
  }

  void _confirmDelete(Medicine medicine) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text(
          'Are you sure you want to delete "${medicine.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(inventoryProvider.notifier).deleteMedicine(medicine.id!);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Medicine detail screen
class MedicineDetailScreen extends ConsumerWidget {
  final Medicine medicine;

  const MedicineDetailScreen({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditMedicineSheet(context, ref),
            tooltip: 'Edit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            const SizedBox(height: 16),
            _buildActions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.medication_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (medicine.brand != null)
                        Text(
                          medicine.brand!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoRow(context, 'Form', medicine.form.displayName),
            if (medicine.strength != null)
              _buildInfoRow(context, 'Strength', medicine.strength!),
            _buildInfoRow(context, 'Quantity', '${medicine.quantity} ${medicine.unit}'),
            _buildInfoRow(
              context,
              'Expiry Date',
              _formatDate(medicine.expiryDate),
              isError: medicine.isExpired,
              icon: medicine.isExpired ? Icons.warning_rounded : Icons.calendar_today_rounded,
            ),
            if (medicine.location != null)
              _buildInfoRow(context, 'Location', medicine.location!, icon: Icons.location_on_outlined),
            if (medicine.lowStockThreshold != null)
              _buildInfoRow(
                context,
                'Low Stock Threshold',
                '${medicine.lowStockThreshold} ${medicine.unit}',
                icon: Icons.inventory_2_outlined,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool isError = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: isError
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
          ] else
            SizedBox(width: 24),
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: isError
                        ? Theme.of(context).colorScheme.error
                        : null,
                    fontWeight: isError ? FontWeight.bold : FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: () => _showEditMedicineSheet(context, ref),
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Edit'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
            ),
            if (!medicine.isExpired)
              FilledButton.icon(
                onPressed: () {
                  // Navigate to create alert screen
                },
                icon: const Icon(Icons.notifications_active_rounded),
                label: const Text('Create Alert'),
              ),
            if (medicine.isExpired && !medicine.isDisposed)
              FilledButton.icon(
                onPressed: () {
                  ref.read(inventoryProvider.notifier).markAsDisposed(medicine.id!);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Medicine marked as disposed'),
                      backgroundColor: colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('Mark as Disposed'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _showEditMedicineSheet(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddMedicineBottomSheet(medicine: medicine),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            const Text('Delete Medicine'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "${medicine.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(inventoryProvider.notifier).deleteMedicine(medicine.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Medicine deleted successfully'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Search delegate for medicine search
class MedicineSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.read(searchQueryProvider.notifier).state = query;
        return ref.watch(filteredMedicinesProvider).when(
              data: (medicines) => ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final medicine = medicines[index];
                  return ListTile(
                    title: Text(medicine.name),
                    subtitle: Text(
                      '${medicine.quantity} ${medicine.unit} - Expires: ${_formatDate(medicine.expiryDate)}',
                    ),
                    onTap: () {
                      close(context, null);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MedicineDetailScreen(medicine: medicine),
                        ),
                      );
                    },
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
