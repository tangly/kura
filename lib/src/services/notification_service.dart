import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kura/src/models/medication.dart';

abstract class NotificationService {
  Future<void> init();
  Future<void> cancelAllNotificationsForMedication(int medicationId);
  Future<void> scheduleNotificationsForMedication(Medication medication);
  Future<List<PendingNotificationRequest>> getPendingNotifications();
}
