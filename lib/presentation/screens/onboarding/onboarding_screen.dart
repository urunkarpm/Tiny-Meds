import 'package:flutter/material.dart';

/// Onboarding screen - First launch welcome
/// Matches design spec 01-Onboarding
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
                            // Radial halo
                            Container(
                              width: 240,
                              height: 240,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    colorScheme.primaryContainer.withOpacity(0.5),
                                    colorScheme.primaryContainer.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            // Medicine tiles grid
                            Transform.rotate(
                              angle: -8 * 3.141592653589793 / 180,
                              child: Transform.translate(
                                offset: const Offset(-30, 10),
                                child: _buildMedTile(context, 'capsule', 200, 88),
                              ),
                            ),
                            Transform.rotate(
                              angle: 6 * 3.141592653589793 / 180,
                              child: Transform.translate(
                                offset: const Offset(30, 0),
                                child: _buildMedTile(context, 'tablet', 35, 88),
                              ),
                            ),
                            Transform.rotate(
                              angle: 4 * 3.141592653589793 / 180,
                              child: Transform.translate(
                                offset: const Offset(-30, 0),
                                child: _buildMedTile(context, 'liquid', 320, 88),
                              ),
                            ),
                            Transform.rotate(
                              angle: -6 * 3.141592653589793 / 180,
                              child: Transform.translate(
                                offset: const Offset(30, 10),
                                child: _buildMedTile(context, 'cream', 140, 88),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 6,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: colorScheme.outline,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: colorScheme.outline,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Title and body
                    Text(
                      'Your medicine cabinet, organized.',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Track every bottle, get a heads-up before things expire, never run out of essentials.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            // Sticky CTA
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                children: [
                  FilledButton(
                    onPressed: () {
                      // Navigate to main app
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Get started'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      // Import existing list
                    },
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

  Widget _buildMedTile(BuildContext context, String form, double hue, double size) {
    // Using a simplified version - in real implementation, use MedTile widget
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _hslToColor(hue, 0.6, 0.85),
            _hslToColor(hue, 0.7, 0.72),
          ],
        ),
      ),
      child: Icon(
        Icons.medication_rounded,
        color: Colors.white.withOpacity(0.9),
        size: size * 0.5,
      ),
    );
  }

  Color _hslToColor(double h, double s, double l) {
    final rad = h * (3.141592653589793 / 180);
    final c = (1 - (2 * l - 1).abs()) * s;
    final x = c * (1 - ((rad / (3.141592653589793 / 3)) % 2 - 1).abs());
    final m = l - c / 2;

    double r, g, b;
    if (h < 60) {
      r = c; g = x; b = 0;
    } else if (h < 120) {
      r = x; g = c; b = 0;
    } else if (h < 180) {
      r = 0; g = c; b = x;
    } else if (h < 240) {
      r = 0; g = x; b = c;
    } else if (h < 300) {
      r = x; g = 0; b = c;
    } else {
      r = c; g = 0; b = x;
    }

    return Color.fromRGBO(
      ((r + m) * 255).round(),
      ((g + m) * 255).round(),
      ((b + m) * 255).round(),
      1,
    );
  }
}
