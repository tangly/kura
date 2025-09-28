import 'package:kura/src/models/medication.dart';

abstract class MedicationService {
  Future<void> init();
  Future<Medication> addMedication(Medication medication);
  Future<List<Medication>> getMedications();
  Future<void> updateMedication(Medication medication);
  Future<void> deleteMedication(int id);
}
