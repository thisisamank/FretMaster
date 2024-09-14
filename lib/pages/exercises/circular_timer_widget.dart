import 'dart:math' as math;

import 'package:flutter/material.dart';



class CircularTimerWidget extends StatelessWidget {
  final Widget child;
  final int remainingTime;
  final int totalTime;

  const CircularTimerWidget({
    super.key,
    required this.child,
    required this.remainingTime,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    double progress = totalTime > 0 ? 1 - (remainingTime / totalTime) : 0;
    print('progress: $progress');
    return CustomPaint(
      painter: TimerPainter(progress: progress, context: context),
      child: Container(
        width: 200,
        height: 200,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  final BuildContext context;

  TimerPainter({required this.progress, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    Paint circlePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..color = Theme.of(context).primaryColor
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = math.min(size.width / 2, size.height / 2);
    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, circlePaint);

    double sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
