import 'package:flutter/material.dart';

/// Medicine tile widget with form-specific gradient and glyph
/// Matches the design system MedTile component
class MedTile extends StatelessWidget {
  final String form;
  final double hue;
  final double size;
  final double rounded;

  const MedTile({
    super.key,
    this.form = 'tablet',
    this.hue = 210,
    this.size = 56,
    this.rounded = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rounded),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _hslToColor(hue, 0.6, 0.85),
            _hslToColor(hue, 0.7, 0.72),
          ],
        ),
      ),
      child: Center(
        child: CustomPaint(
          size: Size(size * 0.6, size * 0.6),
          painter: _FormGlyphPainter(form: form, hue: hue),
        ),
      ),
    );
  }

  Color _hslToColor(double h, double s, double l) {
    // Simple HSL to Color conversion for gradient generation
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

class _FormGlyphPainter extends CustomPainter {
  final String form;
  final double hue;

  _FormGlyphPainter({required this.form, required this.hue});

  @override
  void paint(Canvas canvas, Size size) {
    final whitePaint = Paint()..color = Colors.white.withOpacity(0.9);
    final colorPaint = Paint()..color = _hslToColor(hue, 0.8, 0.55).withOpacity(0.85);
    final strokePaint = Paint()
      ..color = _hslToColor(hue, 0.8, 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    switch (form) {
      case 'tablet':
        _drawTablet(canvas, size, whitePaint, strokePaint);
        break;
      case 'capsule':
        _drawCapsule(canvas, size, whitePaint, colorPaint);
        break;
      case 'liquid':
        _drawLiquid(canvas, size, whitePaint, colorPaint);
        break;
      case 'cream':
        _drawCream(canvas, size, whitePaint, colorPaint);
        break;
      case 'inhaler':
        _drawInhaler(canvas, size, whitePaint, colorPaint);
        break;
      default:
        _drawOther(canvas, size, whitePaint, colorPaint);
    }
  }

  void _drawTablet(Canvas canvas, Size size, Paint whitePaint, Paint strokePaint) {
    final rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width * 0.35);
    canvas.drawOval(rect, whitePaint);
    canvas.drawLine(
      Offset(size.width * 0.15, size.height / 2),
      Offset(size.width * 0.85, size.height / 2),
      strokePaint,
    );
  }

  void _drawCapsule(Canvas canvas, Size size, Paint whitePaint, Paint colorPaint) {
    canvas.save();
    canvas.rotate(-30 * 3.141592653589793 / 180);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.35, size.width * 0.8, size.height * 0.3),
      Radius.circular(size.height * 0.15),
    );
    canvas.drawRRect(rect, whitePaint);
    final halfRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, size.height * 0.35, size.width * 0.4, size.height * 0.3),
      Radius.circular(size.height * 0.15),
    );
    canvas.drawRRect(halfRect, colorPaint);
    canvas.restore();
  }

  void _drawLiquid(Canvas canvas, Size size, Paint whitePaint, Paint colorPaint) {
    final path = Path()
      ..moveTo(size.width * 0.35, size.height * 0.2)
      ..lineTo(size.width * 0.65, size.height * 0.2)
      ..lineTo(size.width * 0.65, size.height * 0.4)
      ..lineTo(size.width * 0.7, size.height * 0.45)
      ..lineTo(size.width * 0.7, size.height * 0.9)
      ..arcToPoint(
        Offset(size.width * 0.3, size.height * 0.9),
        radius: Radius.circular(size.width * 0.05),
      )
      ..lineTo(size.width * 0.3, size.height * 0.45)
      ..lineTo(size.width * 0.35, size.height * 0.4)
      ..close();
    canvas.drawPath(path, whitePaint);
    
    final liquidRect = Rect.fromLTWH(size.width * 0.35, size.height * 0.55, size.width * 0.3, size.height * 0.25);
    canvas.drawRect(liquidRect, colorPaint);
  }

  void _drawCream(Canvas canvas, Size size, Paint whitePaint, Paint colorPaint) {
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.25, size.height * 0.3, size.width * 0.5, size.height * 0.55),
      Radius.circular(size.width * 0.075),
    );
    canvas.drawRRect(bodyRect, whitePaint);
    
    final capRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.15, size.width * 0.3, size.height * 0.15),
      Radius.circular(size.width * 0.0375),
    );
    canvas.drawRRect(capRect, colorPaint);
    
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.325, size.height * 0.45, size.width * 0.35, size.height * 0.075),
      colorPaint.withOpacity(0.4),
    );
  }

  void _drawInhaler(Canvas canvas, Size size, Paint whitePaint, Paint colorPaint) {
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.15, size.width * 0.4, size.height * 0.55),
      Radius.circular(size.width * 0.075),
    );
    canvas.drawRRect(bodyRect, whitePaint);
    
    final baseRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.3, size.height * 0.7, size.width * 0.4, size.height * 0.15),
      Radius.circular(size.width * 0.05),
    );
    canvas.drawRRect(baseRect, colorPaint);
    
    canvas.drawCircle(Offset(size.width / 2, size.height * 0.35), size.width * 0.075, colorPaint.withOpacity(0.5));
  }

  void _drawOther(Canvas canvas, Size size, Paint whitePaint, Paint colorPaint) {
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.25, whitePaint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * 0.1, colorPaint);
  }

  @override
  bool shouldRepaint(covariant _FormGlyphPainter oldDelegate) => false;

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
