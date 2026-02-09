import 'package:hive/hive.dart';

import '../models/activity.dart';
import '../models/activity_session.dart';

class SessionsStorage {
  final Box<ActivitySession> _box;

  SessionsStorage(this._box);

  List<ActivitySession> getAllSessions() {
    return List.unmodifiable(_box.values.toList());
  }

  void addSession(ActivitySession activitySession) {
    _box.add(activitySession);
  }

  void save(ActivitySession session) {
    session.save();
  }

  ActivitySession getTodaySession(Activity activity) {
    final today = DateTime.now();
    final day = DateTime(today.year, today.month, today.day);

    return _box.values.firstWhere(
      (s) => s.activityId == activity.id && s.day == day,
      orElse: () {
        final session = ActivitySession(activityId: activity.id, day: day);
        _box.add(session);
        return session;
      },
    );
  }
}
