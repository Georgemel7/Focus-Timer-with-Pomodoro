import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  int _currentId = 0;
  int nextId() => _currentId++;

  static const String focusChannel = 'timer_focus_channel';
  static const String breakChannel = 'timer_break_channel';

  Future<void> init() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            focusChannel,
            'Focus Timer',
            importance: Importance.max,
            sound: RawResourceAndroidNotificationSound('focus_end_sound'),
          ),
        );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            breakChannel,
            'Focus Timer',
            importance: Importance.max,
            sound: RawResourceAndroidNotificationSound('break_end_sound'),
          ),
        );
  }

  Future<void> scheduleFocusEndNotification(tz.TZDateTime time) async {
    try {await _plugin.zonedSchedule(
      id: nextId(),
      title: 'Focus Timer',
      body: 'The focus interval is over!',
      scheduledDate: time,
      androidScheduleMode: AndroidScheduleMode.inexact,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          focusChannel,
          'Focus Timer',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );} catch (e) {
      print(e);
    };
  }

  Future<void> scheduleBreakEndNotification(tz.TZDateTime time) async {
    try {await _plugin.zonedSchedule(
      scheduledDate: time,
      androidScheduleMode: AndroidScheduleMode.inexact,
      id: nextId(),
      title: 'Focus Timer',
      body: 'The break is over!',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          breakChannel,
          'Focus Timer',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );} catch (e) {
      print(e);
    };
  }

  Future<void> cancelNotifications() async {
    await _plugin.cancelAll();
  }
}
