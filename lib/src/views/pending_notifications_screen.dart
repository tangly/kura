import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kura/src/providers.dart';

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
          final medications = data.$1;
          final groupedNotifications = data.$2;

          final medicationsWithNotifications = medications
              .where((medication) =>
                  groupedNotifications.containsKey(medication.id) &&
                  groupedNotifications[medication.id]!.isNotEmpty)
              .toList();

          if (medicationsWithNotifications.isEmpty) {
            return const Center(
              child: Text('No pending notifications.'),
            );
          }

          return ListView.builder(
            itemCount: medicationsWithNotifications.length,
            itemBuilder: (context, index) {
              final medication = medicationsWithNotifications[index];
              final notifications = groupedNotifications[medication.id]!;
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: Text(medication.name),
                  subtitle: Text('Expires on: ${medication.expirationDate.toLocal().toString().split(' ')[0]}'),
                  children: notifications.map((notification) {
                    return ListTile(
                      title: Text(notification.title ?? 'No title'),
                      subtitle: Text(notification.body ?? 'No body'),
                    );
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