import 'package:flutter/material.dart';

class DayContainer extends StatelessWidget {

  final int day;
  final double progress;

  const DayContainer({super.key, required this.day, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors:
            [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.outlineVariant],
            stops: [progress, progress],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Text(day.toString(),
          style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

      ),
    );
  }
}
