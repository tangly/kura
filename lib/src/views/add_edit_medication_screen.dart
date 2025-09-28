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
    _selectedUser = _medication?.user;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _reasonController.dispose();
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
      await notificationService.cancelAllNotificationsForMedication(medication.id!);
      final notificationDays = [30, 15, 7, 3, 1];
      for (final days in notificationDays) {
        final scheduledDate = _expirationDate.subtract(Duration(days: days));
        if (scheduledDate.isAfter(DateTime.now())) {
          await notificationService.scheduleNotification(
            id: medication.id! * 100 + days,
            title: 'Medication Expiration',
            body: '${medication.name} will expire in $days days.',
            scheduledDate: scheduledDate,
          );
        }
      }
      await ref.refresh(medicationListProvider.future);
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
      await ref.refresh(medicationListProvider.future);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  icon: Icon(Icons.medication),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  icon: Icon(Icons.medical_services),
                ),
              ),
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason',
                  icon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<User?>(
                initialValue: _selectedUser,
                decoration: const InputDecoration(
                  labelText: 'User',
                  icon: Icon(Icons.person),
                ),
                items: [
                  const DropdownMenuItem<User?>(
                    value: null,
                    child: Text('For the whole family'),
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
              Row(
                children: [
                  const Icon(Icons.calendar_today),
                  const SizedBox(width: 16),
                  Text('Expires: ${DateFormat('dd/MM/yyyy').format(_expirationDate)}'),
                  TextButton(
                    onPressed: () => _selectExpirationDate(context),
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveMedication,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
