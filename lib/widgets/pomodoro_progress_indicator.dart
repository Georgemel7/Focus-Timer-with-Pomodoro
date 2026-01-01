import 'dart:math';
import 'package:flutter/material.dart';

class PomodoroProgressIndicator extends StatelessWidget {
  final double progress;
  final Color color;
  final double segments;
  final double strokeWidth;

  const PomodoroProgressIndicator({
    Key? key,
    required this.progress,
    required this.color,
    required this.segments,
    this.strokeWidth = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(260, 260),
      painter: _PomodoroProgressPainter(
        progress: progress,
        color: color,
        segments: segments,
      ),
    );
  }
}


class _PomodoroProgressPainter extends CustomPainter {
  final double progress; // 0.0 - 1.0
  final double segments;
  final double activeStrokeWidth = 24;
  final double backgroundStrokeWidth = 14;
  final Color color;


  _PomodoroProgressPainter({
    required this.progress,
    required this.color,
    required this.segments,
  });



  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final int fullSegments = segments.toInt();
    final double finalPartOfSegment = segments - fullSegments.toDouble();

    final fullCircle = 2 * pi;
    const gapAngle = 0.3; // visual break size
    final segmentAngle =
        (fullCircle - gapAngle * (finalPartOfSegment != 0 ? fullSegments + 1 : fullSegments)) / segments;
    final finalPartOfSegmentAngle = segmentAngle * finalPartOfSegment;


    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = backgroundStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color = ColorScheme.fromSeed(seedColor: color).outlineVariant.withOpacity(0.3);


    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = activeStrokeWidth
      ..strokeCap = StrokeCap.round
      ..color =color;

    double startAngle = 3*pi / 2 + gapAngle /2;

    double remainingProgress = 1- progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      finalPartOfSegmentAngle,
      false,
      backgroundPaint,
    );

    // active segment
    if (remainingProgress > 0) {
      final drawAngle =  min (fullCircle * remainingProgress, finalPartOfSegmentAngle);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        drawAngle,
        false,
        activePaint,
      );

      remainingProgress -= finalPartOfSegment/segments;
    }

    startAngle += finalPartOfSegmentAngle + gapAngle;








    for (int i = 0; i < fullSegments; i++) {
      // background segment
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        false,
        backgroundPaint,
      );

      // active segment
      if (remainingProgress > 0) {
        final drawAngle =
        min(segmentAngle, 2*pi * remainingProgress);

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          drawAngle,
          false,
          activePaint,
        );

        remainingProgress -= 1 / segments;
      }

      startAngle += segmentAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _PomodoroProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
