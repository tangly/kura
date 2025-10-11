import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/providers.dart';

class MedicationCard extends ConsumerWidget {
  final Medication medication;

  const MedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final userList = ref.watch(userListProvider);

    String expirationText;
    Color expirationColor;
    IconData statusIcon;
    Color statusColor;

    if (medication.expirationDate.isBefore(DateTime.now())) {
      expirationText = l10n.expiredOn + DateFormat('dd/MM/yyyy').format(medication.expirationDate);
      expirationColor = Colors.red;
      statusIcon = Icons.warning_amber_rounded;
      statusColor = Colors.red;
    } else {
      expirationText = l10n.expiresOn + DateFormat('dd/MM/yyyy').format(medication.expirationDate);
      expirationColor = Colors.green;
      statusIcon = Icons.check_circle_outline_rounded;
      statusColor = Colors.green;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.medication, size: 32, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(medication.name, style: theme.textTheme.titleLarge),
                  ],
                ),
                Icon(statusIcon, color: statusColor, size: 32),
              ],
            ),
            const SizedBox(height: 8),
            if (medication.dosage != null && medication.dosage!.isNotEmpty)
              Text(l10n.dosageCard + medication.dosage!, style: theme.textTheme.bodyMedium),
            if (medication.userIds != null && medication.userIds!.isNotEmpty)
              userList.when(
                data: (users) {
                  final medicationUsers = users.where((user) => medication.userIds!.contains(user.id)).toList();
                  return Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: medicationUsers.map((user) {
                      return Chip(
                        label: Text(user.name, style: TextStyle(fontSize: 12, color: theme.colorScheme.primary)),
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide.none,
                        ),
                      );
                    }).toList(),
                  );
                },
                loading: () => const SizedBox(),
                error: (error, stack) => const SizedBox(),
              ),
            if (medication.reason != null && medication.reason!.isNotEmpty)
              Text(medication.reason!, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(expirationText, style: theme.textTheme.bodyMedium?.copyWith(color: expirationColor)),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }
}