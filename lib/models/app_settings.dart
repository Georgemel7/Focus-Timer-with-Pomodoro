
class AppSettings {
  final int focusInterval; // seconds
  final int breakInterval; // seconds

  const AppSettings({
    this.focusInterval = 25 * 60,
    this.breakInterval = 5 * 60,
  });

  AppSettings copyWith({
    int? focusInterval,
    int? breakInterval,
  }) {
    return AppSettings(
      focusInterval: focusInterval ?? this.focusInterval,
      breakInterval: breakInterval ?? this.breakInterval,
    );
  }
}
