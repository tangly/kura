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
                Text(l10n.filterBy, style: theme.textTheme.bodyMedium),
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ActionChip(
                          label: Text(l10n.all),
                          onPressed: () {
                            ref.read(medicationFilterProvider.notifier).state = MedicationFilter.all;
                          },
                          backgroundColor: filter == MedicationFilter.all
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : null,
                        ),
                        const SizedBox(width: 8),
                        userList.when(
                          data: (users) {
                            return PopupMenuButton<User?>(
                              onSelected: (user) {
                                ref.read(medicationFilterProvider.notifier).state = MedicationFilter.user;
                                ref.read(selectedUserProvider.notifier).state = user;
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem<User?>(
                                    value: null,
                                    child: Text(l10n.allUsers),
                                  ),
                                  ...users.map((user) {
                                    return PopupMenuItem<User?>(
                                      value: user,
                                      child: Text(user.name),
                                    );
                                  }),
                                ];
                              },
                              child: Builder(
                                builder: (context) {
                                  return ActionChip(
                                    label: Text(
                                      selectedUser?.name ?? l10n.user,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onPressed: () {
                                      final RenderBox button = context.findRenderObject() as RenderBox;
                                      final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                                      final RelativeRect position = RelativeRect.fromRect(
                                        Rect.fromPoints(
                                          button.localToGlobal(Offset.zero, ancestor: overlay),
                                          button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                                        ),
                                        Offset.zero & overlay.size,
                                      );
                                      showMenu<User?>(
                                        context: context,
                                        position: position,
                                        items: [
                                          PopupMenuItem<User?>(
                                            value: null,
                                            child: Text(l10n.allUsers),
                                          ),
                                          ...users.map((user) {
                                            return PopupMenuItem<User?>(
                                              value: user,
                                              child: Text(user.name),
                                            );
                                          }),
                                        ],
                                      ).then((user) {
                                        if (user != null) {
                                          ref.read(medicationFilterProvider.notifier).state = MedicationFilter.user;
                                          ref.read(selectedUserProvider.notifier).state = user;
                                        } else {
                                          ref.read(medicationFilterProvider.notifier).state = MedicationFilter.all;
                                          ref.read(selectedUserProvider.notifier).state = null;
                                        }
                                      });
                                    },
                                    backgroundColor: filter == MedicationFilter.user
                                        ? theme.colorScheme.primary.withOpacity(0.1)
                                        : null,
                                  );
                                },
                              ),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (error, stackTrace) => Text('Error: $error'),
                        ),
                        const SizedBox(width: 8),
                        ActionChip(
                          label: Text(l10n.expired),
                          onPressed: () {
                            ref.read(medicationFilterProvider.notifier).state = MedicationFilter.expired;
                          },
                          backgroundColor: filter == MedicationFilter.expired
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : null,
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
