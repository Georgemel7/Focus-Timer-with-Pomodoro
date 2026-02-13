import 'package:flutter/material.dart';
import 'package:focus_timer/models/activity.dart';
import 'package:focus_timer/models/weekday.dart';
import 'package:hive/hive.dart';

class ActivitiesStorage extends ChangeNotifier {
  final Box<Activity> _box = Hive.box<Activity>('activities');

  List<Activity> getAllActiveActivities() {
    return List.unmodifiable(
      _box.values.where((activity) => activity.deletedAt == null).toList(),
    );
  }

  List<Activity> getAllActivities() {
    return List.unmodifiable(_box.values.toList());
  }

  List<Activity> getActiveActivitiesByWeekday(Weekday weekday) {
    return List.unmodifiable(
      _box.values
          .where(
            (activity) =>
                activity.activeDays.contains(weekday) &&
                activity.deletedAt == null,
          )
          .toList(),
    );
  }

  List<Activity> getActiveActivitiesByDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);

    return List.unmodifiable(
      _box.values.where((activity) {
        final activityEnd = activity.deletedAt != null
            ? DateTime(activity.deletedAt!.year, activity.deletedAt!.month, activity.deletedAt!.day)
            : null;

        final isActiveOnDay = activity.activeDays.contains(Weekday.values[normalized.weekday - 1]);
        final isAfterCreated = !normalized.isBefore(DateTime(activity.createdAt.year, activity.createdAt.month, activity.createdAt.day));
        final isBeforeDeleted = activityEnd == null || normalized.isBefore(activityEnd.add(Duration(days: 1)));

        return isActiveOnDay && isAfterCreated && isBeforeDeleted;
      }).toList(),
    );
  }

  void addActivity(Activity activity) {
    _box.add(activity);
    notifyListeners();
  }

  void removeActivity(Activity activity) {
    activity.deletedAt = DateTime.now();
    activity.save();
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

  Activity getActivity(String id) {
    return getAllActivities().firstWhere(
      (activity) => activity.id == id,
      orElse: () {
        return Activity(
          seedColor: Colors.white,
          label: '',
          timeGoal: 0,
          activeDays: [],
          id: '',
          createdAt: DateTime.now(),
        );
      },
    );
  }
}
