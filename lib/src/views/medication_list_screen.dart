import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/models/user.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/add_edit_medication_screen.dart';
import 'package:kura/src/widgets/medication_list_item.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationList = ref.watch(medicationListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Medications')),
      body: medicationList.when(
        data: (medications) {
          final groupedMedications = <User?, List<Medication>>{};
          for (final medication in medications) {
            (groupedMedications[medication.user] ??= []).add(medication);
          }

          final userGroups = groupedMedications.keys.toList()
            ..sort((a, b) => (a?.name ?? '').compareTo(b?.name ?? ''));

          return RefreshIndicator(
            onRefresh: () => ref.refresh(medicationListProvider.future),
            child: ListView.builder(
              itemCount: userGroups.length,
              itemBuilder: (context, index) {
                final user = userGroups[index];
                final userMedications = groupedMedications[user]!;

                return ExpansionTile(
                  title: Text(user?.name ?? 'For the whole family'),
                  initiallyExpanded: true,
                  children: userMedications
                      .map((medication) => InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddEditMedicationScreen(medication: medication),
                                ),
                              );
                            },
                            child: MedicationListItem(medication: medication),
                          ))
                      .toList(),
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditMedicationScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
