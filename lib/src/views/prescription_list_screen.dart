import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kura/src/models/family_member.dart';
import 'package:kura/src/models/prescription.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/add_edit_prescription_screen.dart';

class PrescriptionListScreen extends ConsumerWidget {
  const PrescriptionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyMembers = ref.watch(familyMembersProvider);
    final selectedMember = ref.watch(selectedMemberProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Prescriptions'),
      ),
      body: Column(
        children: [
          familyMembers.when(
            data: (members) {
              return DropdownButton<FamilyMember>(
                value: selectedMember,
                onChanged: (member) {
                  ref.read(selectedMemberProvider.notifier).setMember(member);
                },
                items: members
                    .map((member) => DropdownMenuItem(
                          value: member,
                          child: Text(member.name),
                        ))
                    .toList(),
              );
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => const Text('Could not load members'),
          ),
          if (selectedMember != null)
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final prescriptionList = ref.watch(prescriptionListProvider(selectedMember.id));
                  return prescriptionList.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) =>
                        Center(child: Text('Error: $error')),
                    data: (prescriptions) {
                      if (prescriptions.isEmpty) {
                        return const Center(
                            child: Text('No prescriptions found.'));
                      }
                      return ListView.builder(
                        itemCount: prescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = prescriptions[index];
                          return ListTile(
                            title: Text(prescription.medicationName),
                            subtitle: Text(prescription.dosage),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddEditPrescriptionScreen(
                                    memberId: selectedMember.id,
                                    prescription: prescription,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: selectedMember != null ? FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditPrescriptionScreen(
                memberId: selectedMember.id,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ): null,
    );
  }
}
