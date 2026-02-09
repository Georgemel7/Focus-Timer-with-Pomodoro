import 'dart:async';

import 'package:flutter/material.dart';
import '../data/sessions_storage.dart';
import '../models/activity.dart';
import '../models/activity_session.dart';
import '../models/app_settings.dart';
import '../models/focus_state.dart';
import '../models/timer_time_format.dart';
import '../services/notification_service.dart';

class TimerController extends ChangeNotifier {
  final Activity activity;
  final SessionsStorage sessionsStorage;
  final AppSettings appSettings;
  final NotificationService notificationService;
  final VoidCallback onSessionFinished;

  TimerController({
    required this.appSettings,
    required this.activity,
    required this.sessionsStorage,
    required this.notificationService,
    required this.onSessionFinished,
  });

  Timer? _timer;

  bool isFocusRunning = false;
  bool isBreakRunning = false;

  late final int maxNumOfFullIntervals =
      activity.timeGoal ~/ appSettings.focusInterval;
  late final int lastIntervalDuration =
      activity.timeGoal % appSettings.focusInterval;

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
    onSessionFinished();
  }

  void startFocusTimer() {
    if (isFocusRunning) return;

    isFocusRunning = true;
    session.currentFocusState = FocusState.focus;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      session.focusTimeElapsed++;

      if (session.focusTimeElapsed -
              appSettings.focusInterval * session.numOfIntervals >=
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

  void stop() async {
    _timer?.cancel();
    _timer = null;
    isFocusRunning = false;
    isBreakRunning = false;
    await notificationService.playFocusEnd();

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
        session.focusTimeElapsed -
            appSettings.focusInterval * session.numOfIntervals,
        (session.numOfIntervals >= maxNumOfFullIntervals)
            ? lastIntervalDuration
            : appSettings.focusInterval,
      );
    }
    return formatTimeInMS(session.breakTimeElapsed, appSettings.breakInterval);
  }
}
