import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/theme.dart';

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
    Color statusColor;

    Color getAvatarColor(String letter) {
      return kAvatarColors[letter.toUpperCase().codeUnitAt(0) %
          kAvatarColors.length];
    }

    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));

    expirationText = DateFormat('MM/yyyy').format(medication.expirationDate);
    if (medication.expirationDate.isBefore(now)) {
      expirationColor = theme.colorScheme.error;
      statusColor = theme.colorScheme.error;
    } else if (medication.expirationDate.isBefore(thirtyDaysFromNow)) {
      expirationColor = kWarningColor;
      statusColor = kWarningColor;
    } else {
      expirationColor = kSuccessColor;
      statusColor = kSuccessColor;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Icon(
                          Icons.medication,
                          size: 32,
                          color: statusColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              medication.name,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                            if (medication.reason != null &&
                                medication.reason!.isNotEmpty)
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
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: expirationColor,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      expirationText,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: expirationColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            if (medication.userIds != null && medication.userIds!.isNotEmpty)
              userList.when(
                data: (users) {
                  final medicationUsers = users
                      .where((user) => medication.userIds!.contains(user.id))
                      .toList();
                  return Row(
                    children: [
                      SizedBox(
                        width: medicationUsers.length * 22.0,
                        height: 22.0,
                        child: Stack(
                          children: medicationUsers.asMap().entries.map((
                            entry,
                          ) {
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
                                  child: Text(
                                    user.name[0].toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      if (medicationUsers.length == 1) const SizedBox(width: 4),
                      
                      Flexible(
                        child: Text(
                          medicationUsers.map((user) => user.name).join(', '),
                          style: theme.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox(),
                error: (error, stack) => const SizedBox(),
              ),
          ],
        ),
      ),
    );
  }
}
