import 'package:flutter/material.dart';
import 'package:focus_timer/data/sessions_storage.dart';
import 'package:focus_timer/widgets/pomodoro_progress_indicator.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../alert_dialogs/activity_done_dialog.dart';
import '../controllers/app_settings_controller.dart';
import '../controllers/timer_controller.dart';
import '../data/activities_storage.dart';
import '../models/activity.dart';
import '../models/app_settings.dart';
import '../models/focus_state.dart';
import '../models/timer_time_format.dart';
import '../services/notification_service.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen(this.activity, {super.key});

  final Activity activity;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late final TimerController controller;
  late final AppSettings appSettings;

  @override
  void initState() {
    super.initState();
    appSettings = context.read<AppSettingsController>().settings;
    controller = TimerController(
      appSettings: appSettings,
      notificationService: context.read<NotificationService>(),
      activity: widget.activity,
      sessionsStorage: SessionsStorage(Hive.box('sessions')),
      onSessionFinished: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ActivityDoneDialog()),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final Color buttonColor =
            controller.session.currentFocusState == FocusState.focus
            ? widget.activity.seedColor
            : Theme.of(context).colorScheme.primary;

        return WillPopScope(
          onWillPop: () async {
            context.read<ActivitiesStorage>().updateActivity(
              widget.activity,
              widget.activity,
            );
            controller.saveSession();
            Navigator.pop(context);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('Timer')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      /*Container(
                width: 6,
                height: 0.001,
              decoration: BoxDecoration(
                color: widget.activity.seedColor.withOpacity(0.07),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: widget.activity.seedColor.withOpacity(0.05),
                    blurRadius: 60,
                    spreadRadius: 80,
                  ),
                ],
              ),),*/
                      Column(
                        children: [
                          Text(
                            widget.activity.label,
                            style: TextStyle(
                              color: widget.activity.seedColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 35,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            formatTimeInHM(
                              controller.session.focusTimeElapsed,
                              controller.activity.timeGoal,
                            ),
                            style: TextStyle(
                              fontSize: 35,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            '${(controller.progress * 100).toInt()}%',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      controller.session.done
                          ? Icon(
                              Icons.check_rounded,
                              color: widget.activity.seedColor,
                              size: 100,
                            )
                          : Column(
                              children: [
                                Text(
                                  controller.session.currentFocusState ==
                                          FocusState.focus
                                      ? 'Focus'
                                      : 'Break',
                                ),
                                Text(
                                  controller.timeLeft,
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        controller.session.currentFocusState ==
                                            FocusState.focus
                                        ? widget.activity.seedColor
                                        : Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                      PomodoroProgressIndicator(
                        progress: controller.progress,
                        color: widget.activity.seedColor,
                        segments:
                            controller.activity.timeGoal /
                            controller.appSettings.focusInterval,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (!controller.session.done)
                          BoxShadow(
                            color: buttonColor.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                      ],
                    ),
                    child: FilledButton(
                      onPressed: () {
                        controller.onButtonPressed();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: controller.session.done
                            ? Colors.transparent
                            : buttonColor,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: Icon(
                        controller.isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: controller.session.done
                            ? Colors.transparent
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
