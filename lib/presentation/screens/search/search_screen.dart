import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/enums.dart';
import '../../../domain/entities/medicine.dart';
import '../../providers/inventory_provider.dart';

/// Search & filter screen — design spec: 03-Search
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // Active filters
  final Set<String> _statusFilters = {};
  final Set<MedicineForm> _formFilters = {};
  final Set<String> _locationFilters = {};
  double _expiresWithinWeeks = 26; // 6 months default (max)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final medicinesAsync = ref.watch(filteredMedicinesProvider);

    final results = medicinesAsync.asData?.value ?? [];
    final filteredResults = _applyLocalFilters(results);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Search bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Row(
                  children: [
                    Semantics(
                      label: 'Back',
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_rounded,
                            color: colorScheme.onSurfaceVariant),
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Back',
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: (q) {
                          ref.read(searchQueryProvider.notifier).state = q;
                          setState(() {});
                        },
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Search medicines…',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          fillColor: Colors.transparent,
                          filled: false,
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        cursorColor: colorScheme.primary,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      Semantics(
                        label: 'Clear search',
                        child: IconButton(
                          icon: Icon(Icons.close_rounded,
                              color: colorScheme.onSurfaceVariant, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(searchQueryProvider.notifier).state = '';
                            setState(() {});
                          },
                          tooltip: 'Clear',
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Filter panels ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FILTERS',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 1,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Status filter
                    Text('Status',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _statusChip(
                            context, 'expired', 'Expired', colorScheme.error),
                        _statusChip(context, 'soon', 'Expiring soon',
                            const Color(0xFFFF9800)),
                        _statusChip(context, 'low', 'Low stock', null),
                        _statusChip(context, 'refill', 'Shopping list', null),
                        _statusChip(context, 'active', 'Active', null),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Form filter
                    Text('Form', style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: MedicineForm.values
                          .map((f) => _formChip(context, f))
                          .toList(),
                    ),
                    const SizedBox(height: 24),

                    // Location filter
                    Text('Location',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _locationOptions()
                          .map((loc) => _locationChip(context, loc))
                          .toList(),
                    ),
                    const SizedBox(height: 24),

                    // Expires within slider
                    Text('Expires within',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      _expiresWithinWeeks >= 26
                          ? 'Any time'
                          : _expiresWithinLabel(_expiresWithinWeeks),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    Slider(
                      value: _expiresWithinWeeks,
                      min: 0,
                      max: 26,
                      divisions: 26,
                      onChanged: (v) => setState(() => _expiresWithinWeeks = v),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Today',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: colorScheme.onSurfaceVariant)),
                        Text('6 months',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Sticky footer ────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 16, 20, 16 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border:
                    Border(top: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _clearAll,
                    child: const Text('Clear'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: filteredResults.isNotEmpty
                          ? () => _showResults(context, filteredResults)
                          : null,
                      style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 48)),
                      child: Text(
                        filteredResults.isEmpty
                            ? 'No results'
                            : 'Show ${filteredResults.length} result${filteredResults.length == 1 ? '' : 's'}',
                      ),
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

  Widget _statusChip(
      BuildContext context, String key, String label, Color? color) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _statusFilters.contains(key);
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (v) => setState(
          () => v ? _statusFilters.add(key) : _statusFilters.remove(key)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedColor: color != null
          ? color.withValues(alpha: 0.15)
          : colorScheme.surfaceContainerHigh,
      labelStyle: TextStyle(
        color: selected
            ? (color ?? colorScheme.onSurface)
            : colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        fontSize: 14,
      ),
      side: selected
          ? BorderSide(color: color ?? colorScheme.outline)
          : BorderSide(color: colorScheme.outline),
      showCheckmark: false,
    );
  }

  Widget _formChip(BuildContext context, MedicineForm form) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _formFilters.contains(form);
    return FilterChip(
      avatar: Icon(_formIcon(form),
          size: 16,
          color:
              selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant),
      label: Text(form.displayName),
      selected: selected,
      onSelected: (v) => setState(
          () => v ? _formFilters.add(form) : _formFilters.remove(form)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedColor: colorScheme.surfaceContainerHigh,
      labelStyle: TextStyle(
        color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        fontSize: 14,
      ),
      side: selected ? BorderSide.none : BorderSide(color: colorScheme.outline),
      showCheckmark: false,
    );
  }

  Widget _locationChip(BuildContext context, String loc) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _locationFilters.contains(loc);
    return FilterChip(
      avatar: Icon(Icons.location_on_outlined,
          size: 16,
          color:
              selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant),
      label: Text(loc),
      selected: selected,
      onSelected: (v) => setState(
          () => v ? _locationFilters.add(loc) : _locationFilters.remove(loc)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      selectedColor: colorScheme.surfaceContainerHigh,
      labelStyle: TextStyle(
        color: selected ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        fontSize: 14,
      ),
      side: selected ? BorderSide.none : BorderSide(color: colorScheme.outline),
      showCheckmark: false,
    );
  }

  List<String> _locationOptions() {
    final all = ref.read(filteredMedicinesProvider).asData?.value ?? [];
    final locs = all.map((m) => m.location).whereType<String>().toSet().toList()
      ..sort();
    return locs.isEmpty
        ? ['Kitchen', 'Fridge', 'Bathroom', 'Bedside', 'Travel kit']
        : locs;
  }

  List<Medicine> _applyLocalFilters(List<Medicine> all) {
    return all.where((m) {
      // Status filter
      if (_statusFilters.isNotEmpty) {
        bool match = false;
        if (_statusFilters.contains('refill') && m.needsRefill) match = true;
        if (_statusFilters.contains(m.statusPillKind)) match = true;
        if (!match) return false;
      }
      // Form filter
      if (_formFilters.isNotEmpty && !_formFilters.contains(m.form)) {
        return false;
      }
      // Location filter
      if (_locationFilters.isNotEmpty &&
          !_locationFilters.contains(m.location)) {
        return false;
      }
      // Expires within
      if (_expiresWithinWeeks < 26) {
        final maxDays = (_expiresWithinWeeks * 7).round();
        if (m.daysUntilExpiry > maxDays || m.daysUntilExpiry < 0) return false;
      }
      return true;
    }).toList();
  }

  void _clearAll() {
    setState(() {
      _searchController.clear();
      _statusFilters.clear();
      _formFilters.clear();
      _locationFilters.clear();
      _expiresWithinWeeks = 26;
    });
    ref.read(searchQueryProvider.notifier).state = '';
  }

  void _showResults(BuildContext context, List<Medicine> results) {
    Navigator.pop(context);
  }

  IconData _formIcon(MedicineForm form) {
    switch (form) {
      case MedicineForm.tablet:
        return Icons.medication_rounded;
      case MedicineForm.capsule:
        return Icons.medication_liquid_rounded;
      case MedicineForm.liquid:
        return Icons.water_drop_outlined;
      case MedicineForm.cream:
        return Icons.spa_outlined;
      case MedicineForm.inhaler:
        return Icons.air_rounded;
      default:
        return Icons.medical_services_outlined;
    }
  }

  String _expiresWithinLabel(double weeks) {
    final days = (weeks * 7).round();
    if (days == 0) return 'Today';
    if (days < 7) return '$days days';
    if (days < 14) return '1 week';
    return '${(days / 7).round()} weeks';
  }
}
