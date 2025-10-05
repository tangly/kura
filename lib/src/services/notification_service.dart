import 'package:kura/src/models/medication.dart';

abstract class NotificationService {
  Future<void> init();
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  });
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotificationsForMedication(int medicationId);
  Future<void> scheduleNotificationsForMedication(Medication medication);
}
