import 'package:flutter/material.dart';

class DayContainer extends StatelessWidget {

  final int day;
  final double progress;

  const DayContainer({super.key, required this.day, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 10, 10, 0),
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.outlineVariant],
            stops: [progress, progress],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: progress > 0.5 
                      ? colorScheme.onPrimary 
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }
}
