import 'package:kura/src/models/family.dart';
import 'package:kura/src/models/family_medication.dart';
import 'package:kura/src/models/family_member.dart';
import 'package:kura/src/services/firestore_service.dart';

class FamilyService extends FirestoreService<Family> {
  FamilyService()
      : super(
          collectionPath: 'families',
          fromJson: (data, documentId) => Family.fromJson({'id': documentId, ...data}),
        );

  // Methods for family members subcollection
  FirestoreService<FamilyMember> _membersService(String familyId) {
    return FirestoreService<FamilyMember>(
      collectionPath: 'families/$familyId/members',
      fromJson: (data, documentId) => FamilyMember.fromJson({'id': documentId, ...data}, documentId),
    );
  }

  // Methods for family members subcollection
  FirestoreService<FamilyMedication> _medicationsService(String familyId) {
    return FirestoreService<FamilyMedication>(
      collectionPath: 'families/$familyId/medications',
      fromJson: (data, documentId) => FamilyMedication.fromJson({'id': documentId, ...data}, documentId),
    );
  }

  Future<void> addFamilyMember(String familyId, FamilyMember member) async {
    await _membersService(familyId).create(member);
  }

  Future<FamilyMember?> getFamilyMember(String familyId, String memberId) {
    return _membersService(familyId).get(memberId);
  }

  Stream<List<FamilyMember>> getFamilyMembersStream(String familyId) {
    return _membersService(familyId).getListStream();
  }

  Future<void> updateFamilyMember(String familyId, String memberId, Map<String, dynamic> data) {
    return _membersService(familyId).update(memberId, data);
  }

  Future<void> deleteFamilyMember(String familyId, String memberId) {
    return _membersService(familyId).delete(memberId);
  }

  Future<String> addFamilyMedication(String familyId, FamilyMedication medication) async {
    return await _medicationsService(familyId).create(medication);

  }

  Future<FamilyMedication?> getFamilyMedication(String familyId, String medicationId) {
    return _medicationsService(familyId).get(medicationId);
  }
  Stream<List<FamilyMedication>> getFamilyMedicationsStream(String familyId) {
    return _medicationsService(familyId).getListStream();
  }
  Future<void> updateFamilyMedication(String familyId, String medicationId, Map<String, dynamic > data) {
    return _medicationsService(familyId).update(medicationId, data);
  }
  Future<void> deleteFamilyMedication(String familyId, String medicationId) {
    return _medicationsService(familyId).delete(medicationId);
  }
}
