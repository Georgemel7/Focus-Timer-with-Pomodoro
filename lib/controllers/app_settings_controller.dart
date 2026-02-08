import 'package:flutter/cupertino.dart';

import '../models/app_settings.dart';

class AppSettingsController extends ChangeNotifier {
  late AppSettings _settings = AppSettings();

  AppSettings get settings => _settings;

  get focusInterval => _settings.focusInterval;
  get breakInterval => _settings.breakInterval;


  void setFocusInterval (int value) {
    _settings = _settings.copyWith(focusInterval: value);
    notifyListeners();
  }

  void setBreakInterval (int value) {
    _settings = _settings.copyWith(breakInterval: value);
    notifyListeners();
  }

}