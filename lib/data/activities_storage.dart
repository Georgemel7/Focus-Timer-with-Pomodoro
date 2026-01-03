import 'package:flutter/material.dart';
import 'package:focus_timer/models/activity.dart';
import 'package:focus_timer/models/weekday.dart';
import 'package:hive/hive.dart';

class ActivitiesStorage extends ChangeNotifier {
  final Box<Activity> _box = Hive.box<Activity>('activities');

  List<Activity> getAllActivities() {
    return List.unmodifiable(_box.values.toList());
  }

  List<Activity> getActivitiesByWeekday(Weekday weekday) {
    return List.unmodifiable(
      _box.values
          .where((activity) => activity.activeDays.contains(weekday))
          .toList(),
    );
  }

  void addActivity(Activity activity) {
    _box.add(activity);
    notifyListeners();
  }

  void removeActivity(Activity activity) {
    activity.delete(); // deleting from Hive
    notifyListeners();
  }

  void updateActivity(Activity initialActivity, Activity updatedActivity) {
    initialActivity
      ..label = updatedActivity.label
      ..timeGoal = updatedActivity.timeGoal
      ..seedColor = updatedActivity.seedColor
      ..activeDays = updatedActivity.activeDays
      ..save();
    notifyListeners();
  }
}
