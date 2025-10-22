import 'package:kura/src/models/family_medication.dart';
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

  Future<void> _scheduleNotification({
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
          'kura_channel_id',
          'kura_channel_name',
          channelDescription: 'Medication expiration notifications',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> _cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  @override
  Future<void> cancelAllNotificationsForMedication(String medicationId) async {
    final notificationDays = [30, 15, 7, 3, 1];
    for (final days in notificationDays) {
      await _cancelNotification(_generateNotificationId(medicationId, days));
    }
  }

  @override
  Future<void> scheduleNotificationsForMedication(FamilyMedication medication) async {
    await cancelAllNotificationsForMedication(medication.id!);
    final notificationDays = [30, 15, 7, 3, 1];
    for (final days in notificationDays) {
      final scheduledDate = medication.expirationDate.subtract(Duration(days: days));
      if (scheduledDate.isAfter(DateTime.now())) {
        await _scheduleNotification(
          id: _generateNotificationId(medication.id!, days),
          title: 'Medication Expiration',
          body: '${medication.name} will expire in $days days.',
          scheduledDate: scheduledDate,
        );
      }
    }
  }

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() {
    return notificationsPlugin.pendingNotificationRequests();
  }

  int _generateNotificationId(String medicationId, int daysBefore) {
    final intId = int.tryParse(medicationId) ?? medicationId.hashCode;
    return intId + daysBefore;
  }
}
