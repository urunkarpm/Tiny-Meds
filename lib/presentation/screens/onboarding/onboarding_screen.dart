import 'package:flutter/material.dart';

import '../main_shell.dart';
import '../../widgets/med_tile.dart';

/// Onboarding screen — first-launch welcome
/// Design spec: 01-Onboarding
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                                    colorScheme.primaryContainer.withValues(alpha: 0.6),
                                    colorScheme.primaryContainer.withValues(alpha: 0.1),
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
                                      child: const MedTile(form: 'capsule', hue: 210, size: 88, rounded: 22),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Transform.rotate(
                                      angle: 6 * 3.141592653589793 / 180,
                                      child: const MedTile(form: 'tablet', hue: 35, size: 88, rounded: 22),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    child: Transform.rotate(
                                      angle: 4 * 3.141592653589793 / 180,
                                      child: const MedTile(form: 'liquid', hue: 320, size: 88, rounded: 22),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 8,
                                    child: Transform.rotate(
                                      angle: -6 * 3.141592653589793 / 180,
                                      child: const MedTile(form: 'cream', hue: 140, size: 88, rounded: 22),
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
                    onPressed: () => _navigateToMainApp(context),
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

  void _navigateToMainApp(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }
}
