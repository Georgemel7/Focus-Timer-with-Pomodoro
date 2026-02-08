import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_timer/controllers/app_settings_controller.dart';
import 'package:provider/provider.dart';

import '../alert_dialogs/activity_done_dialog.dart';
import '../data/sessions_storage.dart';
import '../models/activity.dart';
import '../models/activity_session.dart';
import '../models/app_settings.dart';
import '../models/focus_state.dart';
import '../models/timer_time_format.dart';

class TimerController extends ChangeNotifier {
  final Activity activity;
  final SessionsStorage sessionsStorage;
  final BuildContext context;

  TimerController(this.context, this.activity, this.sessionsStorage);

  Timer? _timer;
  late final AppSettings appSettings = context
      .read<AppSettingsController>()
      .settings;
  bool isFocusRunning = false;
  bool isBreakRunning = false;
  late final int maxNumOfFullIntervals = activity.timeGoal ~/ appSettings.focusInterval;
  late final int lastIntervalDuration = activity.timeGoal % appSettings.focusInterval;

  late final ActivitySession session = sessionsStorage.getTodaySession(
    activity,
  );

  bool get isRunning => isFocusRunning || isBreakRunning;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void saveSession() {
    sessionsStorage.save(session);
  }

  void endSession() {
    session.done = true;
    saveSession();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActivityDoneDialog()),
    );
  }

  void startFocusTimer() {
    if (isFocusRunning) return;

    isFocusRunning = true;
    session.currentFocusState = FocusState.focus;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      session.focusTimeElapsed++;

      if (session.focusTimeElapsed - appSettings.focusInterval * session.numOfIntervals >=
          appSettings.focusInterval) {
        stop();
      }

      notifyListeners();
    });
  }

  void startBreakTimer() {
    if (isBreakRunning) return;

    isBreakRunning = true;
    session.currentFocusState = FocusState.break_;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      session.breakTimeElapsed++;

      if (session.breakTimeElapsed >= appSettings.breakInterval) {
        stop();
      }

      notifyListeners();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    isFocusRunning = false;
    isBreakRunning = false;
    if (session.focusTimeElapsed >= activity.timeGoal) {
      endSession();
      notifyListeners();
      return;
    }
    if (session.currentFocusState == FocusState.focus) {
      session.currentFocusState = FocusState.break_;
      session.numOfIntervals++;
    } else if (session.currentFocusState == FocusState.break_) {
      session.currentFocusState = FocusState.focus;
      session.breakTimeElapsed = 0;
    }
    notifyListeners();
    saveSession();
  }

  void start() {
    if (session.currentFocusState == FocusState.break_) {
      startBreakTimer();
    } else if (session.currentFocusState == FocusState.focus) {
      startFocusTimer();
    }
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    if (session.currentFocusState == FocusState.focus) {
      isFocusRunning = false;
    } else if (session.currentFocusState == FocusState.break_) {
      isBreakRunning = false;
    }
    notifyListeners();
    saveSession();
  }

  void onButtonPressed() {
    if (isRunning) {
      pause();
    } else {
      start();
    }
    notifyListeners();
  }

  double get progress {
    if (activity.timeGoal == 0) return 0;
    return session.focusTimeElapsed / activity.timeGoal;
  }

  String get timeLeft {
    if (session.currentFocusState == FocusState.focus) {
      return formatTimeInMS(
        session.focusTimeElapsed - appSettings.focusInterval * session.numOfIntervals,
        (session.numOfIntervals >= maxNumOfFullIntervals)
            ? lastIntervalDuration
            : appSettings.focusInterval,
      );
    }
    return formatTimeInMS(session.breakTimeElapsed, appSettings.breakInterval);
  }
}
