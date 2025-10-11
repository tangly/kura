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

    final List<Color> avatarColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.amber,
      Colors.teal,
      Colors.cyan,
      Colors.indigo,
      Colors.lime,
      Colors.lightBlue,
    ];

    Color getAvatarColor(String letter) {
      return avatarColors[letter.toUpperCase().codeUnitAt(0) % avatarColors.length];
    }

    if (medication.expirationDate.isBefore(DateTime.now())) {
      expirationText = l10n.expiredOn + DateFormat('dd/MM/yyyy').format(medication.expirationDate);
      expirationColor = theme.colorScheme.error;
      statusIcon = Icons.warning_amber_rounded;
      statusColor = theme.colorScheme.error;
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
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(Icons.medication, size: 32, color: statusColor),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medication.name,
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            if (medication.reason != null && medication.reason!.isNotEmpty)
                              Text(
                                medication.reason!,
                                style: theme.textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(statusIcon, color: statusColor, size: 32),
              ],
            ),
            const SizedBox(height: 16),
            if (medication.dosage != null && medication.dosage!.isNotEmpty)
              Text(l10n.dosageCard + medication.dosage!, style: theme.textTheme.bodySmall),
            if (medication.dosage != null && medication.dosage!.isNotEmpty)
              const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: (medication.userIds != null && medication.userIds!.isNotEmpty)
                      ? userList.when(
                          data: (users) {
                            final medicationUsers = users.where((user) => medication.userIds!.contains(user.id)).toList();
                            return Row(
                              children: [
                                SizedBox(
                                  width: medicationUsers.length * 24.0,
                                  height: 24.0,
                                  child: Stack(
                                    children: medicationUsers.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final user = entry.value;
                                      return Positioned(
                                        left: index * 18.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 10,
                                            backgroundColor: getAvatarColor(user.name[0]),
                                            child: Text(user.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    medicationUsers.map((user) => user.name).join(', '),
                                    style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => const SizedBox(),
                          error: (error, stack) => const SizedBox(),
                        )
                      : const Spacer(),
                ),
                Text(expirationText, style: theme.textTheme.bodySmall?.copyWith(color: expirationColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}