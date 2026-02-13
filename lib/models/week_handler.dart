import 'package:focus_timer/models/period_handler.dart';
import 'package:focus_timer/models/stats.dart';
import 'package:focus_timer/models/weekday_and_month.dart';

import '../data/sessions_storage.dart';
import 'activity_session.dart';

class WeekHandler extends PeriodHandler<DateTime> {

  WeekHandler(super.sessionsStorage, super.activitiesStorage);

  @override
  DateTime getCurrent() {
    DateTime today = DateTime.now();
    DateTime day = DateTime(today.year, today.month, today.day);
    DateTime startOfWeek = day.subtract(Duration(days: today.weekday - 1));
    return startOfWeek;
  }

  @override
  DateTime getNext(DateTime period) {
    if(period == getCurrent()){
      return period;
    }
    return period.add(Duration(days: 7));
  }

  @override
  DateTime getPrevious(DateTime period) {
    return period.subtract(Duration(days: 7));
  }

  @override
  Future<Stats> loadStats(DateTime period) async {
    DateTime now = DateTime.now();

    final totalFocusByActivity = <String, int>{};
    final totalTimeGoalByActivity = <String, int>{};

    final focusByDay = <DateTime, int>{};
    final timeGoalByDay = <DateTime, int>{};

    for (int i = 0; i < 7; i++) {
      final day = DateTime(period.year, period.month, period.day + i);

      if(day.isAfter(DateTime(now.year, now.month, now.day))) break;

      final sessions = sessionsStorage.getSessionsByDay(day);
      final dayActivities = activitiesStorage.getActiveActivitiesByDay(day);

      int dayFocus = 0;
      int dayGoal = 0;

      for (final activity in dayActivities) {
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