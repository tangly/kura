import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import './models/medication.dart';
import './services/medication_service.dart';

final medicationServiceProvider = Provider(
  (ref) => MedicationService(hive: Hive),
);

final medicationListProvider = FutureProvider<List<Medication>>((ref) {
  final medicationService = ref.watch(medicationServiceProvider);
  return medicationService.getMedications();
});
