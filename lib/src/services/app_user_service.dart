import 'package:kura/src/models/app_user.dart';
import 'package:kura/src/services/firestore_service.dart';

class AppUserService extends FirestoreService<AppUser> {
  AppUserService()
      : super(
          collectionPath: 'users',
          fromJson: (data, documentId) => AppUser.fromJson(data, documentId),
        );

  // You can add user-specific methods here in the future
}