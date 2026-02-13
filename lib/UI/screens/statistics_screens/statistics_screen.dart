import 'package:flutter/material.dart';
import 'package:focus_timer/UI/screens/statistics_screens/week_statistics_screen.dart';
import 'package:focus_timer/data/activities_storage.dart';
import 'package:provider/provider.dart';

import '../../../controllers/stats_controller.dart';
import '../../../data/sessions_storage.dart';
import '../../../models/day_handler.dart';
import '../../../models/month_handler.dart';
import '../../../models/week_handler.dart';
import 'day_statistics_screen.dart';
import 'month_statistics_screen.dart';

 class StatisticsScreen extends StatefulWidget {
   const StatisticsScreen({super.key});

   @override
   State<StatisticsScreen> createState() => _StatisticsScreenState();
 }

 class _StatisticsScreenState extends State<StatisticsScreen> {


   late final MonthHandler monthHandler;
   late final StatsController<DateTime> monthController;

   late final DayHandler dayHandler;
   late final StatsController<DateTime> dayController;

   late final WeekHandler weekHandler;
   late final StatsController<DateTime> weekController;

    late final SessionsStorage sessionsStorage;
    late final ActivitiesStorage activitiesStorage;

   @override
   void initState() {
     super.initState();

     sessionsStorage = context.read<SessionsStorage>();
     activitiesStorage = context.read<ActivitiesStorage>();

     monthHandler = MonthHandler(sessionsStorage, activitiesStorage);
     monthController = StatsController<DateTime>(monthHandler);

     dayHandler = DayHandler(sessionsStorage, activitiesStorage);
     dayController = StatsController<DateTime>(dayHandler);

     weekHandler = WeekHandler(sessionsStorage, activitiesStorage);
     weekController = StatsController<DateTime>(weekHandler);
   }

   @override
   void dispose() {
     monthController.dispose();
     weekController.dispose();
     dayController.dispose();
     super.dispose();
   }

   @override
   Widget build(BuildContext context) {
     return TabBarView(children:
     <Widget>[
       MonthStatisticsScreen(monthController),
       WeekStatisticsScreen(weekController),
     ]
     );
   }

 }
