import 'package:hive/hive.dart';

import 'focus_state.dart';

part '../hive_adapters/activity_session.g.dart';

@HiveType(typeId: 1)
class ActivitySession extends HiveObject {
  @HiveField(0)
  String activityId;

  @HiveField(1)
  DateTime day;

  @HiveField(2)
  int focusTimeElapsed;

  @HiveField(3)
  int breakTimeElapsed;

  @HiveField(4)
  FocusState currentFocusState;

  @HiveField(5)
  int numOfIntervals;

  @HiveField(6)
  bool done;

  ActivitySession({
    required this.activityId,
    required this.day,
    this.done = false,

    this.focusTimeElapsed = 0,
    this.breakTimeElapsed = 0,
    this.currentFocusState = FocusState.focus,
    this.numOfIntervals = 0,
  });
}
