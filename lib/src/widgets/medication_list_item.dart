import 'package:flutter/material.dart';
import 'package:kura/src/models/medication.dart';

class MedicationListItem extends StatelessWidget {
  final Medication medication;

  const MedicationListItem({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final difference = medication.expirationDate.difference(now).inDays;
    final months = (difference / 30).floor();

    Color? tileColor;
    String? semanticsLabel;
    if (difference < 0) {
      tileColor = Colors.red;
      semanticsLabel = 'Expired';
    } else if (difference <= 7) {
      tileColor = Colors.yellow;
      semanticsLabel = 'Expires in $difference days';
    }

    return Semantics(
      label: semanticsLabel,
      child: ListTile(
        tileColor: tileColor,
        title: Text(medication.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dosage: ${medication.dosage}'),
            if (medication.reason != null && medication.reason!.isNotEmpty)
              Text(
                'Reason: ${medication.reason}',
                softWrap: true,
              ),
          ],
        ),
        trailing: Text('Expires in: $months months'),
      ),
    );
  }
}
