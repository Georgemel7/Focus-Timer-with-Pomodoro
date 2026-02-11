import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

class AppSettingsController extends ChangeNotifier {
  late AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

  static const String _breakKey  = 'break';
  static const String _focusKey = 'focus';

  get focusInterval => _settings.focusInterval;
  get breakInterval => _settings.breakInterval;

  final SharedPreferences prefs;

  AppSettingsController({required this.prefs}) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final focus = prefs.getInt(_focusKey) ?? _settings.focusInterval;
    final break_ = prefs.getInt(_breakKey) ?? _settings.breakInterval;

    _settings = AppSettings(
      focusInterval: focus,
      breakInterval: break_,
    );

    notifyListeners();
  }

  void setFocusInterval (int value) {
    _settings = _settings.copyWith(focusInterval: value);
    prefs.setInt(_focusKey, value);
    notifyListeners();
  }

  void setBreakInterval (int value) {
    _settings = _settings.copyWith(breakInterval: value);
    prefs.setInt(_breakKey, value);
    notifyListeners();
  }

}