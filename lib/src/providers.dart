import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive/hive.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/models/user.dart';
import 'package:kura/src/services/medication_service.dart';
import 'package:kura/src/services/medication_service_impl.dart';
import 'package:kura/src/services/notification_service.dart';
import 'package:kura/src/services/notification_service_impl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kura/src/services/user_service.dart';
import 'package:kura/src/services/user_service_impl.dart';

enum MedicationFilter { all, user }

final medicationFilterProvider = StateProvider<MedicationFilter>((ref) => MedicationFilter.all);

final medicationServiceProvider = Provider<MedicationService>((ref) {
  return MedicationServiceImpl(hive: Hive);
});

final userServiceProvider = Provider<UserService>((ref) {
  return UserServiceImpl(hive: Hive);
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationServiceImpl(
    notificationsPlugin: FlutterLocalNotificationsPlugin(),
  );
});

final selectedUserProvider = StateProvider<User?>((ref) => null);

final userListProvider = FutureProvider<List<User>>((ref) async {
  final userService = ref.watch(userServiceProvider);
  await userService.init();
  return userService.getUsers();
});

final medicationListProvider = FutureProvider<List<Medication>>((ref) async {
  final medicationService = ref.watch(medicationServiceProvider);
  await medicationService.init();
  final filter = ref.watch(medicationFilterProvider);
  final selectedUser = ref.watch(selectedUserProvider);
  final medications = await medicationService.getMedications();

  medications.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

  switch (filter) {
    case MedicationFilter.all:
      return medications;
    case MedicationFilter.user:
      if (selectedUser == null) {
        return medications;
      } else {
        return medications
            .where((medication) => medication.userIds!.contains(selectedUser.id))
            .toList();
      }
  }
});

final pendingNotificationsProvider = FutureProvider<(List<Medication>, Map<int, List<PendingNotificationRequest>>)>((ref) async {
  final medications = await ref.watch(medicationListProvider.future);
  final notificationService = ref.watch(notificationServiceProvider);
  final pendingNotifications = await notificationService.getPendingNotifications();

  final groupedNotifications = <int, List<PendingNotificationRequest>>{};
  for (final notification in pendingNotifications) {
    final medicationId = notification.id ~/ 100;
    if (groupedNotifications.containsKey(medicationId)) {
      groupedNotifications[medicationId]!.add(notification);
    } else {
      groupedNotifications[medicationId] = [notification];
    }
  }

  return (medications, groupedNotifications);
});
