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
  FocusState currentFocusState;

  @HiveField(3)
  bool done;

  @HiveField(4)
  DateTime? breakStartedAt;

  @HiveField(5)
  DateTime? focusStartedAt;

  @HiveField(6)
  int totalFocusTime;

  @HiveField(7)
  int totalBreakTime;

  int get focusTimeElapsed {
    if(currentFocusState != FocusState.focus) return 0;
    if(focusStartedAt == null) return 0;
    return DateTime.now().difference(focusStartedAt!).inSeconds;
  }

  int get breakTimeElapsed {
    if(currentFocusState != FocusState.break_) return 0;
    if(breakStartedAt == null) return 0;
    return DateTime.now().difference(breakStartedAt!).inSeconds;
  }


  ActivitySession({
    required this.activityId,
    required this.day,
    this.done = false,

    this.currentFocusState = FocusState.focus,
    this.totalFocusTime = 0,
    this.totalBreakTime = 0,
  });
}
