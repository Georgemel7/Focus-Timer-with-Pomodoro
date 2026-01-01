import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focus_timer/data/activities_storage.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../models/weekday.dart';

class ActivityEditController extends ChangeNotifier {

  final Activity? activity;

  late String label;
  late Color seedColor;
  late int timeGoal;
  late List<Weekday> activeDays;

  ActivityEditController(this.activity) {
    label = activity?.label ?? '';
    seedColor = activity?.seedColor ?? Colors.blue;
    timeGoal = (activity?.timeGoal ?? 60*60)~/60; //from seconds to minutes
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

  void save (BuildContext context) {
    if (activity != null) {
      context.read<ActivitiesStorage>().updateActivity(activity!, Activity(seedColor: seedColor, label: label, timeGoal: timeGoal*60, activeDays: activeDays));
    } else {
      context.read<ActivitiesStorage>().addActivity(Activity(seedColor: seedColor, label: label, timeGoal: timeGoal*60, activeDays: activeDays));
    }
    Navigator.pop(context);
  }
}


