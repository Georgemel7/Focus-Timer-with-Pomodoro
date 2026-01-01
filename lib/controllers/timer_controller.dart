import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../models/activity.dart';
import '../models/focus_state.dart';
import '../models/timer_time_format.dart';

class TimerController extends ChangeNotifier {

  final Activity activity;

  TimerController (this.activity);

  Timer? _timer;
  bool isFocusRunning = false;
  bool isBreakRunning = false;
  int focusInterval = 2*60; //in seconds
  int breakInterval = 1*60; //in seconds
  int numOfIntervals = 0;
  late final int maxNumOfFullIntervals = activity.timeGoal ~/ focusInterval;
  late final int lastIntervalDuration = activity.timeGoal % focusInterval;



  bool get isRunning => isFocusRunning || isBreakRunning;





  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }



  void startFocusTimer() {
    if (isFocusRunning) return;

    isFocusRunning = true;
    activity.currentFocusState = FocusState.focus;


    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      activity.focusTimeElapsed++;

      if (activity.focusTimeElapsed-focusInterval*numOfIntervals >= focusInterval) {
        stop();
      }

      notifyListeners();
    });
  }

  void startBreakTimer() {
    if (isBreakRunning) return;

    isBreakRunning = true;
    activity.currentFocusState = FocusState.break_;


    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      activity.breakTimeElapsed++;

      if (activity.breakTimeElapsed >= breakInterval) {
        stop();
      }

      notifyListeners();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    if (activity.currentFocusState == FocusState.focus) {
      isFocusRunning = false;
      activity.currentFocusState = FocusState.break_;
      numOfIntervals++;
    } else if (activity.currentFocusState == FocusState.break_) {
      isBreakRunning = false;
      activity.currentFocusState = FocusState.focus;
      activity.breakTimeElapsed = 0;
    }
    notifyListeners();
  }

  void start() {
    if (activity.currentFocusState == FocusState.break_) {
      startBreakTimer();
    } else if (activity.currentFocusState == FocusState.focus) {
      startFocusTimer();
    }
  }

  void pause(){
    _timer?.cancel();
    _timer = null;
    if (activity.currentFocusState == FocusState.focus) {
      isFocusRunning = false;
    } else if (activity.currentFocusState == FocusState.break_) {
      isBreakRunning = false;
    }
    notifyListeners();
  }

  void onButtonPressed(){
    if (isRunning) {
      pause();
    } else {
      start();
    }
    notifyListeners();
  }

  double get progress {
    if (activity.timeGoal == 0) return 0;
    return activity.focusTimeElapsed / activity.timeGoal;
  }

  String get timeLeft {
    if (activity.currentFocusState == FocusState.focus) {
      return formatTimeInMS(activity.focusTimeElapsed - focusInterval*numOfIntervals, (numOfIntervals >= maxNumOfFullIntervals) ?  lastIntervalDuration : focusInterval);
    }
      return formatTimeInMS(activity.breakTimeElapsed, breakInterval);

  }

}




