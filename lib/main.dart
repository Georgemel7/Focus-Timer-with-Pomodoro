import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:focus_timer/app_root.dart';
import 'package:provider/provider.dart';

import 'data/activities_storage.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ActivitiesStorage(),
    child: const MyApp(),
  ));
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
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,

        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: darkColorScheme,
        ),
        themeMode: ThemeMode.system,
        home: const AppRoot(),
      );
    });
  }
}
