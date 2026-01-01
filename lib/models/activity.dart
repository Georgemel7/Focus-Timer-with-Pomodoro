import 'package:flutter/material.dart';
import 'package:focus_timer/models/weekday.dart';

import 'focus_state.dart';

class Activity {
  Color seedColor;
  String label;
  int timeGoal; //seconds
  List<Weekday> activeDays;

  Activity({
    required this.seedColor,
    required this.label,
    required this.timeGoal,
    required this.activeDays,
  });

  int focusTimeElapsed = 0; //seconds
  int breakTimeElapsed = 0; //seconds
  FocusState currentFocusState = FocusState.focus;
}
