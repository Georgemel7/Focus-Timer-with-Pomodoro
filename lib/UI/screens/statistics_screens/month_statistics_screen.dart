import 'package:flutter/material.dart';
import 'package:focus_timer/UI/widgets/overall_progress.dart';
import 'package:focus_timer/UI/widgets/week_widget.dart';
import 'package:focus_timer/data/constants.dart';

import '../../../controllers/stats_controller.dart';
import '../../../models/progress_comparison.dart';
import '../../../models/stats.dart';
import '../../widgets/activity_progress_widget_list.dart';
import '../../widgets/month_calendar.dart';
import '../../widgets/period_changer.dart';

class MonthStatisticsScreen extends StatefulWidget {
  final StatsController controller;

  const MonthStatisticsScreen(this.controller, {super.key});

  @override
  State<MonthStatisticsScreen> createState() => _MonthStatisticsScreenState();
}

class _MonthStatisticsScreenState extends State<MonthStatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        Stats? stats = widget.controller.stats;
        ProgressComparison? comparison = widget.controller.comparison;
        if (stats == null || comparison == null) {
          return const Center(child: Text('Loading...'));
        }
        return ListView(
          children: [
            PeriodChanger(widget.controller),
            WeekDays(),
            Padding(
              padding: const EdgeInsets.fromLTRB(defPadding, 0, 0, 0),
              child: MonthCalendar(
                focusTimeByDay: stats.focusByDay,
                timeGoalByDay: stats.timeGoalByDay,
              ),
            ),
            SizedBox(height: 2 * defPadding),
            Padding(
              padding: EdgeInsets.fromLTRB(defPadding, 0, defPadding, 0),
              child: Divider(),
            ),
            SizedBox(height: 2 * defPadding),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                defPadding * 2,
                0,
                defPadding,
                0,
              ),
              child: OverallProgress(
                progressComparison:
                    comparison ??
                    ProgressComparison(
                      progress: stats.totalTimeGoalTime == 0
                          ? 0
                          : stats.totalFocusTime / stats.totalTimeGoalTime,
                      totalFocusTime: stats.totalFocusTime,
                      previousFocusTime: stats.totalFocusTime,
                      percentDiff: 0,
                      trend: Trend.equal,
                    ),
              ),
            ),
            SizedBox(height: 4 * defPadding),
            Padding(
              padding: EdgeInsets.fromLTRB(
                defPadding * 2,
                0,
                defPadding * 2,
                0,
              ),
              child: ActivityProgressWidgetList(
                activityProgress: widget.controller.activityProgress,
              ),
            ),
          ],
        );
      },
    );
  }
}
