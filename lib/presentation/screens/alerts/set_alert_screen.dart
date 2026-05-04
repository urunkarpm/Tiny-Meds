import 'package:flutter/material.dart';

import '../../../domain/entities/medicine.dart';
import '../../widgets/med_tile.dart';

/// Set up an alert screen — design spec: 07-Set up alert
class SetAlertScreen extends StatefulWidget {
  final Medicine? medicine;
  const SetAlertScreen({super.key, this.medicine});

  @override
  State<SetAlertScreen> createState() => _SetAlertScreenState();
}

class _SetAlertScreenState extends State<SetAlertScreen> {
  int _selectedType = 0; // 0=Expiry, 1=Low stock, 2=Dose
  int _selectedLeadTime = 1; // index into _leadTimes
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  static const _leadTimes = [
    _LeadTime('30 days', 30),
    _LeadTime('7 days', 7),
    _LeadTime('1 day', 1),
    _LeadTime('Today', 0),
  ];

  static const _typeLabels = ['Expiry', 'Low stock', 'Dose'];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final medicine = widget.medicine;

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
                  Expanded(
                    child: Text(
                      'New alert',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton(
                    onPressed: _save,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),

            // ── Scrollable content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // For which medicine
                    Text(
                      'FOR',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          if (medicine != null)
                            MedTile(
                              form: medicine.form.name,
                              hue: medicine.medHue,
                              size: 48,
                              rounded: 12,
                            )
                          else
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.medication_rounded,
                                  color: colorScheme.onPrimaryContainer),
                            ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  medicine != null
                                      ? '${medicine.name}${medicine.strength != null ? ' ${medicine.strength}' : ''}'
                                      : 'Select medicine',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                if (medicine != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    [
                                      if (medicine.location != null)
                                        medicine.location!,
                                      '${medicine.quantity} ${medicine.unit}',
                                    ].join(' · '),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(Icons.keyboard_arrow_down_rounded,
                              color: colorScheme.onSurfaceVariant),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Alert type — segmented control
                    Text(
                      'TYPE',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: colorScheme.outline),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(23),
                        child: Row(
                          children: List.generate(_typeLabels.length, (i) {
                            final sel = _selectedType == i;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => _selectedType = i),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  color: sel
                                      ? colorScheme.primaryContainer
                                      : Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (sel)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: Icon(Icons.check_rounded,
                                              size: 16,
                                              color: colorScheme
                                                  .onPrimaryContainer),
                                        ),
                                      Text(
                                        _typeLabels[i],
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              fontWeight: sel
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: sel
                                                  ? colorScheme
                                                      .onPrimaryContainer
                                                  : colorScheme.onSurface,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Lead time picker (custom discrete track)
                    if (_selectedType == 0) ...[
                      Text(
                        'HOW EARLY',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  letterSpacing: 0.5,
                                ),
                      ),
                      const SizedBox(height: 8),
                      _buildLeadTimePicker(context),
                      const SizedBox(height: 24),
                    ],

                    // Time of day
                    Text(
                      'TIME OF DAY',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: _pickTime,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 22,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _selectedTime.format(context),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded,
                                color: colorScheme.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Notification preview
                    Text(
                      'PREVIEW',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    _buildNotificationPreview(context),
                  ],
                ),
              ),
            ),

            // ── Footer ──────────────────────────────────────────────
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                    top: BorderSide(color: colorScheme.outlineVariant)),
              ),
              child: FilledButton(
                onPressed: _save,
                style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48)),
                child: const Text('Save alert'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeadTimePicker(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (ctx, constraints) {
              final w = constraints.maxWidth;
              final fraction =
                  _selectedLeadTime / (_leadTimes.length - 1).toDouble();
              return SizedBox(
                height: 56,
                child: Stack(
                  children: [
                    // Background track
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 26,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Active track
                    Positioned(
                      left: 0,
                      width: w * fraction,
                      top: 26,
                      height: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    // Dots
                    ...List.generate(_leadTimes.length, (i) {
                      final x = i / (_leadTimes.length - 1) * w;
                      final sel = _selectedLeadTime == i;
                      final dotSize = sel ? 24.0 : 14.0;
                      return Positioned(
                        left: x - dotSize / 2,
                        top: 28 - dotSize / 2,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedLeadTime = i),
                          child: Container(
                            width: dotSize,
                            height: dotSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i <= _selectedLeadTime
                                  ? colorScheme.primary
                                  : colorScheme.surfaceContainerLowest,
                              border: i <= _selectedLeadTime
                                  ? null
                                  : Border.all(
                                      color: colorScheme.outline, width: 2),
                              boxShadow: sel
                                  ? [
                                      BoxShadow(
                                        color: colorScheme.primary
                                            .withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        spreadRadius: 4,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          // Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_leadTimes.length, (i) {
              final sel = _selectedLeadTime == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedLeadTime = i),
                child: Text(
                  _leadTimes[i].label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: sel
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPreview(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final medicine = widget.medicine;
    final leadLabel = _leadTimes[_selectedLeadTime].label;
    final previewText = medicine != null
        ? '${medicine.name} expires in $leadLabel'
        : 'Your medicine expires in $leadLabel';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.notifications_rounded,
                color: colorScheme.onPrimary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tiny Meds',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      'now',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  previewText,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to view in cabinet',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Alert saved.'),
      ),
    );
    Navigator.pop(context);
  }
}

class _LeadTime {
  final String label;
  final int days;
  const _LeadTime(this.label, this.days);
}
