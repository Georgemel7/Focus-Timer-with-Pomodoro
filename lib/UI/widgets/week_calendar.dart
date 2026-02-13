import 'package:flutter/cupertino.dart';

import 'day_container.dart';

class WeekCalendar extends StatelessWidget {
  final Map<DateTime, int> focusTimeByDay;
  final Map<DateTime, int> timeGoalByDay;

  const WeekCalendar({
    super.key,
    required this.focusTimeByDay,
    required this.timeGoalByDay,
  });

  @override
  Widget build(BuildContext context) {
    final days = focusTimeByDay.keys.toList()..sort();
    int len = days.length;

    return Row(
      children: [
        for (int i = 0; i < 7; i++)
          Expanded(
            child: Builder(
              builder: (_) {
                if (i >= len) {
                  return const SizedBox.shrink();
                }

                final focus = focusTimeByDay[days[i]] ?? 0;
                final goal = timeGoalByDay[days[i]] ?? 0;
                final progress = goal == 0 ? 0.0 : focus / goal;

                return DayContainer(
                  day: days[i].day,
                  progress: progress,
                );
              },
            ),
          ),
      ],
    );
  }
}
