import 'package:flutter/material.dart';
import 'package:focus_timer/models/activity.dart';
import 'package:focus_timer/models/weekday.dart';

class ActivitiesStorage extends ChangeNotifier {
  final List<Activity> _activities = <Activity>[
    Activity(
      label: 'Algebra',
      timeGoal: 60*60,
      activeDays: [
        Weekday.monday,
        Weekday.tuesday,
        Weekday.wednesday,
        Weekday.thursday
      ],
      seedColor: Colors.lightGreenAccent,
    ),
    Activity(
      label: 'After Effects',
      timeGoal: 60*60,
      activeDays: [Weekday.friday, Weekday.saturday],
      seedColor: Colors.purple,
    ),
    Activity(
      label: 'Flutter',
      timeGoal: 120*60,
      activeDays: [Weekday.saturday, Weekday.sunday],
      seedColor: Colors.blue,
    ),
  ];

  List<Activity> getAllActivities() {
    return List.unmodifiable(_activities);
  }

  List<Activity> getActivitiesByWeekday(Weekday weekday) {
    return List.unmodifiable(
        _activities.where((activity) => activity.activeDays.contains(weekday)).toList());
  }

  void addActivity(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  void removeActivity(Activity activity) {
    _activities.remove(activity);
    notifyListeners();
  }

  void updateActivity(Activity initialActivity, Activity updatedActivity) {
    _activities.remove(initialActivity);
    _activities.add(updatedActivity);
    notifyListeners();
  }
}
