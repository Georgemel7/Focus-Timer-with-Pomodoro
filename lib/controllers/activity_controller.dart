import 'package:flutter/material.dart';
import '../UI/screens/activity_creation_screen.dart';
import '../UI/screens/timer_screen.dart';
import '../models/activity.dart';

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
