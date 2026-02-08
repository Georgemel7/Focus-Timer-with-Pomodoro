import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:focus_timer/app_root.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

import 'controllers/app_settings_controller.dart';
import 'data/activities_storage.dart';
import 'data/sessions_storage.dart';
import 'hive_adapters/focus_state_adapter.dart';
import 'hive_adapters/weekday_adapter.dart';
import 'models/activity.dart';
import 'models/activity_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(ActivitySessionAdapter());
  Hive.registerAdapter(ColorAdapter());
  Hive.registerAdapter(WeekdayAdapter());
  Hive.registerAdapter(FocusStateAdapter());

  final activitiesBox = await Hive.openBox<Activity>('activities');

  final sessionsBox = await Hive.openBox<ActivitySession>('sessions');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ActivitiesStorage()),
        ChangeNotifierProvider(create: (context) => AppSettingsController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(seedColor: Colors.grey);
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: Colors.grey,
            brightness: Brightness.dark,
          );
        }
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          themeMode: ThemeMode.system,
          home: const AppRoot(),
        );
      },
    );
  }
}
