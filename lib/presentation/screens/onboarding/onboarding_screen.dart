import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main_shell.dart';
import '../../widgets/med_tile.dart';
import '../../../domain/entities/medicine.dart';
import '../../../data/models/enums.dart';
import '../../providers/inventory_provider.dart';

/// Onboarding screen — first-launch welcome
/// Design spec: 01-Onboarding
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Hero illustration
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Soft radial halo behind the tiles
                            Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    colorScheme.primaryContainer
                                        .withValues(alpha: 0.6),
                                    colorScheme.primaryContainer
                                        .withValues(alpha: 0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            // 2×2 grid of rotated medicine tiles
                            SizedBox(
                              width: 210,
                              height: 210,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 16,
                                    child: Transform.rotate(
                                      angle: -8 * 3.141592653589793 / 180,
                                      child: const MedTile(
                                          form: 'capsule',
                                          hue: 210,
                                          size: 88,
                                          rounded: 22),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Transform.rotate(
                                      angle: 6 * 3.141592653589793 / 180,
                                      child: const MedTile(
                                          form: 'tablet',
                                          hue: 35,
                                          size: 88,
                                          rounded: 22),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Transform.rotate(
                                      angle: 4 * 3.141592653589793 / 180,
                                      child: const MedTile(
                                          form: 'liquid',
                                          hue: 320,
                                          size: 88,
                                          rounded: 22),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 8,
                                    child: Transform.rotate(
                                      angle: -6 * 3.141592653589793 / 180,
                                      child: const MedTile(
                                          form: 'cream',
                                          hue: 140,
                                          size: 88,
                                          rounded: 22),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Headline
                    Text(
                      'Your medicine cabinet, organized.',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 12),
                    // Body
                    Text(
                      'Track every bottle, get a heads-up before things expire, never run out of essentials.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Sticky CTA area
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () => _navigateToMainApp(context),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Get started'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _importCSV(context, ref),
                    child: const Text('I already have a list to import'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Stays on your phone. No account needed.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _importCSV(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final csvString = await file.readAsString();

      // Simple EOL detection
      final eol = csvString.contains('\r\n') ? '\r\n' : '\n';
      final fields = CsvToListConverter(eol: eol).convert(csvString);

      if (fields.length <= 1) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('The selected file is empty or invalid.')),
          );
        }
        return;
      }

      // Skip header
      final data = fields.sublist(1);
      final importData = <Map<String, dynamic>>[];

      for (final row in data) {
        if (row.length < 8) continue;

        try {
          final medicine = Medicine(
            name: row[0].toString(),
            brand: row[1].toString().isEmpty ? null : row[1].toString(),
            form: MedicineFormExtension.fromString(row[2].toString()),
            strength: row[3].toString().isEmpty ? null : row[3].toString(),
            quantity: int.tryParse(row[4].toString()) ?? 0,
            unit: row[5].toString(),
            expiryDate: DateTime.parse(row[6].toString()),
            location: row[7].toString().isEmpty ? null : row[7].toString(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          // Parse profile info if available (columns 8 and 9)
          final profileName =
              row.length > 8 ? row[8].toString() : 'Primary Profile';
          final profileColor = row.length > 9
              ? int.tryParse(row[9].toString()) ?? 0xFF2196F3
              : 0xFF2196F3;

          importData.add({
            'medicine': medicine,
            'profileName': profileName,
            'profileColor': profileColor,
          });
        } catch (e) {
          debugPrint('Error parsing row: $e');
        }
      }

      if (importData.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid medicines found in CSV.')),
          );
        }
        return;
      }

      await ref.read(inventoryProvider.notifier).bulkAddMedicines(importData);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imported ${importData.length} medicines.')),
        );
        _navigateToMainApp(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error importing CSV: $e')),
        );
      }
    }
  }

  void _navigateToMainApp(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }
}
