import 'package:flutter/material.dart';
import 'package:focus_timer/data/sessions_storage.dart';
import 'package:focus_timer/models/activity.dart';
import 'package:focus_timer/models/activity_session.dart';
import 'package:focus_timer/models/weekday_and_month.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../controllers/activity_controller.dart';
import '../../models/timer_time_format.dart';


class ActivityCard extends StatelessWidget {
  ActivityCard({
    super.key,
    required this.activity,
    required this.cardColorScheme,
  });

  final Activity activity;
  final ColorScheme cardColorScheme;


  @override
  Widget build(BuildContext context) {

    late final ActivitySession? session;

    bool isActiveToday() {
      final today = DateTime.now().weekday-1;
      for(int i = 0; i < activity.activeDays.length; i++) {
        if(Weekday.values.indexOf(activity.activeDays[i]) == today) {
          return true;
        }
      }
      return false;
    }

    if(isActiveToday()) {
      session = context.read<SessionsStorage>().getTodaySession(activity);
    } else {
      session = ActivitySession(activityId: activity.id, day: DateTime.now());
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cardColorScheme.surfaceContainerHighest,
        boxShadow: [
          BoxShadow(
            color: cardColorScheme.shadow.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    session!.done || !isActiveToday() ? (){} : ActivityController().goToTimer(context, activity);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: session.done || !isActiveToday()
                          ? cardColorScheme.outlineVariant
                          : cardColorScheme.primary,
                    ),
                    child: session.done || !isActiveToday()
                        ? Icon(
                            Icons.check_rounded,
                            color: cardColorScheme.primary,
                            size: 35,
                          )
                        : Icon(
                            Icons.play_arrow_rounded,
                            color: cardColorScheme.onPrimary,
                          ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                flex: 4,
                child: InkWell(
                  onTap: () {
                    ActivityController().editActivity(context, activity);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity.label,
                        style: TextStyle(
                          color: cardColorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        formatTimeInHM(
                          (session.focusTimeElapsed + session.totalFocusTime),
                          activity.timeGoal,
                        ),
                        style: TextStyle(
                          color: cardColorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: LinearProgressIndicator(
                                value:
                                    ((session.focusTimeElapsed + session.totalFocusTime) /
                                            activity.timeGoal)
                                        .clamp(0, 1),
                                backgroundColor: cardColorScheme.outlineVariant,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  cardColorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${((session.totalFocusTime + session.focusTimeElapsed) / activity.timeGoal * 100).toInt()}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: cardColorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
