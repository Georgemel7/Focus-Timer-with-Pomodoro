import 'package:flutter/cupertino.dart';

import 'day_container.dart';

class MonthCalendar extends StatelessWidget {
  final Map<DateTime, int> focusTimeByDay;
  final Map<DateTime, int> timeGoalByDay;

  const MonthCalendar({
    super.key,
    required this.focusTimeByDay,
    required this.timeGoalByDay,
  });

  @override
  Widget build(BuildContext context) {
    final oneSize = (MediaQuery.of(context).size.width-10) / 7;

    final days = focusTimeByDay.keys.toList()..sort();
    final length = days.length;
    final start = days.first.weekday - 1;

    final totalCells = start + length;
    final totalRows = (totalCells / 7).ceil();

    List<Widget> rows = [];

    for (int row = 0; row < totalRows; row++) {
      List<Widget> week = [];
      for (int col = 0; col < 7; col++) {
        int idx = row * 7 + col - start;
        if (idx >= 0 && idx < length) {
          final day = days[idx];
          final goal = timeGoalByDay[day] ?? 1;
          final progress = goal == 0 ? 0.0 : (focusTimeByDay[day]! / goal);
          week.add(Expanded(
            child: DayContainer(day: day.day, progress: progress),
          ));
        } else {
          week.add(SizedBox(width: oneSize, height: oneSize));
        }
      }
      rows.add(Row(children: week));
    }

    return Column(children: rows);
  }
}
