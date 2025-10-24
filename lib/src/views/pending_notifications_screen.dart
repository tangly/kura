import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/tools/tools.dart';

class PendingNotificationsScreen extends ConsumerWidget {
  const PendingNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingNotifications = ref.watch(pendingNotificationsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Notifications'),
      ),
      body: pendingNotifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final medications = data.medications;
          final groupedNotifications = data.groupedNotifications;
          
          final medicationsWithNotifications = medications
              .where((medication){
                int id = Tools.extractBaseFromMedicationId(medication.id ?? '');
                return groupedNotifications.containsKey(id) &&
                    groupedNotifications[id]!.isNotEmpty;
              }).toList();

          if (medicationsWithNotifications.isEmpty) {
            return const Center(
              child: Text('No pending notifications.'),
            );
          }

          return ListView.builder(
            itemCount: medicationsWithNotifications.length,
            itemBuilder: (context, index) {
              final medication = medicationsWithNotifications[index]; 
              final int id = Tools.extractBaseFromMedicationId(medication.id ?? '');
              final notifications = groupedNotifications[id] ?? [];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(medication.name),
                  subtitle: Text('Expires on: ${medication.expirationDate.toLocal().toString().split(' ')[0]}'),
                  children: notifications.map((notification) {
                    // Suponiendo que notification tiene un campo scheduledDate de tipo DateTime
                    
                    final days = Tools.extractDaysFromNotificationId(notification.id);
                    final scheduledDate = medication.expirationDate.subtract(Duration(days: days));
                    String dateInfo = 'Reminder set for: ${DateFormat('dd/MM/yyyy').format(scheduledDate.toLocal())} ($days days)';
                    return Text(dateInfo, style: const TextStyle(fontSize: 14, color: Colors.grey));
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}