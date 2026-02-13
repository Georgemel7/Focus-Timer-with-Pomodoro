class Stats {
  Map<String, int> totalFocusByActivity;
  Map<String, int> totalTimeGoalByActivity;

  Map<DateTime, int> focusByDay;
  Map<DateTime, int> timeGoalByDay;

  int get totalFocusTime => totalFocusByActivity.values.reduce((a, b) => a + b);
  int get totalTimeGoalTime =>
      totalTimeGoalByActivity.values.reduce((a, b) => a + b);

  Stats({
    required this.totalFocusByActivity,
    required this.totalTimeGoalByActivity,
    required this.focusByDay,
    required this.timeGoalByDay,
  });
}
