import 'package:flutter/material.dart';
import 'package:focus_timer/models/period_handler.dart';

import '../models/activity.dart';
import '../models/activity_progress.dart';
import '../models/progress_comparison.dart';
import '../models/stats.dart';

class StatsController<T> extends ChangeNotifier {
  final PeriodHandler<T> _handler;
  late T period;
  
  Stats? stats;
  Stats? previousStats;
  List<ActivityProgress> activityProgress = [];
  ProgressComparison? comparison;

  bool isLoading = false;

  StatsController(this._handler) {
    period = _handler.getCurrent();
    loadStats();
  }

  Future<void> loadStats() async {
    isLoading = true;
    notifyListeners();

    try {
      stats = await _handler.loadStats(period);
      previousStats = await _handler.loadStats(_handler.getPrevious(period));

      if (stats != null && previousStats != null) {
        comparison = _buildComparison(stats!, previousStats!);
        activityProgress = _buildActivityProgress(stats!);
      } else {
        comparison = null;
        activityProgress = [];
      }
    } catch (e) {
      debugPrint("Error in StatsController: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> next() async {
    period = _handler.getNext(period);
    await loadStats();
  }

  Future<void> previous() async {
    period = _handler.getPrevious(period);
    await loadStats();
  }

  ProgressComparison _buildComparison(Stats current, Stats previous) {
    final total = current.totalFocusTime;
    final prevTotal = previous.totalFocusTime;

    double percentDiff;
    Trend trend;

    if (prevTotal == 0) {
      percentDiff = total == 0 ? 0 : 100;
      trend = total == 0 ? Trend.equal : Trend.up;
    } else {
      percentDiff = ((total - prevTotal) / prevTotal) * 100;

      if (total > prevTotal) {
        trend = Trend.up;
      } else if (total < prevTotal) {
        trend = Trend.down;
      } else {
        trend = Trend.equal;
      }
    }

    return ProgressComparison(
      progress: current.totalTimeGoalTime == 0
          ? 0
          : total / current.totalTimeGoalTime,
      totalFocusTime: total,
      previousFocusTime: prevTotal,
      percentDiff: percentDiff.abs(),
      trend: trend,
    );
  }

  List<ActivityProgress> _buildActivityProgress(Stats current) {
    List<ActivityProgress> list = [];
    final knownActivities = _handler.activitiesStorage.getAllActivities();

    for (final activityId in current.totalFocusByActivity.keys) {
      if (activityId == '-1') continue;

      final activity = knownActivities.cast<Activity?>().firstWhere(
            (a) => a?.id == activityId,
            orElse: () => null,
          );

      if (activity == null) continue;
      
      final goal = current.totalTimeGoalByActivity[activityId] ?? 0;
      final focus = current.totalFocusByActivity[activityId] ?? 0;
      
      final double progress = goal != 0 ? focus / goal : 0.0;

      list.add(
        ActivityProgress(
          color: activity.seedColor,
          progress: progress,
          label: activity.label,
        ),
      );
    }
    return list;
  }
}
