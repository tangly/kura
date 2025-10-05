import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kura/src/models/medication.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;

  const MedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final difference = medication.expirationDate.difference(now).inDays;

    String expirationText;
    Color expirationColor;
    IconData statusIcon;
    Color statusColor;

    if (difference < 0) {
      expirationText = 'Expires: ${DateFormat('MM/yyyy').format(medication.expirationDate)}';
      expirationColor = Colors.red;
      statusIcon = Icons.warning_amber_rounded;
      statusColor = Colors.red;
    } else {
      expirationText = 'Expires: ${DateFormat('MM/yyyy').format(medication.expirationDate)}';
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
            if (medication.user != null)
              Text('For: ${medication.user!.name}', style: theme.textTheme.bodyMedium),
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