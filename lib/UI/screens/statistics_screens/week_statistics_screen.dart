import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_timer/UI/widgets/week_calendar.dart';
import 'package:focus_timer/UI/widgets/week_widget.dart';

import '../../../controllers/stats_controller.dart';
import '../../../data/constants.dart';
import '../../../models/progress_comparison.dart';
import '../../../models/stats.dart';
import '../../widgets/activity_progress_widget_list.dart';
import '../../widgets/overall_progress.dart';
import '../../widgets/period_changer.dart';

class WeekStatisticsScreen extends StatefulWidget {
  final StatsController controller;

  const WeekStatisticsScreen(this.controller, {super.key});

  @override
  State<WeekStatisticsScreen> createState() => _WeekStatisticsScreenState();
}

class _WeekStatisticsScreenState extends State<WeekStatisticsScreen> {
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
              child: WeekCalendar(
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
              child: OverallProgress(progressComparison: comparison),
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
