import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kura/src/models/family_medication.dart';
import 'package:kura/src/services/firestore_service.dart';
import 'package:kura/src/services/medication_service.dart';
import 'package:kura/src/services/medication_service_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'medication_service_test.mocks.dart';

@GenerateMocks([FirestoreService])
void main() {
  late MedicationService medicationService;
  late MockFirestoreService<Medication> mockFirestoreService;

  setUp(() {
    mockFirestoreService = MockFirestoreService<Medication>();
    medicationService = MedicationServiceImpl(mockFirestoreService);
  });

  final medication = Medication(
    id: '1',
    name: 'Aspirin',
    dosage: '100mg',
    expirationDate: DateTime.now(),
  );

  test('addMedication should add a medication to Firestore', () async {
    when(mockFirestoreService.create(any, any))
        .thenAnswer((_) async => Future.value());

    final addedMedication = await medicationService.addMedication(medication);

    expect(addedMedication.id, isNotNull);
  });

  test('getMedications should return a list of medications from Firestore', () async {
    when(mockFirestoreService.getListStream())
        .thenAnswer((_) => Stream.value([medication]));

    final medications = await medicationService.getMedications();

    expect(medications, [medication]);
  });

  test('updateMedication should update a medication in Firestore', () async {
    when(mockFirestoreService.update(any, any))
        .thenAnswer((_) async => Future.value());

    await medicationService.updateMedication(medication);

    verify(mockFirestoreService.update(medication.id!, medication.toJson()));
  });

  test('deleteMedication should delete a medication from Firestore', () async {
    when(mockFirestoreService.delete(any))
        .thenAnswer((_) async => Future.value());

    await medicationService.deleteMedication(medication.id!);

    verify(mockFirestoreService.delete(medication.id!));
  });
}
