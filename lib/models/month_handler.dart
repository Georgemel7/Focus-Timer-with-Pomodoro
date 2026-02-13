import 'package:focus_timer/models/period_handler.dart';
import 'package:focus_timer/models/stats.dart';
import 'package:focus_timer/models/weekday.dart';

import '../data/sessions_storage.dart';
import 'activity_session.dart';

class MonthHandler extends PeriodHandler<DateTime> {

  MonthHandler(super.sessionsStorage, super.activitiesStorage);

  @override
  DateTime getCurrent() {
    DateTime today = DateTime.now();
    DateTime startOfMonth = DateTime(today.year, today.month, 1);
    return startOfMonth;
  }

  @override
  DateTime getNext(DateTime period) {
    if(period == getCurrent()) {
      return period;
    }
    if(period.month == 12) {
      return DateTime(period.year + 1, 1, 1);
    }
    return DateTime(period.year, period.month + 1, 1);
  }

  @override
  DateTime getPrevious(DateTime period) {
    if(period.month == 1) {
      return DateTime(period.year - 1, 12, 1);
    }
    return DateTime(period.year, period.month-1, 1);
  }

  @override
  Future<Stats> loadStats(DateTime period) async {

    DateTime now = DateTime.now();
    int daysInMonth = DateTime(period.year, period.month + 1, 0).day;

    final totalFocusByActivity = <String, int>{};
    final totalTimeGoalByActivity = <String, int>{};

    final focusByDay = <DateTime, int>{};
    final timeGoalByDay = <DateTime, int>{};

    for (int i = 0; i < daysInMonth; i++) {
      final day = DateTime(period.year, period.month, i + 1);

      if (day.isAfter(DateTime(now.year, now.month, now.day))) break;

      final sessions = sessionsStorage.getSessionsByDay(day);
      final activities = activitiesStorage.getActiveActivitiesByDay(day);

      int dayFocus = 0;
      int dayGoal = 0;

      for (final activity in activities) {
        final focus = sessions[activity.id]?.totalFocusTime ?? 0;

        totalFocusByActivity[activity.id] =
            (totalFocusByActivity[activity.id] ?? 0) + focus;

        totalTimeGoalByActivity[activity.id] =
            (totalTimeGoalByActivity[activity.id] ?? 0) + activity.timeGoal;

        dayFocus += focus;
        dayGoal += activity.timeGoal;
      }

      focusByDay[day] = dayFocus;
      timeGoalByDay[day] = dayGoal;
    }


    return Stats(
      totalFocusByActivity: totalFocusByActivity,
      totalTimeGoalByActivity: totalTimeGoalByActivity,
      focusByDay: focusByDay,
      timeGoalByDay: timeGoalByDay,
    );

  }

}