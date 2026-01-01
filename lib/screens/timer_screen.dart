import 'package:flutter/material.dart';
import 'package:focus_timer/widgets/pomodoro_progress_indicator.dart';

import '../controllers/timer_controller.dart';
import '../models/activity.dart';
import '../models/focus_state.dart';
import '../models/timer_time_format.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen(this.activity, {super.key});

  final Activity activity;

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {

  late final TimerController controller;

  @override
  void initState() {
    super.initState();
    controller = TimerController(widget.activity);
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
        return Scaffold(
            appBar: AppBar(
              title: const Text('Timer'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.activity.label, style: TextStyle(color: widget.activity.seedColor, fontWeight: FontWeight.bold, fontSize: 35),
                      ),
                      SizedBox(height: 20,),
                      Text(
                          formatTimeInHM(controller.activity.focusTimeElapsed, controller.activity.timeGoal),
                          style: TextStyle(
                            fontSize: 35,
                           // fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          )
                      ),
                      Text ('${(controller.progress * 100).toInt()}%', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                      
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                          controller.timeLeft,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: widget.activity.currentFocusState == FocusState.focus ? widget.activity.seedColor : Theme.of(context).colorScheme.primary,
                          ),
                      ),
                      PomodoroProgressIndicator(progress: controller.progress, color: widget.activity.seedColor, segments: controller.activity.timeGoal/controller.focusInterval),
                    ],
                  ),
                  FilledButton(onPressed: () {
                    controller.onButtonPressed();
                  },
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.activity.currentFocusState == FocusState.focus ? widget.activity.seedColor : Theme.of(context).colorScheme.primary,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                    ),
                    child: Icon(controller.isRunning
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded),)
                ],
              ),
            )
        );
      }
    );
  }
}
