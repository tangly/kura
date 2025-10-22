import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/add_edit_medication_screen.dart';
import 'package:kura/src/widgets/medication_card.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  final medicationList = ref.watch(medicationListProvider);
  final userList = ref.watch(familyMembersProvider);
  final selectedMember = ref.watch(selectedMemberProvider);
  final filter = ref.watch(medicationFilterProvider);
  final theme = Theme.of(context);
  final l10n = AppLocalizations.of(context)!;
  final currentUser = ref.watch(currentUserProvider).value;
  final familyId = (currentUser != null && currentUser.families.isNotEmpty)
    ? currentUser.families.first
    : '';

  return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          l10n.medications,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 32),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditMedicationScreen(familyId: familyId),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 0.0,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          ref.read(medicationFilterProvider.notifier).state =
                              MedicationFilter.all;
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: filter == MedicationFilter.all
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          l10n.all,
                          style: TextStyle(
                            fontSize: 12,
                            color: filter == MedicationFilter.all
                                ? Colors.white
                                : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                      userList.when(
                        data: (users) {
                          return Row(
                            children: users.map((user) {
                              final isSelected = selectedMember == user &&
                                  filter == MedicationFilter.user;
                              return TextButton(
                                onPressed: () {
                                  ref
                                      .read(
                                        medicationFilterProvider.notifier,
                                      )
                                      .state = MedicationFilter.user;
                                  ref
                                      .read(
                                        selectedMemberProvider.notifier,
                                      )
                                      .state = user;
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  user.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.white
                                        : theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const SizedBox(),
                        error: (error, stackTrace) => const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: medicationList.when(
                data: (medications) => RefreshIndicator(
                  onRefresh: () => ref.refresh(medicationListProvider.future),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: medications.length,
                    itemBuilder: (context, index) {
                      final medication = medications[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddEditMedicationScreen(
                                medication: medication,
                                familyId: familyId,
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                          ),
                          child: MedicationCard(medication: medication),
                        ),
                      );
                    },
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
              ),
            ),
          ],
      ),
    );
  }
}
