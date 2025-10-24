import 'package:kura/src/models/family.dart';
import 'package:kura/src/services/firestore_service.dart';

class FamilyService extends FirestoreService<Family> {
  FamilyService()
      : super(
          collectionPath: 'families',
          fromJson: (data, documentId) => Family.fromJson({'id': documentId, ...data}),
        );
}
