import 'package:flutter/material.dart';
import 'package:focus_timer/screens/activity_creation_screen.dart';
import '../models/activity.dart';
import '../screens/timer_screen.dart';

class ActivityController {
  void editActivity(BuildContext context, Activity activity) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ActivityCreationScreen(activity)),
    );
  }

  void goToTimer(BuildContext context, Activity activity) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerScreen(activity)),
    );
  }
}
