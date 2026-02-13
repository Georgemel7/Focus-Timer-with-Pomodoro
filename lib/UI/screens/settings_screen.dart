import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_settings_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _focusController;
  late final TextEditingController _breakController;

  @override
  void initState() {
    super.initState();
    final appSettings = context.read<AppSettingsController>();
    _focusController = TextEditingController(
      text: (appSettings.focusInterval ~/ 60).toString(),
    );
    _breakController = TextEditingController(
      text: (appSettings.breakInterval ~/ 60).toString(),
    );
  }

  @override
  void dispose() {
    _focusController.dispose();
    _breakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.surface],
                center: Alignment.bottomRight,
                radius: 0.8,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Focus interval (minutes)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _focusController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final v = int.tryParse(value);
                            if (v != null && v > 0) {
                              controller.setFocusInterval(v * 60);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          'Break interval (minutes)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _breakController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final v = int.tryParse(value);
                            if (v != null && v > 0) {
                              controller.setBreakInterval(v * 60);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
