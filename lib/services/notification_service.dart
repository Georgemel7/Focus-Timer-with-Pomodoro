import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  int currentFocusId = 0;
  int currentBreakId = 0;

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

  Future<void> playFocusEnd() async {
    await _plugin.show(
      id: currentFocusId++,
      title: 'Focus Timer',
      body: 'The focus interval is over!',
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          focusChannel,
          'Focus Timer',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> playBreakEnd() async {
    await _plugin.show(
      id: currentBreakId++,
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
    );
  }
}
