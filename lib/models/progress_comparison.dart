class ProgressComparison {
  final double progress;
  final int totalFocusTime;
  final int previousFocusTime;
  final double percentDiff;
  final Trend trend;

  ProgressComparison({
    required this.progress,
    required this.totalFocusTime,
    required this.previousFocusTime,
    required this.percentDiff,
    required this.trend,
  });
}

enum Trend {
  up,
  down,
  equal,
}