import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/models/user.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/add_edit_medication_screen.dart';
import 'package:kura/src/views/family_member_list_screen.dart';
import 'package:kura/src/widgets/medication_card.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationList = ref.watch(medicationListProvider);
    final userList = ref.watch(userListProvider);
    final selectedUser = ref.watch(selectedUserProvider);
    final filter = ref.watch(medicationFilterProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.medications),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 32),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddEditMedicationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(medicationFilterProvider.notifier).state = MedicationFilter.all;
                          },
                          child: Chip(
                            label: Text(l10n.all, style: TextStyle(fontSize: 12, color: filter == MedicationFilter.all ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color)),
                            backgroundColor: filter == MedicationFilter.all ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: filter == MedicationFilter.all ? BorderSide(color: theme.colorScheme.primary, width: 0.5) : BorderSide(color: theme.dividerColor, width: 0.5),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        userList.when(
                          data: (users) {
                            return Row(
                              children: users.map((user) {
                                final isSelected = selectedUser == user && filter == MedicationFilter.user;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      ref.read(medicationFilterProvider.notifier).state = MedicationFilter.user;
                                      ref.read(selectedUserProvider.notifier).state = user;
                                    },
                                    child: Chip(
                                      label: Text(user.name, style: TextStyle(fontSize: 12, color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color)),
                                      backgroundColor: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: isSelected ? BorderSide(color: theme.colorScheme.primary, width: 0.5) : BorderSide(color: theme.dividerColor, width: 0.5),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) => Text('Error: $error'),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            ref.read(medicationFilterProvider.notifier).state = MedicationFilter.expired;
                          },
                          child: Chip(
                            label: Text(l10n.expired, style: TextStyle(fontSize: 12, color: filter == MedicationFilter.expired ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color)),
                            backgroundColor: filter == MedicationFilter.expired ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: filter == MedicationFilter.expired ? BorderSide(color: theme.colorScheme.primary, width: 0.5) : BorderSide(color: theme.dividerColor, width: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                            builder: (context) =>
                                AddEditMedicationScreen(medication: medication),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: MedicationCard(medication: medication),
                      ),
                    );
                  },
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.medication),
            label: l10n.medicationsBottomBar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.group),
            label: l10n.familyBottomBar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: l10n.remindersBottomBar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: l10n.settingsBottomBar,
          ),
        ],
        currentIndex: 0,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const FamilyMemberListScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}
