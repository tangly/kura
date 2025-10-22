import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kura/src/models/app_user.dart';
import 'package:kura/src/models/family.dart';
import 'package:kura/src/services/app_user_service.dart';
import 'package:kura/src/services/family_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  final AppUserService appUserService;
  final FamilyService familyService;

  AuthService(this.firebaseAuth, this.appUserService, this.familyService);

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await firebaseAuth.signInAnonymously();
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        return null;
      }
      AppUser? appUser = await appUserService.get(firebaseUser.uid);
      if (appUser == null) {
        // Create new Family first
        final newFamily = Family(
          id: '', // Firestore will generate this
          name: 'My Family',
          createdAt: Timestamp.now(),
          createdBy: firebaseUser.uid,
          admins: [firebaseUser.uid],
        );
        final familyId = await familyService.create(newFamily);
        // Create new AppUser with familyId
        appUser = AppUser(
          id: firebaseUser.uid,
          name: 'Anonymous User',
          createdAt: Timestamp.now(),
          families: [familyId],
        );
        await appUserService.create(appUser, firebaseUser.uid);
      }
      return firebaseUser;
    } catch (e, stack) {
      print('Failed to sign in anonymously: $e\n$stack');
      return null;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}