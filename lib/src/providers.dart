import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kura/src/models/family_medication.dart';
import 'package:kura/src/models/app_user.dart';
import 'package:kura/src/services/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kura/src/services/app_user_service.dart';
import 'package:kura/src/services/family_service.dart';
import 'package:kura/src/services/auth_service.dart';
import 'package:kura/src/models/family_member.dart';
import 'package:kura/src/tools/tools.dart';

// Providers for services
final appUserServiceProvider = Provider<AppUserService>((ref) => AppUserService());
final familyServiceProvider = Provider<FamilyService>((ref) => FamilyService());
final notificationServiceProvider = Provider<NotificationService>((ref) =>
    NotificationService(notificationsPlugin: FlutterLocalNotificationsPlugin()));
final authServiceProvider = Provider<AuthService>((ref) {
  final appUserService = ref.watch(appUserServiceProvider);
  final familyService = ref.watch(familyServiceProvider);
  return AuthService(FirebaseAuth.instance, appUserService, familyService);
});

// Auth state
final authStateChangesProvider = StreamProvider<User?>(
    (ref) => ref.watch(authServiceProvider).authStateChanges);

// App user stream
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  if (authState.value != null) {
    final appUserService = ref.watch(appUserServiceProvider);
    return appUserService.getStream(authState.value!.uid);
  }
  return Stream.value(null);
});

// Family members stream
final familyMembersProvider = StreamProvider<List<FamilyMember>>((ref) {
  final familyService = ref.watch(familyServiceProvider);
  final currentUser = ref.watch(currentUserProvider);

  if (currentUser.value != null && currentUser.value!.families.isNotEmpty) {
    return familyService.getFamilyMembersStream(currentUser.value!.families.first);
  }
  return Stream.value([]);
});

// Medication filter
enum MedicationFilter { all, user }

class MedicationFilterNotifier extends Notifier<MedicationFilter> {
  @override
  MedicationFilter build() => MedicationFilter.all;
  void setFilter(MedicationFilter filter) => state = filter;
}
final medicationFilterProvider = NotifierProvider<MedicationFilterNotifier, MedicationFilter>(MedicationFilterNotifier.new);

class SelectedMemberNotifier extends Notifier<FamilyMember?> {
  @override
  FamilyMember? build() => null;
  void setMember(FamilyMember? member) => state = member;
}
final selectedMemberProvider = NotifierProvider<SelectedMemberNotifier, FamilyMember?>(SelectedMemberNotifier.new);

// Medication list stream
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

// Pending notifications provider
final pendingNotificationsProvider = FutureProvider<(List<FamilyMedication>, Map<int, List<PendingNotificationRequest>>)>((ref) async {
  final medications = await ref.watch(medicationListProvider.future);
  final notificationService = ref.watch(notificationServiceProvider);
  final pendingNotifications = await notificationService.getPendingNotifications();

  final groupedNotifications = <int, List<PendingNotificationRequest>>{};
  for (final notification in pendingNotifications) {
    final notificationBase = Tools.extractBaseFromNotificationId(notification.id);
    if (groupedNotifications.containsKey(notificationBase)) {
      groupedNotifications[notificationBase]!.add(notification);
    } else {
      groupedNotifications[notificationBase] = [notification];
    }
  }

  return (medications, groupedNotifications);
});

// Removed: userListProvider (not used in your logic)
// Removed: flutter_riverpod/legacy.dart import (not needed)
