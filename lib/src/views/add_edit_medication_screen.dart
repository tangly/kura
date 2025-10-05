import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/models/user.dart';
import 'package:kura/src/providers.dart';

class AddEditMedicationScreen extends ConsumerStatefulWidget {
  final Medication? medication;

  const AddEditMedicationScreen({super.key, this.medication});

  @override
  ConsumerState<AddEditMedicationScreen> createState() =>
      _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState
    extends ConsumerState<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dosageController;
  late final TextEditingController _reasonController;
  late final TextEditingController _expirationDateController;
  late DateTime _expirationDate;
  Medication? _medication;
  User? _selectedUser;

  final _users = [
    const User(id: 1, name: 'John'),
    const User(id: 2, name: 'Jane'),
  ];

  @override
  void initState() {
    super.initState();
    _medication = widget.medication;
    _nameController = TextEditingController(text: _medication?.name);
    _dosageController = TextEditingController(text: _medication?.dosage);
    _reasonController = TextEditingController(text: _medication?.reason);
    _expirationDate = _medication?.expirationDate ?? DateTime.now();
    _expirationDateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(_expirationDate));
    _selectedUser = _medication?.user;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _reasonController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }

  Future<void> _selectExpirationDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = picked;
        _expirationDateController.text =
            DateFormat('dd/MM/yyyy').format(_expirationDate);
      });
    }
  }

  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      Medication medication = Medication(
        id: _medication?.id,
        name: _nameController.text,
        dosage: _dosageController.text,
        expirationDate: _expirationDate,
        user: _selectedUser,
        reason: _reasonController.text,
      );
      if (_medication?.id == null) {
        medication = await ref.read(medicationServiceProvider).addMedication(medication);
        setState(() {
          _medication = medication;
        });
      } else {
        await ref.read(medicationServiceProvider).updateMedication(medication);
      }

      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.scheduleNotificationsForMedication(medication);
      final _ = await ref.refresh(medicationListProvider.future);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _deleteMedication() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medication'),
        content: const Text('Are you sure you want to delete this medication?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(notificationServiceProvider).cancelAllNotificationsForMedication(_medication!.id!);
      await ref.read(medicationServiceProvider).deleteMedication(_medication!.id!);
      final _ = await ref.refresh(medicationListProvider.future);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _medication == null ? 'Add Medication' : 'Edit Medication',
        ),
        actions: [
          if (_medication != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteMedication,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Medication Name'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: inputDecoration.copyWith(hintText: 'e.g., Ibuprofen'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Dosage'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dosageController,
                decoration: inputDecoration.copyWith(hintText: 'e.g., 2 pills, 200mg, 1 spray'),
              ),
              const SizedBox(height: 16),
              const Text('For'),
              const SizedBox(height: 8),
              DropdownButtonFormField<User?>(
                initialValue: _selectedUser,
                decoration: inputDecoration,
                items: [
                  const DropdownMenuItem<User?>(
                    value: null,
                    child: Text('Select Family Member'),
                  ),
                  ..._users.map((user) => DropdownMenuItem<User?>(
                        value: user,
                        child: Text(user.name),
                      )),
                ],
                onChanged: (user) {
                  setState(() {
                    _selectedUser = user;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text('Reason for Use'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reasonController,
                decoration: inputDecoration.copyWith(hintText: 'e.g., Headache'),
              ),
              const SizedBox(height: 16),
              const Text('Expiration Date'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _expirationDateController,
                readOnly: true,
                onTap: () => _selectExpirationDate(context),
                decoration: inputDecoration.copyWith(
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                final notificationService = ref.read(notificationServiceProvider);
                notificationService.scheduleNotification(
                  id: 999,
                  title: 'Test Notification',
                  body: 'This is a test notification.',
                  scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
                );
              },
              child: const Text('Test Notification'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saveMedication,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
