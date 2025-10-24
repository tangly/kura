
import 'package:kura/src/models/family_medication.dart';
import 'package:kura/src/services/firestore_service.dart';

class FamilyMedicationService extends FirestoreService<FamilyMedication> {
  final String familyId;

  FamilyMedicationService({required this.familyId})
      : super(
          collectionPath: 'families/$familyId/medications',
          fromJson: (data, documentId) => FamilyMedication.fromJson({'id': documentId, ...data}, documentId),
        );
}
