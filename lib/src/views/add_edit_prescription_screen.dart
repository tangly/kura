import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kura/src/models/prescription.dart';
import 'package:kura/src/providers.dart';

class AddEditPrescriptionScreen extends ConsumerStatefulWidget {
  final String memberId;
  final Prescription? prescription;
  const AddEditPrescriptionScreen({super.key, required this.memberId, this.prescription});

  @override
  ConsumerState<AddEditPrescriptionScreen> createState() =>
      _AddEditPrescriptionScreenState();
}

class _AddEditPrescriptionScreenState extends ConsumerState<AddEditPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _medicationNameController;
  late final TextEditingController _dosageController;
  late final TextEditingController _frequencyController;
  late final TextEditingController _durationController;
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    _medicationNameController = TextEditingController(text: widget.prescription?.medicationName);
    _dosageController = TextEditingController(text: widget.prescription?.dosage);
    _frequencyController = TextEditingController(text: widget.prescription?.frequency);
    _durationController = TextEditingController(text: widget.prescription?.duration);
    _startDate = widget.prescription?.startDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(widget.prescription == null ? 'Add Prescription' : 'Edit Prescription'),
        actions: [
          if (widget.prescription != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Prescription'),
                    content: const Text(
                        'Are you sure you want to delete this prescription?'),
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
                  ref
                      .read(familyMemberPrescriptionServiceProvider(widget.memberId))
                      .delete(widget.prescription!.id!);
                  context.pop();
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
              TextFormField(
                controller: _medicationNameController,
                decoration: const InputDecoration(labelText: 'Medication Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a medication name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(labelText: 'Dosage'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a dosage';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(labelText: 'Frequency'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a frequency';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(_startDate == null
                      ? 'No start date selected'
                      : 'Start Date: ${_startDate!.toLocal()} '.split(' ')[0]),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _startDate = date;
                        });
                      }
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && _startDate != null) {
                    final prescription = Prescription(
                      id: widget.prescription?.id,
                      medicationName: _medicationNameController.text,
                      dosage: _dosageController.text,
                      frequency: _frequencyController.text,
                      duration: _durationController.text,
                      startDate: _startDate!,
                    );
                    if (widget.prescription == null) {
                      ref
                          .read(familyMemberPrescriptionServiceProvider(widget.memberId))
                          .create(prescription);
                    } else {
                      ref
                          .read(familyMemberPrescriptionServiceProvider(widget.memberId))
                          .update(prescription.id!, prescription.toJson());
                    }
                    context.pop();
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
