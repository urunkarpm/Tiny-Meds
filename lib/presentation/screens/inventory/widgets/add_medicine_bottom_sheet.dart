import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'scan_medicine_screen.dart';
import '../../../../domain/entities/medicine.dart';
import '../../../../data/models/enums.dart';
import '../../../providers/inventory_provider.dart';

/// Multi-step Add / Edit medicine sheet
/// Design spec: 05-Add medicine
/// Steps: 1 Name · 2 The basics · 3 Where & When · 4 Review
class AddMedicineBottomSheet extends ConsumerStatefulWidget {
  final Medicine? medicine;
  final bool isRefilling;
  const AddMedicineBottomSheet({
    super.key, 
    this.medicine,
    this.isRefilling = false,
  });

  @override
  ConsumerState<AddMedicineBottomSheet> createState() =>
      _AddMedicineBottomSheetState();
}

class _AddMedicineBottomSheetState
    extends ConsumerState<AddMedicineBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 4;

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _strengthController;
  late final TextEditingController _locationController;
  late final TextEditingController _thresholdController;
  late final TextEditingController _doseAmountController;

  MedicineForm _selectedForm = MedicineForm.tablet;
  String _selectedUnit = 'tablets';
  int _quantity = 1;
  int _frequency = 1;
  DateTime? _selectedExpiryDate;
  bool _isLoading = false;

  static const _unitOptions = [
    'tablets', 'capsules', 'mL', 'mg', 'doses', 'tubes', 'sprays', 'patches',
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.medicine;
    _nameController = TextEditingController(text: m?.name ?? '');
    _brandController = TextEditingController(text: m?.brand ?? '');
    _strengthController = TextEditingController(text: m?.strength ?? '');
    _locationController = TextEditingController(text: m?.location ?? '');
    _thresholdController =
        TextEditingController(text: m?.lowStockThreshold?.toString() ?? '');
    _doseAmountController =
        TextEditingController(text: m?.doseAmount?.toString() ?? '');
    _frequency = m?.frequency ?? 1;
    _selectedForm = m?.form ?? MedicineForm.tablet;
    _selectedUnit = m?.unit ?? 'tablets';
    _quantity = m?.quantity ?? 1;
    _selectedExpiryDate = m?.expiryDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _strengthController.dispose();
    _locationController.dispose();
    _thresholdController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.medicine != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.88,
        child: Column(
          children: [
            // ── App bar row ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
              child: SizedBox(
                height: 56,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                      tooltip: 'Close',
                    ),
                    Expanded(
                      child: Text(
                        isEditing ? 'Edit medicine' : 'Add medicine',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Step progress ───────────────────────────────────────
            if (!isEditing)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(_totalSteps, (i) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(
                                right: i < _totalSteps - 1 ? 6 : 0),
                            decoration: BoxDecoration(
                              color: i <= _currentStep
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'STEP ${_currentStep + 1} OF $_totalSteps',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _stepTitle(_currentStep),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

            // ── Step content ────────────────────────────────────────
            Expanded(
              child: Form(
                key: _formKey,
                child: isEditing
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _buildAllFields(context),
                      )
                    : PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (i) => setState(() => _currentStep = i),
                        children: [
                          _StepPage(child: _buildStep1(context)),
                          _StepPage(child: _buildStep2(context)),
                          _StepPage(child: _buildStep3(context)),
                          _StepPage(child: _buildStep4(context)),
                        ],
                      ),
              ),
            ),

            // ── Footer buttons ──────────────────────────────────────
            _buildFooter(context, isEditing),
          ],
        ),
      ),
    );
  }

  // ─── Steps ────────────────────────────────────────────────────────────────

  Widget _buildStep1(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scan card
        _buildScanCard(context),
        const SizedBox(height: 20),
        _orDivider(context),
        const SizedBox(height: 20),
        // Name field
        _buildOutlinedField(
          context,
          controller: _nameController,
          label: 'Name',
          hint: 'e.g. Amoxicillin',
          autofocus: true,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Required' : null,
        ),
        const SizedBox(height: 16),
        // Brand field
        _buildOutlinedField(
          context,
          controller: _brandController,
          label: 'Brand (optional)',
          hint: 'e.g. Generic Pharma',
        ),
      ],
    );
  }

  Widget _buildStep2(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Strength + unit row
        Row(
          children: [
            Expanded(
              flex: 14,
              child: _buildOutlinedField(
                context,
                controller: _strengthController,
                label: 'Strength',
                hint: '500',
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 10,
              child: _buildUnitDropdown(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Form selector
        Text('Form', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: MedicineForm.values.map((f) {
            final sel = _selectedForm == f;
            return FilterChip(
              avatar: Icon(_formIcon(f),
                  size: 16,
                  color: sel
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant),
              label: Text(f.displayName),
              selected: sel,
              onSelected: (_) => setState(() => _selectedForm = f),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              selectedColor: colorScheme.primaryContainer,
              showCheckmark: false,
              side: sel
                  ? BorderSide.none
                  : BorderSide(color: colorScheme.outline),
              labelStyle: TextStyle(
                color: sel
                    ? colorScheme.onPrimaryContainer
                    : colorScheme.onSurfaceVariant,
                fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        // Quantity stepper
        Text('Quantity', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        _buildQuantityStepper(context),
        const SizedBox(height: 24),
        // Dose info
        Text('Daily Dosage', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 12,
              child: _buildOutlinedField(
                context,
                controller: _doseAmountController,
                label: 'Amount per dose',
                hint: '1',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 12,
              child: _buildFrequencyStepper(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencyStepper(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove_rounded, size: 18),
            onPressed: _frequency > 1 ? () => setState(() => _frequency--) : null,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('$_frequency',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        )),
                Text('times/day',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 10,
                        )),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 18),
            onPressed: () => setState(() => _frequency++),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Expiry date
        Text('Expiry date', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        InkWell(
          onTap: () => _pickExpiryDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 20, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expiry date',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedExpiryDate != null
                            ? _formatDate(_selectedExpiryDate!)
                            : 'Select date',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down_rounded,
                    color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Location
        Text('Storage location (optional)',
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        _buildOutlinedField(
          context,
          controller: _locationController,
          label: 'Location',
          hint: 'e.g. Fridge, Bathroom cabinet',
        ),
        const SizedBox(height: 24),
        // Low stock threshold
        Text('Low stock alert (optional)',
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        _buildOutlinedField(
          context,
          controller: _thresholdController,
          label: 'Notify when below',
          hint: 'e.g. 5',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildStep4(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _reviewRow(context, 'Name',
                  _nameController.text.trim().isEmpty
                      ? '—'
                      : _nameController.text.trim(),
                  isLast: false),
              _reviewRow(context, 'Form', _selectedForm.displayName,
                  isLast: false),
              if (_strengthController.text.trim().isNotEmpty)
                _reviewRow(context, 'Strength',
                    _strengthController.text.trim(),
                    isLast: false),
              _reviewRow(
                  context, 'Quantity', '$_quantity $_selectedUnit',
                  isLast: false),
              if (_doseAmountController.text.trim().isNotEmpty)
                _reviewRow(context, 'Dose',
                    '${_doseAmountController.text.trim()} every dose',
                    isLast: false),
              _reviewRow(context, 'Frequency', '$_frequency times / day',
                  isLast: false),
              _reviewRow(
                  context,
                  'Expiry',
                  _selectedExpiryDate != null
                      ? _formatDate(_selectedExpiryDate!)
                      : '—',
                  isLast: false),
              _reviewRow(
                  context,
                  'Location',
                  _locationController.text.trim().isEmpty
                      ? '—'
                      : _locationController.text.trim(),
                  isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Full form for edit mode ───────────────────────────────────────────────

  Widget _buildAllFields(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRefilling = widget.isRefilling;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isRefilling) ...[
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(_formIcon(_selectedForm), 
                    color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _nameController.text,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${_selectedForm.displayName}${_strengthController.text.isNotEmpty ? ' · ${_strengthController.text}' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        if (!isRefilling) ...[
          _buildOutlinedField(context,
              controller: _nameController,
              label: 'Name',
              hint: 'Medicine name',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null),
          const SizedBox(height: 16),
          _buildOutlinedField(context,
              controller: _brandController,
              label: 'Brand (optional)',
              hint: 'e.g. Generic Pharma'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 14,
                child: _buildOutlinedField(context,
                    controller: _strengthController,
                    label: 'Strength (optional)',
                    hint: '500mg'),
              ),
              const SizedBox(width: 12),
              Expanded(flex: 10, child: _buildUnitDropdown(context)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Form', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MedicineForm.values.map((f) {
              final sel = _selectedForm == f;
              return FilterChip(
                label: Text(f.displayName),
                selected: sel,
                onSelected: (_) => setState(() => _selectedForm = f),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                selectedColor: colorScheme.primaryContainer,
                showCheckmark: false,
                side: sel
                    ? BorderSide.none
                    : BorderSide(color: colorScheme.outline),
                labelStyle: TextStyle(
                  color: sel
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                  fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        
        Text('Quantity', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        _buildQuantityStepper(context),
        const SizedBox(height: 24),
        Text('Daily Dosage', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              flex: 12,
              child: _buildOutlinedField(
                context,
                controller: _doseAmountController,
                label: 'Amount per dose',
                hint: '1',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 12,
              child: _buildFrequencyStepper(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: () => _pickExpiryDate(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined,
                    size: 20, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expiry date',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 4),
                      Text(
                          _selectedExpiryDate != null
                              ? _formatDate(_selectedExpiryDate!)
                              : 'Select date',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                Icon(Icons.arrow_drop_down_rounded,
                    color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (!isRefilling) ...[
          _buildOutlinedField(context,
              controller: _locationController,
              label: 'Location (optional)',
              hint: 'e.g. Fridge'),
          const SizedBox(height: 16),
          _buildOutlinedField(context,
              controller: _thresholdController,
              label: 'Low stock threshold (optional)',
              hint: 'e.g. 5',
              keyboardType: TextInputType.number),
        ],
        const SizedBox(height: 32),
      ],
    );
  }

  // ─── Reusable sub-widgets ─────────────────────────────────────────────────

  Widget _buildScanCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Material(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: _startScan,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.camera_alt_rounded,
                      color: colorScheme.onPrimary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scan the box',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "We'll fill in name, strength, expiry",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withValues(alpha: 0.8),
                            ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: colorScheme.onPrimaryContainer),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _orDivider(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
            child: Divider(color: colorScheme.outlineVariant, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'OR ENTER MANUALLY',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
          ),
        ),
        Expanded(
            child: Divider(color: colorScheme.outlineVariant, height: 1)),
      ],
    );
  }

  Widget _buildOutlinedField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    bool autofocus = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      autofocus: autofocus,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildUnitDropdown(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DropdownButtonFormField<String>(
      initialValue: _unitOptions.contains(_selectedUnit) ? _selectedUnit : _unitOptions.first,
      decoration: InputDecoration(
        labelText: 'Unit',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: _unitOptions.map((u) {
        return DropdownMenuItem(value: u, child: Text(u));
      }).toList(),
      onChanged: (v) => setState(() => _selectedUnit = v!),
    );
  }

  Widget _buildQuantityStepper(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        // Minus
        Semantics(
          label: 'Decrease quantity',
          child: SizedBox(
            width: 44,
            height: 44,
            child: OutlinedButton(
              onPressed: _quantity > 1
                  ? () => setState(() => _quantity--)
                  : null,
              style: OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.remove_rounded, size: 20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Display
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$_quantity',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedUnit,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Plus
        Semantics(
          label: 'Increase quantity',
          child: SizedBox(
            width: 44,
            height: 44,
            child: FilledButton(
              onPressed: () => setState(() => _quantity++),
              style: FilledButton.styleFrom(
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: const Icon(Icons.add_rounded, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _reviewRow(BuildContext context, String label, String value,
      {required bool isLast}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(label,
                    style: Theme.of(context).textTheme.bodyMedium),
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
              height: 1, indent: 16, color: colorScheme.outlineVariant),
      ],
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────

  Widget _buildFooter(BuildContext context, bool isEditing) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isEditing) {
      return Container(
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
              flex: 5,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48)),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 10,
              child: FilledButton(
                onPressed: _isLoading ? null : () => _save(skipSteps: true),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save changes'),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: OutlinedButton(
              onPressed: _currentStep == 0 ? () => Navigator.pop(context) : _prevStep,
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  foregroundColor: colorScheme.primary),
              child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 10,
            child: FilledButton(
              onPressed: _isLoading ? null : _nextOrSave,
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 48),
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_currentStep < _totalSteps - 1
                      ? _nextLabel(_currentStep)
                      : 'Add medicine'),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Navigation ───────────────────────────────────────────────────────────

  void _nextOrSave() {
    if (_currentStep < _totalSteps - 1) {
      if (_currentStep == 0 &&
          _nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a medicine name.')),
        );
        return;
      }
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic);
    } else {
      _save();
    }
  }

  void _prevStep() {
    _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic);
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _stepTitle(int step) {
    switch (step) {
      case 0:
        return 'Name it';
      case 1:
        return 'The basics';
      case 2:
        return 'Where & when';
      default:
        return 'Review';
    }
  }

  String _nextLabel(int step) {
    switch (step) {
      case 0:
        return 'Next: The basics';
      case 1:
        return 'Next: Where';
      case 2:
        return 'Next: Review';
      default:
        return 'Add medicine';
    }
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

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _pickExpiryDate(BuildContext context) async {
    final initial = _selectedExpiryDate ??
        DateTime.now().add(const Duration(days: 365));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
      helpText: 'Select expiry date',
    );
    if (picked != null) setState(() => _selectedExpiryDate = picked);
  }

  Future<void> _startScan() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => const ScanMedicineScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        if (result['name'] != null) _nameController.text = result['name'];
        if (result['strength'] != null) {
          _strengthController.text = result['strength'];
        }
        if (result['expiryDate'] != null) {
          _selectedExpiryDate = result['expiryDate'];
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Scanned details applied.')),
      );
    }
  }

  Future<void> _save({bool skipSteps = false}) async {
    if (_formKey.currentState?.validate() != true) {
      if (!skipSteps && _pageController.hasClients) {
        // Find which step has error? For now just go back to step 1 if name empty
        if (_nameController.text.trim().isEmpty) {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic);
        }
      }
      return;
    }

    if (_selectedExpiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date.')),
      );
      if (!skipSteps && _pageController.hasClients) {
        _pageController.animateToPage(2,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic);
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      final threshold = int.tryParse(_thresholdController.text.trim());
      final doseAmount = double.tryParse(_doseAmountController.text.trim());
      
      final m = widget.medicine;
      bool needsRefill = m?.needsRefill ?? false;
      
      // If refilling above threshold, clear the refill flag
      if (threshold != null && _quantity > threshold) {
        needsRefill = false;
      }

      final medicine = Medicine(
        id: m?.id,
        profileId: m?.profileId,
        name: _nameController.text.trim(),
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
        form: _selectedForm,
        strength: _strengthController.text.trim().isEmpty
            ? null
            : _strengthController.text.trim(),
        quantity: _quantity,
        unit: _selectedUnit,
        expiryDate: _selectedExpiryDate!,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        lowStockThreshold: threshold,
        frequency: _frequency,
        doseAmount: doseAmount,
        needsRefill: needsRefill,
        isDisposed: m?.isDisposed ?? false,
        createdAt: m?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (m != null) {
        await ref.read(inventoryProvider.notifier).updateMedicine(medicine);
      } else {
        await ref.read(inventoryProvider.notifier).addMedicine(medicine);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(m != null
                ? '${medicine.name} updated.'
                : '${medicine.name} added to cabinet.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

/// Wrapper that pads step content for scrollability
class _StepPage extends StatelessWidget {
  final Widget child;
  const _StepPage({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: child,
    );
  }
}
