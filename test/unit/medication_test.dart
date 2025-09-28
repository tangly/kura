import 'package:flutter_test/flutter_test.dart';
import 'package:kura/src/models/medication.dart';

void main() {
  group('Medication', () {
    test('can be instantiated', () {
      final medication = Medication(
        id: 1,
        name: 'Aspirin',
        dosage: '100mg',
        expirationDate: DateTime.now(),
      );
      expect(medication, isA<Medication>());
    });

    test('supports value equality', () {
      final date = DateTime.now();
      final medication1 = Medication(
        id: 1,
        name: 'Aspirin',
        dosage: '100mg',
        expirationDate: date,
      );
      final medication2 = Medication(
        id: 1,
        name: 'Aspirin',
        dosage: '100mg',
        expirationDate: date,
      );
      expect(medication1, equals(medication2));
    });

    test('copyWith creates a new instance with updated values', () {
      final date = DateTime.now();
      final medication = Medication(
        id: 1,
        name: 'Aspirin',
        dosage: '100mg',
        expirationDate: date,
      );

      final updatedMedication = medication.copyWith(name: 'Ibuprofen');

      expect(updatedMedication.name, 'Ibuprofen');
      expect(updatedMedication.id, medication.id);
      expect(updatedMedication.dosage, medication.dosage);
      expect(updatedMedication.expirationDate, medication.expirationDate);
    });
  });
}
