import 'dart:ui';

class ActivityProgress {
  final Color color;
  final double progress; // 0.0 to 1.0
  final String label;

  ActivityProgress({
    required this.color,
    required this.progress,
    required this.label,
  });
}
