import 'package:focus_timer/models/stats.dart';

import '../data/activities_storage.dart';
import '../data/sessions_storage.dart';

abstract class PeriodHandler<T> {

  final SessionsStorage sessionsStorage;
  final ActivitiesStorage activitiesStorage;


  PeriodHandler(this.sessionsStorage, this.activitiesStorage);

  T getCurrent();

  T getNext (T period);

  T getPrevious (T period);

  Future<Stats> loadStats(T period);
}