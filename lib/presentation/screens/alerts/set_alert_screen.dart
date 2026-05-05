import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/medicine.dart';
import '../../../domain/entities/alert.dart';
import '../../../data/models/enums.dart';
import '../../providers/inventory_provider.dart';
import '../../widgets/med_tile.dart';

/// Set up an alert screen — design spec: 07-Set up alert
class SetAlertScreen extends ConsumerStatefulWidget {
  final Medicine medicine;
  const SetAlertScreen({super.key, required this.medicine});

  @override
  ConsumerState<SetAlertScreen> createState() => _SetAlertScreenState();
}

class _SetAlertScreenState extends ConsumerState<SetAlertScreen> {
  AlertType _selectedType = AlertType.dose;
  DateTime _startDate = DateTime.now();
  late List<TimeOfDay> _doseTimes;
  final RecurrencePattern _recurrence = RecurrencePattern.daily;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final initialFrequency = widget.medicine.frequency ?? 1;
    _doseTimes = List.generate(
      initialFrequency,
      (index) => TimeOfDay(hour: 8 + (index * 4) % 24, minute: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Set Reminder'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveAlerts,
              child: const Text('Save'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine card
            _buildMedicinePreview(context),
            const SizedBox(height: 24),

            // Type selector
            Text('Reminder Type', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            _buildTypeSelector(context),
            const SizedBox(height: 24),

            if (_selectedType == AlertType.dose) ...[
              // Frequency
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Frequency', style: Theme.of(context).textTheme.titleSmall),
                  Text('${_doseTimes.length} times / day',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          )),
                ],
              ),
              const SizedBox(height: 8),
              _buildFrequencyPicker(context),
              const SizedBox(height: 24),

              // Time pickers
              Text('Dose Times', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              ...List.generate(_doseTimes.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildTimePicker(context, index),
                );
              }),
            ] else ...[
              // Date picker for Expiry/Refill
              Text('Alert Date', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              _buildDatePicker(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMedicinePreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          MedTile(
            form: widget.medicine.form.name,
            hue: widget.medicine.medHue,
            size: 40,
            rounded: 10,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.medicine.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
                Text(
                  '${widget.medicine.strength ?? ""} ${widget.medicine.form.displayName}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    return SegmentedButton<AlertType>(
      segments: const [
        ButtonSegment(
          value: AlertType.dose,
          label: Text('Dose'),
          icon: Icon(Icons.medication_rounded),
        ),
        ButtonSegment(
          value: AlertType.lowStock,
          label: Text('Refill'),
          icon: Icon(Icons.shopping_basket_rounded),
        ),
        ButtonSegment(
          value: AlertType.expiry,
          label: Text('Expiry'),
          icon: Icon(Icons.event_busy_rounded),
        ),
      ],
      selected: {_selectedType},
      onSelectionChanged: (val) => setState(() => _selectedType = val.first),
    );
  }

  Widget _buildFrequencyPicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: _doseTimes.length > 1
              ? () => setState(() => _doseTimes.removeLast())
              : null,
          icon: const Icon(Icons.remove_rounded),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('${_doseTimes.length}',
                style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        const SizedBox(width: 16),
        IconButton.filledTonal(
          onPressed: _doseTimes.length < 12
              ? () => setState(() => _doseTimes.add(const TimeOfDay(hour: 12, minute: 0)))
              : null,
          icon: const Icon(Icons.add_rounded),
        ),
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final time = _doseTimes[index];
    
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          setState(() => _doseTimes[index] = picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(Icons.access_time_rounded,
                size: 20, color: colorScheme.primary),
            const SizedBox(width: 16),
            Text('Dose ${index + 1} Time',
                style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Text(
              time.format(context),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _startDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
        );
        if (picked != null) {
          setState(() => _startDate = picked);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 20, color: colorScheme.primary),
            const SizedBox(width: 16),
            Text(DateFormat('MMM dd, yyyy').format(_startDate),
                style: Theme.of(context).textTheme.titleMedium),
            const Spacer(),
            Icon(Icons.arrow_drop_down_rounded, color: colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAlerts() async {
    setState(() => _isSaving = true);

    try {
      final notifier = ref.read(alertsNotifierProvider.notifier);
      
      if (_selectedType == AlertType.dose) {
        // Save multiple dose alerts
        for (final time in _doseTimes) {
          final triggerDate = DateTime(
            _startDate.year,
            _startDate.month,
            _startDate.day,
            time.hour,
            time.minute,
          );
          
          final alert = Alert(
            medicineId: widget.medicine.id!,
            type: AlertType.dose,
            triggerDate: triggerDate,
            recurrence: _recurrence,
            createdAt: DateTime.now(),
          );
          
          await notifier.addAlert(alert, widget.medicine);
        }
      } else {
        // Save single expiry or refill alert
        final alert = Alert(
          medicineId: widget.medicine.id!,
          type: _selectedType,
          triggerDate: _startDate,
          recurrence: RecurrencePattern.once,
          createdAt: DateTime.now(),
        );
        await notifier.addAlert(alert, widget.medicine);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reminders saved successfully.')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving reminders: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
