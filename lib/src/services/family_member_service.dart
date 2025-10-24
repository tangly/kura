
import 'package:kura/src/models/family_member.dart';
import 'package:kura/src/services/firestore_service.dart';

class FamilyMemberService extends FirestoreService<FamilyMember> {
  final String familyId;

  FamilyMemberService({required this.familyId})
      : super(
          collectionPath: 'families/$familyId/members',
          fromJson: (data, documentId) => FamilyMember.fromJson({'id': documentId, ...data}, documentId),
        );
}
