import 'dart:math';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime dateTime;
  ClockPainter(this.dateTime);

  final double strokeWidth = 8;
  final double glowBlur = 10;
  final double outerCircleOffset = 5;
  final double tickStrokeWidth = 3;
  final double hourHandLengthFactor = 0.4;
  final double minuteHandLengthFactor = 0.6;
  final double secondHandLengthFactor = 0.70;
  final double centerDotRadius = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    final Paint paintCircle = Paint()
      ..shader = RadialGradient(
        colors: [Colors.white.withOpacity(0.2), Colors.black87],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paintCircle);

    final Paint outerRingPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowBlur);
    canvas.drawCircle(center, radius - outerCircleOffset, outerRingPaint);

    final Paint tickPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = tickStrokeWidth;

    for (int i = 0; i < 60; i++) {
      final double angle = (i * 6) * pi / 180;
      final double tickLength = i % 5 == 0 ? 30 : 12;
      final Offset start = center +
          Offset(cos(angle) * (radius - tickLength - 10),
              sin(angle) * (radius - tickLength - 10));
      final Offset end =
          center + Offset(cos(angle) * (radius - 8), sin(angle) * (radius - 8));
      canvas.drawLine(start, end, tickPaint);
    }

    _drawHandWithGlow(canvas, center, radius * hourHandLengthFactor,
        (dateTime.hour % 12) * 30 + dateTime.minute * 0.5, Colors.white, 10);
    _drawHandWithGlow(canvas, center, radius * minuteHandLengthFactor,
        dateTime.minute * 6, Colors.cyanAccent, 8);
    _drawHandWithGlow(canvas, center, radius * secondHandLengthFactor,
        dateTime.second * 6, Colors.redAccent, 4);

    final Paint glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(center, centerDotRadius, glowPaint);

    final Paint dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, centerDotRadius, dotPaint);
  }

  void _drawHandWithGlow(Canvas canvas, Offset center, double length,
      double angle, Color color, double width) {
    final double radian = (angle - 90) * pi / 180;
    final Offset end =
        center + Offset(cos(radian) * length, sin(radian) * length);

    final Paint glowPaint = Paint()
      ..color = color.withOpacity(0.9)
      ..strokeWidth = width + 2
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5)
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, end, glowPaint);

    final Paint handPaint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, end, handPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
