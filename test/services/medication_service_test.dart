import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/services/medication_service.dart';
import 'package:kura/src/services/medication_service_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'medication_service_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  late MedicationService medicationService;
  late MockHiveInterface mockHive;
  late MockBox<Medication> mockBox;

  setUp(() {
    mockHive = MockHiveInterface();
    mockBox = MockBox<Medication>();
    medicationService = MedicationServiceImpl(hive: mockHive);
  });

  final medication = Medication(
    id: 1,
    name: 'Aspirin',
    dosage: '100mg',
    expirationDate: DateTime.now(),
  );

  test('init should open the medications box', () async {
    when(mockHive.openBox<Medication>(any)).thenAnswer((_) async => mockBox);

    await medicationService.init();

    verify(mockHive.openBox<Medication>('medications'));
  });

  test('addMedication should add a medication to the box', () async {
    when(mockHive.openBox<Medication>(any)).thenAnswer((_) async => mockBox);
    await medicationService.init();
    when(mockBox.add(any)).thenAnswer((_) async => 1);

    await medicationService.addMedication(medication);

    verify(mockBox.add(medication));
  });

  test(
    'getMedications should return a list of medications from the box',
    () async {
      when(mockHive.openBox<Medication>(any)).thenAnswer((_) async => mockBox);
      await medicationService.init();
      when(mockBox.values).thenReturn([medication]);

      final medications = await medicationService.getMedications();

      expect(medications, [medication]);
    },
  );

  test('updateMedication should update a medication in the box', () async {
    when(mockHive.openBox<Medication>(any)).thenAnswer((_) async => mockBox);
    await medicationService.init();
    when(mockBox.put(any, any)).thenAnswer((_) async => Future.value());

    await medicationService.updateMedication(medication);

    verify(mockBox.put(medication.id, medication));
  });

  test('deleteMedication should delete a medication from the box', () async {
    when(mockHive.openBox<Medication>(any)).thenAnswer((_) async => mockBox);
    await medicationService.init();
    when(mockBox.delete(any)).thenAnswer((_) async => Future.value());

    await medicationService.deleteMedication(medication.id!);

    verify(mockBox.delete(medication.id));
  });
}
