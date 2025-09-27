import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/medication.dart';
import '../providers.dart';
import './add_edit_medication_screen.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationList = ref.watch(medicationListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Manager'),
      ),
      body: medicationList.when(
        data: (medications) {
          if (medications.isEmpty) {
            return const Center(
              child: Text('No medications found'),
            );
          }
          final groupedMedications = groupBy(medications, (Medication m) => m.user);

          return Semantics(
            label: 'List of medications',
            child: ListView.builder(
              itemCount: groupedMedications.length,
              itemBuilder: (context, index) {
                final user = groupedMedications.keys.elementAt(index);
                final userMedications = groupedMedications[user]!;
                userMedications.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userMedications.length,
                      itemBuilder: (context, index) {
                        final medication = userMedications[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddEditMedicationScreen(medication: medication),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(medication.name),
                            subtitle: Text('Reason: ${medication.reason}\nExpires: ${DateFormat.yMd().format(medication.expirationDate)}'),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditMedicationScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
