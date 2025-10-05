import 'package:kura/src/models/medication.dart';
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
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    await notificationsPlugin.initialize(initializationSettings);

    final androidImplementation =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

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

  @override
  Future<void> scheduleNotificationsForMedication(Medication medication) async {
    await cancelAllNotificationsForMedication(medication.id!);
    final notificationDays = [30, 15, 7, 3, 1];
    for (final days in notificationDays) {
      final scheduledDate = medication.expirationDate.subtract(Duration(days: days));
      if (scheduledDate.isAfter(DateTime.now())) {
        await scheduleNotification(
          id: medication.id! * 100 + days,
          title: 'Medication Expiration',
          body: '${medication.name} will expire in $days days.',
          scheduledDate: scheduledDate,
        );
      }
    }
  }
}
