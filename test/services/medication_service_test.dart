import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/services/medication_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'medication_service_test.mocks.dart';

@GenerateMocks([HiveInterface, Box])
void main() {
  group('MedicationService', () {
    late MedicationService medicationService;
    late MockHiveInterface mockHiveInterface;
    late MockBox mockBox;

    setUp(() {
      mockHiveInterface = MockHiveInterface();
      mockBox = MockBox();
      medicationService = MedicationService(hive: mockHiveInterface);
    });

    test('addMedication', () async {
      when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
      when(mockBox.add(any)).thenAnswer((_) async => 0);

      await medicationService.addMedication(
        Medication(
          name: 'test',
          user: 'test',
          reason: 'test',
          expirationDate: DateTime.now(),
        ),
      );

      verify(mockBox.add(any)).called(1);
    });

    test('getMedications', () async {
      when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
      when(mockBox.values).thenReturn([]);

      final result = await medicationService.getMedications();

      expect(result, []);
    });

    test('updateMedication', () async {
      when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
      when(mockBox.putAt(any, any)).thenAnswer((_) async => {});

      await medicationService.updateMedication(
        0,
        Medication(
          name: 'test',
          user: 'test',
          reason: 'test',
          expirationDate: DateTime.now(),
        ),
      );

      verify(mockBox.putAt(any, any)).called(1);
    });

    test('deleteMedication', () async {
      when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockBox);
      when(mockBox.deleteAt(any)).thenAnswer((_) async => {});

      await medicationService.deleteMedication(0);

      verify(mockBox.deleteAt(any)).called(1);
    });
  });
}
