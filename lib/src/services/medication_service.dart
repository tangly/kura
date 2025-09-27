import 'package:hive/hive.dart';
import 'package:kura/src/models/medication.dart';

class MedicationService {
  final HiveInterface hive;

  MedicationService({required this.hive});

  Future<void> addMedication(Medication medication) async {
    final box = await hive.openBox('medications');
    await box.add(medication);
  }

  Future<List<Medication>> getMedications() async {
    final box = await hive.openBox('medications');
    return box.values.toList().cast<Medication>();
  }

  Future<void> updateMedication(int index, Medication medication) async {
    final box = await hive.openBox('medications');
    await box.putAt(index, medication);
  }

  Future<void> deleteMedication(int index) async {
    final box = await hive.openBox('medications');
    await box.deleteAt(index);
  }
}
