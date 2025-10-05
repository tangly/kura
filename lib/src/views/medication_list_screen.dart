import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/add_edit_medication_screen.dart';
import 'package:kura/src/widgets/medication_card.dart';

class MedicationListScreen extends ConsumerWidget {
  const MedicationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicationList = ref.watch(medicationListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medications'),
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
                Text('Filter by:', style: theme.textTheme.bodyMedium),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                        foregroundColor: theme.colorScheme.primary,
                      ),
                      child: const Text('All'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Active'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Expired'),
                    ),
                  ],
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Medications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Family',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
