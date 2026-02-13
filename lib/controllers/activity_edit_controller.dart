import 'package:flutter/material.dart';
import 'package:focus_timer/data/activities_storage.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../data/sessions_storage.dart';
import '../models/activity.dart';
import '../models/weekday.dart';

class ActivityEditController extends ChangeNotifier {
  final Activity? activity;

  late String label;
  late Color seedColor;
  late int timeGoal;
  late List<Weekday> activeDays;

  final SessionsStorage sessionsStorage;


  ActivityEditController(this.activity, this.sessionsStorage) {
    label = activity?.label ?? '';
    seedColor = activity?.seedColor ?? Colors.blue;
    timeGoal = (activity?.timeGoal ?? 60 * 60) ~/ 60; //from seconds to minutes
    activeDays = List.from(activity?.activeDays ?? []);
  }

  void setLabel(String value) {
    label = value;
    notifyListeners();
  }

  void setSeedColor(Color value) {
    seedColor = value;
    notifyListeners();
  }

  void setTimeGoal(int value) {
    timeGoal = value;
    notifyListeners();
  }

  void setActiveDays(List<Weekday> value) {
    activeDays = value;
    notifyListeners();
  }

  void delete(BuildContext context) {
    context.read<ActivitiesStorage>().removeActivity(activity!);
  }

  void save(BuildContext context) {
    if (activity != null) {
      if (timeGoal > activity!.timeGoal) {
        sessionsStorage.getTodaySession(activity!).done =
            false;
      }
      context.read<ActivitiesStorage>().updateActivity(
        activity!,
        Activity(
          id: activity!.id,
          seedColor: seedColor,
          label: label,
          timeGoal: timeGoal * 60,
          activeDays: activeDays,
          createdAt: activity!.createdAt,
        ),
      );
    } else {
      context.read<ActivitiesStorage>().addActivity(
        Activity(
          id: DateTime.now().toString(),
          seedColor: seedColor,
          label: label,
          timeGoal: timeGoal * 60,
          activeDays: activeDays,
          createdAt: DateTime.now(),
        ),
      );
    }
  }
}
