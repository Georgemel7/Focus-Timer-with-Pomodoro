import 'package:flutter/material.dart';
import 'package:focus_timer/models/weekday.dart';
import 'package:provider/provider.dart';

import '../data/activities_storage.dart';
import '../widgets/activity_card.dart';
import 'activity_creation_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activitiesStorage = context.watch<ActivitiesStorage>();
    final brightness = Theme.of(context).brightness;
    final today = Weekday.values[DateTime.now().weekday - 1];
    final dueTodayActivities = activitiesStorage.getActivitiesByWeekday(today);
    final allActivities = activitiesStorage.getAllActivities();

    return Scaffold(
      body: TabBarView(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: dueTodayActivities.map((activity) {
              final colorScheme = ColorScheme.fromSeed(
                seedColor: activity.seedColor,
                brightness: brightness,
              );
              return ActivityCard(
                activity: activity,
                cardColorScheme: colorScheme,
              );
            }).toList(),
          ),
          ListView(
            padding: const EdgeInsets.all(20),
            children: allActivities.map((activity) {
              final colorScheme = ColorScheme.fromSeed(
                seedColor: activity.seedColor,
                brightness: brightness,
              );
              return ActivityCard(
                activity: activity,
                cardColorScheme: colorScheme,
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityCreationScreen(null),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
