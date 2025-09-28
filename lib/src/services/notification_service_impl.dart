import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kura/src/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServiceImpl extends NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  NotificationServiceImpl({required this.notificationsPlugin});

  @override
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    await notificationsPlugin.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  @override
  Future<void> cancelAllNotificationsForMedication(int medicationId) async {
    final notificationDays = [30, 15, 7, 3, 1];
    for (final days in notificationDays) {
      await cancelNotification(medicationId * 100 + days);
    }
  }
}
