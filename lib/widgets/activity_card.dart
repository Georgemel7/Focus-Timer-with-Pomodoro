import 'package:flutter/material.dart';
import 'package:focus_timer/models/activity.dart';

import '../controllers/activity_controller.dart';
import '../models/timer_time_format.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard(
      {super.key,
      required this.activity,
      required this.cardColorScheme});

  final Activity activity;
  final ColorScheme cardColorScheme;


  @override
  Widget build(BuildContext context) {
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
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {ActivityController().goToTimer(context, activity);},
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: cardColorScheme.primary,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: cardColorScheme.onPrimary,
                    ),
                  ),
                )),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 4,
              child: InkWell(
                onTap: () {ActivityController().editActivity(context, activity);},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.label,
                      style: TextStyle(
                          color: cardColorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Text(
                      formatTimeInHM(activity.focusTimeElapsed, activity.timeGoal),
                      style: TextStyle(color: cardColorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (activity.focusTimeElapsed / activity.timeGoal).clamp(0, 1),
                      backgroundColor: cardColorScheme.outlineVariant,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(cardColorScheme.primary),
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
