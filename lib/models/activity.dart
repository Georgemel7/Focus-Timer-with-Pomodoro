/*
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

  ActivitySession session = ActivitySession();
}
*/
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'weekday.dart';
import 'activity_session.dart';

part '../hive_adapters/activity.g.dart';

@HiveType(typeId: 0)
class Activity extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  Color seedColor;

  @HiveField(2)
  String label;

  @HiveField(3)
  int timeGoal; //in seconds

  @HiveField(4)
  List<Weekday> activeDays;

  Activity({
    required this.seedColor,
    required this.label,
    required this.timeGoal,
    required this.activeDays,
    required this.id,
  });
}
