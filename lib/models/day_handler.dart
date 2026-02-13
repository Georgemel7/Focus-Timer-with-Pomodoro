import 'package:focus_timer/models/period_handler.dart';
import 'package:focus_timer/models/stats.dart';

class DayHandler extends PeriodHandler<DateTime> {
  DayHandler(super.sessionsStorage, super.activitiesStorage);

  @override
  DateTime getCurrent() {
    return DateTime.now();
  }

  @override
  DateTime getNext(DateTime period) {
    return period.add(const Duration(days: 1));
  }

  @override
  DateTime getPrevious(DateTime period) {
    return period.subtract(const Duration(days: 1));
  }

  @override
  Future<Stats> loadStats(DateTime period) async {
    final totalFocusByActivity = <String, int>{};
    final totalTimeGoalByActivity = <String, int>{};

    final focusByDay = <DateTime, int>{};
    final timeGoalByDay = <DateTime, int>{};

    final day = DateTime(period.year, period.month, period.day);

    final sessions = sessionsStorage.getSessionsByDay(day);

    sessions.forEach((activityId, session) {
      totalFocusByActivity[activityId] =
          (totalFocusByActivity[activityId] ?? 0) + session.focusTimeElapsed;

      totalTimeGoalByActivity[activityId] =
          (totalTimeGoalByActivity[activityId] ?? 0) + session.totalFocusTime;

      focusByDay[day] = (focusByDay[day] ?? 0) + session.focusTimeElapsed;

      timeGoalByDay[day] = (timeGoalByDay[day] ?? 0) + session.totalFocusTime;
    });

    return Stats(
      totalFocusByActivity: totalFocusByActivity,
      totalTimeGoalByActivity: totalTimeGoalByActivity,
      focusByDay: focusByDay,
      timeGoalByDay: timeGoalByDay,
    );
  }
}
