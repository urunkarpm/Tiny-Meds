import 'package:flutter/material.dart';

/// Status pill widget showing expiry/stock status
/// Matches the design system StatusPill component
class StatusPill extends StatelessWidget {
  final String kind; // expired, today, soon, month, active, low
  final String label;

  const StatusPill({
    super.key,
    required this.kind,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    final colors = _getColors(colorScheme);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colors.dot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colors.fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  _StatusColors _getColors(ColorScheme colorScheme) {
    switch (kind) {
      case 'expired':
        return _StatusColors(
          bg: colorScheme.errorContainer,
          fg: colorScheme.onErrorContainer,
          dot: colorScheme.error,
        );
      case 'today':
        return _StatusColors(
          bg: colorScheme.errorContainer,
          fg: colorScheme.onErrorContainer,
          dot: Colors.red,
        );
      case 'soon':
        return _StatusColors(
          bg: const Color(0xFFFF9800).withValues(alpha: 0.15),
          fg: const Color(0xFFFF9800),
          dot: const Color(0xFFFF9800),
        );
      case 'month':
        return _StatusColors(
          bg: const Color(0xFFFFA726).withValues(alpha: 0.12),
          fg: const Color(0xFFFFA726),
          dot: const Color(0xFFFFA726),
        );
      case 'active':
        return _StatusColors(
          bg: const Color(0xFF1B873B).withValues(alpha: 0.15),
          fg: const Color(0xFF1B873B),
          dot: const Color(0xFF1B873B),
        );
      case 'low':
        return _StatusColors(
          bg: const Color(0xFFFF9800).withValues(alpha: 0.15),
          fg: const Color(0xFFFF9800),
          dot: const Color(0xFFFF9800),
        );
      default:
        return _StatusColors(
          bg: colorScheme.surfaceContainerHigh,
          fg: colorScheme.onSurfaceVariant,
          dot: colorScheme.onSurfaceVariant,
        );
    }
  }
}

class _StatusColors {
  final Color bg;
  final Color fg;
  final Color dot;

  _StatusColors({required this.bg, required this.fg, required this.dot});
}
