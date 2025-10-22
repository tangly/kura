import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:kura/src/models/family_medication.dart';
import 'package:kura/src/models/app_user.dart';
import 'package:kura/src/services/notification_service.dart';
import 'package:kura/src/services/notification_service_impl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kura/src/services/app_user_service.dart';
import 'package:kura/src/services/family_service.dart';
import 'package:kura/src/services/auth_service.dart';
import 'package:kura/src/models/family_member.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final appUserService = ref.watch(appUserServiceProvider);
  final familyService = ref.watch(familyServiceProvider);
  return AuthService(FirebaseAuth.instance, appUserService, familyService);
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

enum MedicationFilter { all, user }

final medicationFilterProvider = StateProvider<MedicationFilter>((ref) => MedicationFilter.all);

final appUserServiceProvider = Provider<AppUserService>((ref) {
  return AppUserService();
});

final familyServiceProvider = Provider<FamilyService>((ref) {
  return FamilyService();
});

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationServiceImpl(
    notificationsPlugin: FlutterLocalNotificationsPlugin(),
  );
});

final selectedMemberProvider = StateProvider<FamilyMember?>((ref) => null);

final userListProvider = StreamProvider<List<AppUser>>((ref) {
  final appUserService = ref.watch(appUserServiceProvider);
  return appUserService.getListStream();
});

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  if (authState.value != null) {
    final appUserService = ref.watch(appUserServiceProvider);
    return appUserService.getStream(authState.value!.uid);
  }
  return Stream.value(null);
});

final familyMembersProvider = StreamProvider<List<FamilyMember>>((ref) {
  final familyService = ref.watch(familyServiceProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser.value != null && currentUser.value!.families.isNotEmpty) {
    return familyService.getFamilyMembersStream(currentUser.value!.families.first);
  }

  return Stream.value([]);
});

final medicationListProvider = StreamProvider<List<FamilyMedication>>((ref) {
  final familyService = ref.watch(familyServiceProvider);
  final filter = ref.watch(medicationFilterProvider);
  final selectedMember = ref.watch(selectedMemberProvider);
  final currentUser = ref.watch(currentUserProvider).value;
  final familyId = (currentUser != null && currentUser.families.isNotEmpty)
      ? currentUser.families.first
      : '';

  return familyService.getFamilyMedicationsStream(familyId).map((medications) {
    medications.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

    switch (filter) {
      case MedicationFilter.all:
        return medications;
      case MedicationFilter.user:
        if (selectedMember == null) {
          return medications;
        } else {
          return medications
              .where((medication) => medication.members != null && medication.members!.contains(selectedMember.id))
              .toList();
        }
    }
  });
});

final pendingNotificationsProvider = FutureProvider<(List<FamilyMedication>, Map<int, List<PendingNotificationRequest>>)>((ref) async {
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
