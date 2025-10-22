import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kura/src/models/family_medication.dart';

abstract class NotificationService {
  Future<void> init();
  Future<void> cancelAllNotificationsForMedication(String medicationId);
  Future<void> scheduleNotificationsForMedication(FamilyMedication medication);
  Future<List<PendingNotificationRequest>> getPendingNotifications();
}
