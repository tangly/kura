import 'package:flutter/material.dart';
import 'package:kura/src/models/family_member.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<FamilyMember> members;
  final List<String> selectedUserIds;

  const MultiSelectDialog({
    super.key,
    required this.members,
    required this.selectedUserIds,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late final List<String> _selectedUserIds;

  @override
  void initState() {
    super.initState();
    _selectedUserIds = widget.selectedUserIds;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Users'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.members.map((member) {
            return CheckboxListTile(
              value: _selectedUserIds.contains(member.id),
              title: Text(member.name),
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked!) {
                    _selectedUserIds.add(member.id);
                  } else {
                    _selectedUserIds.remove(member.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_selectedUserIds),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
