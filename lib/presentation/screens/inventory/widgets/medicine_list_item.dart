import 'package:flutter/material.dart';

import '../../../../domain/entities/medicine.dart';
import '../../../widgets/med_tile.dart';
import '../../../widgets/status_pill.dart';

/// Medicine list card — design spec: 02-Cabinet list row
/// 16dp-radius card · MedTile · name + meta + StatusPill
class MedicineListItem extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicineListItem({
    super.key,
    required this.medicine,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Form tile
              MedTile(
                form: medicine.form.name,
                hue: medicine.medHue,
                size: 56,
                rounded: 14,
              ),
              const SizedBox(width: 14),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _buildMeta(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    StatusPill(
                      kind: medicine.statusPillKind,
                      label: medicine.statusPillLabel,
                    ),
                  ],
                ),
              ),
              // Context menu
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_horiz_rounded,
                  color: colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                tooltip: 'More options',
                onSelected: (value) {
                  if (value == 'edit') onEdit?.call();
                  if (value == 'delete') onDelete?.call();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded,
                            color: colorScheme.primary, size: 20),
                        const SizedBox(width: 12),
                        const Text('Edit'),
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
            ],
          ),
        ),
      ),
    );
  }

  String _buildMeta() {
    final parts = <String>[];
    if (medicine.strength != null) parts.add(medicine.strength!);
    parts.add('${medicine.quantity} ${medicine.unit}');
    if (medicine.location != null) parts.add(medicine.location!);
    return parts.join(' · ');
  }
}
