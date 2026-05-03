import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/medicine.dart';
import '../../../domain/entities/enums.dart';
import '../../providers/inventory_provider.dart';

/// Bottom sheet for adding or editing a medicine
class AddMedicineBottomSheet extends ConsumerStatefulWidget {
  final Medicine? medicine;

  const AddMedicineBottomSheet({super.key, this.medicine});

  @override
  ConsumerState<AddMedicineBottomSheet> createState() =>
      _AddMedicineBottomSheetState();
}

class _AddMedicineBottomSheetState
    extends ConsumerState<AddMedicineBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _strengthController;
  late final TextEditingController _quantityController;
  late final TextEditingController _unitController;
  late final TextEditingController _locationController;
  late final TextEditingController _thresholdController;

  DateTime? _selectedExpiryDate;
  MedicineForm _selectedForm = MedicineForm.tablet;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.medicine?.name ?? '');
    _brandController = TextEditingController(text: widget.medicine?.brand ?? '');
    _strengthController =
        TextEditingController(text: widget.medicine?.strength ?? '');
    _quantityController =
        TextEditingController(text: widget.medicine?.quantity.toString() ?? '');
    _unitController = TextEditingController(text: widget.medicine?.unit ?? '');
    _locationController =
        TextEditingController(text: widget.medicine?.location ?? '');
    _thresholdController = TextEditingController(
        text: widget.medicine?.lowStockThreshold?.toString() ?? '');

    _selectedExpiryDate = widget.medicine?.expiryDate;
    _selectedForm = widget.medicine?.form ?? MedicineForm.tablet;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _strengthController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _locationController.dispose();
    _thresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medicine != null;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  isEditing ? 'Edit Medicine' : 'Add Medicine',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  isEditing
                      ? 'Update medicine details'
                      : 'Enter medicine information',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),

                // Name field (required)
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Medicine Name',
                    hintText: 'e.g., Paracetamol',
                    prefixIcon: Icon(Icons.medication),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a medicine name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Brand field (optional)
                TextFormField(
                  controller: _brandController,
                  decoration: const InputDecoration(
                    labelText: 'Brand (Optional)',
                    hintText: 'e.g., Tylenol',
                    prefixIcon: Icon(Icons.business),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Form dropdown (required)
                DropdownButtonFormField<MedicineForm>(
                  value: _selectedForm,
                  decoration: const InputDecoration(
                    labelText: 'Form',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: MedicineForm.values.map((form) {
                    return DropdownMenuItem(
                      value: form,
                      child: Text(form.displayName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedForm = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Strength field (optional)
                TextFormField(
                  controller: _strengthController,
                  decoration: const InputDecoration(
                    labelText: 'Strength (Optional)',
                    hintText: 'e.g., 500mg, 10%',
                    prefixIcon: Icon(Icons.science),
                  ),
                ),
                const SizedBox(height: 16),

                // Quantity and Unit row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          hintText: 'e.g., 30',
                          prefixIcon: Icon(Icons.inventory_2_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _unitController,
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          hintText: 'e.g., tablets, mL',
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Expiry date picker (required)
                InkWell(
                  onTap: () => _selectExpiryDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expiry Date',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
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
                        Icon(
                          Icons.arrow_drop_down,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_selectedExpiryDate != null &&
                    _selectedExpiryDate!.isBefore(DateTime.now())) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Warning: This date is in the past',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                        ),
                  ),
                ],
                const SizedBox(height: 16),

                // Location field (optional)
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location (Optional)',
                    hintText: 'e.g., Bathroom cabinet',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Low stock threshold (optional)
                TextFormField(
                  controller: _thresholdController,
                  decoration: const InputDecoration(
                    labelText: 'Low Stock Threshold (Optional)',
                    hintText: 'e.g., 10',
                    prefixIcon: Icon(Icons.warning_outlined),
                    helperText: 'Get notified when quantity reaches this level',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton(
                        onPressed: _isLoading ? null : _saveMedicine,
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(isEditing ? 'Save Changes' : 'Add Medicine'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final initialDate = _selectedExpiryDate ?? DateTime.now().add(const Duration(days: 30));
    final firstDate = DateTime.now().subtract(const Duration(days: 365));
    final lastDate = DateTime.now().add(const Duration(days: 3650));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select expiry date',
    );

    if (picked != null) {
      // Warn if date is far in the past
      if (picked.isBefore(DateTime.now().subtract(const Duration(days: 30)))) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Past Date'),
            content: const Text(
              'The selected date is more than 30 days in the past. Are you sure this is correct?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Change'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirm'),
              ),
            ],
          ),
        );

        if (confirm != true) return;
      }

      setState(() {
        _selectedExpiryDate = picked;
      });
    }
  }

  Future<void> _saveMedicine() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedExpiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an expiry date')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final medicine = Medicine(
        id: widget.medicine?.id,
        name: _nameController.text.trim(),
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
        form: _selectedForm,
        strength: _strengthController.text.trim().isEmpty
            ? null
            : _strengthController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        unit: _unitController.text.trim(),
        expiryDate: _selectedExpiryDate!,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
        lowStockThreshold: _thresholdController.text.trim().isEmpty
            ? null
            : int.tryParse(_thresholdController.text.trim()),
        createdAt: widget.medicine?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (widget.medicine != null) {
        await ref.read(inventoryProvider.notifier).updateMedicine(medicine);
      } else {
        await ref.read(inventoryProvider.notifier).addMedicine(medicine);
      }

      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.medicine != null
                  ? 'Medicine updated successfully'
                  : 'Medicine added successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving medicine: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
}
