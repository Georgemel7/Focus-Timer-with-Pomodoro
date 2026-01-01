import 'package:flutter/material.dart';

import '../controllers/activity_edit_controller.dart';
import '../models/activity.dart';
import '../models/weekday.dart';

class ActivityCreationScreen extends StatefulWidget {
  const ActivityCreationScreen(this.activity, {super.key});

  final Activity? activity;

  @override
  State<ActivityCreationScreen> createState() => _ActivityCreationScreenState();
}

class _ActivityCreationScreenState extends State<ActivityCreationScreen> {


  final List<Color> _colorOptions = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.deepOrange,
  ];
  late final ActivityEditController controller;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    controller = ActivityEditController(widget.activity);
    _textEditingController = TextEditingController(text: controller.label);
  }

  @override
  void dispose() {
    controller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.activity == null ? 'Create Activity' : 'Edit Activity'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              // Added bottom padding to avoid the button
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 120.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16),
                  TextField(
                    controller: _textEditingController,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      controller.setLabel(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Activity Name',
                      filled: true,
                      fillColor: Theme
                          .of(context)
                          .colorScheme
                          .surfaceContainer,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    'Color',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: _colorOptions.map((color) {
                      final isSelected = controller.seedColor == color;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            controller.seedColor = color;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : Theme
                                  .of(context)
                                  .colorScheme
                                  .outlineVariant,
                              width: isSelected ? 3.0 : 1.0,
                            ),
                          ),
                          padding: const EdgeInsets.all(3.0),
                          child: CircleAvatar(
                            backgroundColor: color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Active Days',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    children: List.generate(Weekday.values.length, (index) {
                      final day = Weekday.values[index];
                      return FilterChip(
                        label: Text(day.name.substring(0, 3).toUpperCase()),
                        selected: controller.activeDays.contains(day),
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              controller.activeDays.add(day);
                            } else {
                              controller.activeDays.remove(day);
                            }
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        'Time Goal',
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${controller.timeGoal.round()} min',
                        style: Theme
                            .of(context)
                            .textTheme
                            .bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: controller.timeGoal.toDouble(),
                    min: 15,
                    max: 180,
                    divisions: (180 - 15) ~/ 5,
                    onChanged: (double value) {
                      setState(() {
                        controller.timeGoal = value.toInt();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {controller.save(context);},
                child: const Text('Save Activity'),
              ),
            ),
          ),
        );
      });
  }
}
