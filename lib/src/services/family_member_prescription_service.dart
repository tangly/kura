import 'package:kura/src/models/prescription.dart';
import 'package:kura/src/services/firestore_service.dart';

class FamilyMemberPrescriptionService extends FirestoreService<Prescription> {
  final String familyId;
  final String memberId;

  FamilyMemberPrescriptionService({required this.familyId, required this.memberId})
      : super(
          collectionPath: 'families/$familyId/members/$memberId/prescriptions',
          fromJson: (data, documentId) => Prescription.fromJson(data as dynamic, documentId),
        );
}
