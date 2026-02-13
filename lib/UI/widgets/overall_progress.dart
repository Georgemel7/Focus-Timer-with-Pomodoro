import 'package:flutter/material.dart';
import 'package:focus_timer/UI/widgets/pomodoro_progress_indicator.dart';
import 'package:focus_timer/data/constants.dart';
import 'package:focus_timer/models/progress_comparison.dart';
import 'package:focus_timer/models/timer_time_format.dart';

class OverallProgress extends StatelessWidget {
  final ProgressComparison progressComparison;

  const OverallProgress({required this.progressComparison});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${(progressComparison.progress * 100).toInt()}%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: PomodoroProgressIndicator(
                  progress: 1 - progressComparison.progress,
                  color: Theme.of(context).colorScheme.primary,
                  segments: 1 - progressComparison.progress,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: defPadding * 3),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total ${formatOneTimeInHM(progressComparison.totalFocusTime)} spent focusing this month',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  progressComparison.trend == Trend.up
                      ? Icon(Icons.arrow_upward_rounded, color: Colors.green)
                      : (progressComparison.trend == Trend.down
                            ? Icon(Icons.arrow_downward_rounded)
                            : Icon(Icons.equalizer)),
                  Text(
                    '${((progressComparison.percentDiff.abs() > 1 ? '∞' : progressComparison.percentDiff.abs().toInt() * 100))}% then previous',
                    style: TextStyle(
                      color: progressComparison.trend == Trend.up
                          ? Colors.green
                          : progressComparison.trend == Trend.down
                                ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
