import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
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

  late final ActivitySession session = sessionsStorage.getTodaySession(
    activity,
  );

  bool get isRunning => isFocusRunning || isBreakRunning;

  late final int lastIntervalDuration = activity.timeGoal % appSettings.focusInterval;

  int get currentBreakIntervalDuration {
    return appSettings.breakInterval - session.totalBreakTime % appSettings.breakInterval;
  }

  int get currentFocusIntervalDuration {
    if(session.totalFocusTime % appSettings.focusInterval == 0){
      if (activity.timeGoal - session.totalFocusTime < appSettings.focusInterval) {
        return lastIntervalDuration;
      }
      return appSettings.focusInterval;
    } else {
      if (activity.timeGoal - session.totalFocusTime < appSettings.focusInterval) {
        return lastIntervalDuration ==0 ? appSettings.focusInterval - session.totalFocusTime % appSettings.focusInterval : lastIntervalDuration - session.totalFocusTime % appSettings.focusInterval;
      }
      return appSettings.focusInterval - session.totalFocusTime % appSettings.focusInterval;
    }

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void saveSession() {
    sessionsStorage.save(session);
  }

  void endSession() {
    session.totalFocusTime = activity.timeGoal;
    session.done = true;
    saveSession();
    onSessionFinished();
  }

  void startFocusTimer() async {
    if (isFocusRunning) return;

    isFocusRunning = true;
    session.currentFocusState = FocusState.focus;

    notificationService.scheduleFocusEndNotification(tz.TZDateTime.now(tz.local).add(Duration(seconds: currentFocusIntervalDuration)));
    session.focusStartedAt = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (session.focusTimeElapsed >= currentFocusIntervalDuration) {
        stop();
      }

      notifyListeners();
    });
  }

  void startBreakTimer() async {
    if (isBreakRunning) return;

    isBreakRunning = true;
    session.currentFocusState = FocusState.break_;

    notificationService.scheduleBreakEndNotification(tz.TZDateTime.now(tz.local).add(Duration(seconds: currentBreakIntervalDuration)));
    session.breakStartedAt = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (session.breakTimeElapsed >= currentBreakIntervalDuration) {
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
    session.focusStartedAt = null;
    session.breakStartedAt = null;


    if (session.totalFocusTime + currentFocusIntervalDuration >= activity.timeGoal && session.currentFocusState == FocusState.focus) {
      endSession();
      notifyListeners();
      return;
    }
    if (session.currentFocusState == FocusState.focus) {
      session.currentFocusState = FocusState.break_;
      session.totalFocusTime += currentFocusIntervalDuration;
    } else if (session.currentFocusState == FocusState.break_) {
      session.currentFocusState = FocusState.focus;
      session.totalBreakTime = 0;
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
      session.totalFocusTime += session.focusTimeElapsed;
      session.focusStartedAt = null;
    } else if (session.currentFocusState == FocusState.break_) {
      isBreakRunning = false;
      session.totalBreakTime += session.breakTimeElapsed;
      session.breakStartedAt = null;
    }
    notificationService.cancelNotifications();

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
    if (session.done) return 1;
    return (session.totalFocusTime +
        session.focusTimeElapsed) / activity.timeGoal;
  }

  String get timeLeft {
    if (session.currentFocusState == FocusState.focus) {
      return formatTimeInMS(
        session.focusTimeElapsed >= 0 ? session.focusTimeElapsed : 0,
        currentFocusIntervalDuration,
      );
    }
    return formatTimeInMS(session.breakTimeElapsed, currentBreakIntervalDuration);
  }
}
