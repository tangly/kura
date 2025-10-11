import 'package:flutter/material.dart';
import 'package:kura/src/models/user.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<User> users;
  final List<int> selectedUserIds;

  const MultiSelectDialog({
    super.key,
    required this.users,
    required this.selectedUserIds,
  });

  @override
  State<MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late final List<int> _selectedUserIds;

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
          children: widget.users.map((user) {
            return CheckboxListTile(
              value: _selectedUserIds.contains(user.id),
              title: Text(user.name),
              onChanged: (isChecked) {
                setState(() {
                  if (isChecked!) {
                    _selectedUserIds.add(user.id!);
                  } else {
                    _selectedUserIds.remove(user.id!);
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
