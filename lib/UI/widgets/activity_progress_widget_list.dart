import 'package:flutter/material.dart';
import 'package:focus_timer/data/constants.dart';

import '../../models/activity_progress.dart';

class ActivityProgressWidgetList extends StatelessWidget {
  final List<ActivityProgress> activityProgress;

  const ActivityProgressWidgetList({required this.activityProgress, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (ActivityProgress activityPr in activityProgress)
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  activityPr.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                flex: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    minHeight: 10,
                    value: activityPr.progress,
                    color: activityPr.color,
                  ),
                ),
              ),
              SizedBox(width: defPadding/2),
              Expanded(
                flex: 1,
                child: Text(
                  '${(activityPr.progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            ],
          ),
      ],
    );
  }
}
