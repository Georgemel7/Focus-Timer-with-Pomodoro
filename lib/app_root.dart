import 'package:flutter/material.dart';
import 'package:focus_timer/screens/home_screen.dart';
import 'package:focus_timer/screens/statistics_screen.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    const StatisticsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget? appBar;
    if (_selectedIndex == 0) {
      appBar = AppBar(
        bottom: const TabBar(tabs: <Tab>[
          Tab(text: 'Due Today'),
          Tab(text: 'All'),
        ]),
        title: const Text(
          'Foсus Timer',)
      );
    } else {
      appBar = AppBar(
        title: const Text('Statistics'),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: appBar,
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: NavigationBar(
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Statistics',
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
        ),
      ),
    );
  }
}
