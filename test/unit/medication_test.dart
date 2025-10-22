import 'package:flutter_test/flutter_test.dart';
import 'package:kura/src/models/family_medication.dart';

void main() {
  group('Medication', () {
    test('can be instantiated', () {
      final medication = Medication(
        id: '1',
        name: 'Aspirin',
        dosage: '100mg',
        expirationDate: DateTime.now(),
        familyId: 'family1',
      );
      expect(medication, isA<Medication>());
      expect(medication.id, '1');
    });

    test('supports value equality', () {
      final date = DateTime.now();
      final medication1 = Medication(
        id: '1',
        name: 'Aspirin',
        dosage: '100mg',
        expirationDate: date,
        familyId: 'family1',
      );
      final medication2 = Medication(
        id: '1',
        name: 'Aspirin',
        dosage: '100mg',
        expirationDate: date,
        familyId: 'family1',
      );
      expect(medication1, equals(medication2));
    });

    test('copyWith creates a new instance with updated values', () {
      final date = DateTime.now();
      final medication = Medication(
        id: '1',
        name: 'Aspirin',
        dosage: '100mg',
        expirationDate: date,
        familyId: 'family1',
      );

      final updatedMedication = medication.copyWith(name: 'Ibuprofen', familyId: 'family2');

      expect(updatedMedication.name, 'Ibuprofen');
      expect(updatedMedication.id, medication.id);
      expect(updatedMedication.dosage, medication.dosage);
      expect(updatedMedication.expirationDate, medication.expirationDate);
      expect(updatedMedication.familyId, 'family2');
    });
  });
}
