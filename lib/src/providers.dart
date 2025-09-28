import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/services/medication_service.dart';
import 'package:kura/src/services/medication_service_impl.dart';
import 'package:kura/src/services/notification_service.dart';
import 'package:kura/src/services/notification_service_impl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final medicationServiceProvider = Provider<MedicationService>((ref) {
  return MedicationServiceImpl(hive: Hive);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationServiceImpl(
    notificationsPlugin: FlutterLocalNotificationsPlugin(),
  );
});

final medicationListProvider = FutureProvider<List<Medication>>((ref) async {
  final medicationService = ref.watch(medicationServiceProvider);
  await medicationService.init();
  return medicationService.getMedications();
});
