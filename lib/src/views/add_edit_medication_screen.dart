import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/medication.dart';
import '../providers.dart';

class AddEditMedicationScreen extends ConsumerStatefulWidget {
  final Medication? medication;

  const AddEditMedicationScreen({super.key, this.medication});

  @override
  ConsumerState<AddEditMedicationScreen> createState() => _AddEditMedicationScreenState();
}

class _AddEditMedicationScreenState extends ConsumerState<AddEditMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _userController = TextEditingController();
  final _reasonController = TextEditingController();
  final _expirationDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.medication != null) {
      _nameController.text = widget.medication!.name;
      _userController.text = widget.medication!.user;
      _reasonController.text = widget.medication!.reason;
      _expirationDateController.text = DateFormat.yMd().format(widget.medication!.expirationDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.medication == null ? 'Add Medication' : 'Edit Medication'),
        actions: [
          if (widget.medication != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Medication'),
                    content: const Text('Are you sure you want to delete this medication?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  final medications = await ref.read(medicationListProvider.future);
                  final index = medications.indexOf(widget.medication!);
                  if (index != -1) {
                    await ref.read(medicationServiceProvider).deleteMedication(index);
                  }
                  ref.invalidate(medicationListProvider);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Semantics(
                label: 'Medication Name',
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Medication Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a medication name';
                    }
                    return null;
                  },
                ),
              ),
              Semantics(
                label: 'User',
                child: TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(labelText: 'User'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a user';
                    }
                    return null;
                  },
                ),
              ),
              Semantics(
                label: 'Reason',
                child: TextFormField(
                  controller: _reasonController,
                  decoration: const InputDecoration(labelText: 'Reason'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a reason';
                    }
                    return null;
                  },
                ),
              ),
              Semantics(
                label: 'Expiration Date',
                child: TextFormField(
                  controller: _expirationDateController,
                  decoration: const InputDecoration(
                    labelText: 'Expiration Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      _expirationDateController.text = DateFormat.yMd().format(date);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an expiration date';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final medication = Medication(
                      name: _nameController.text,
                      user: _userController.text,
                      reason: _reasonController.text,
                      expirationDate: DateFormat.yMd().parse(_expirationDateController.text),
                    );
                    if (widget.medication == null) {
                      await ref.read(medicationServiceProvider).addMedication(medication);
                    } else {
                      final medications = await ref.read(medicationListProvider.future);
                      final index = medications.indexOf(widget.medication!);
                      if (index != -1) {
                        await ref.read(medicationServiceProvider).updateMedication(index, medication);
                      }
                    }
                    ref.invalidate(medicationListProvider);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
