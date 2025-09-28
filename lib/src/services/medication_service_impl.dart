import 'package:hive/hive.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/services/medication_service.dart';

class MedicationServiceImpl extends MedicationService {
  final HiveInterface hive;
  late Box<Medication> _medicationsBox;

  MedicationServiceImpl({required this.hive});

  @override
  Future<void> init() async {
    _medicationsBox = await hive.openBox<Medication>('medications');
  }

  @override
  Future<Medication> addMedication(Medication medication) async {
    final id = await _medicationsBox.add(medication);
    final newMedication = medication.copyWith(id: id);
    await _medicationsBox.put(id, newMedication);
    return newMedication;
  }

  @override
  Future<List<Medication>> getMedications() async {
    return _medicationsBox.values.toList();
  }

  @override
  Future<void> updateMedication(Medication medication) async {
    await _medicationsBox.put(medication.id, medication);
  }

  @override
  Future<void> deleteMedication(int id) async {
    await _medicationsBox.delete(id);
  }
}
