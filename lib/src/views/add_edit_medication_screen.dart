import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/models/family_medication.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/widgets/multi_select_dialog.dart';

class AddEditMedicationScreen extends ConsumerStatefulWidget {
  final FamilyMedication? medication;
  final String familyId;

  const AddEditMedicationScreen({super.key, this.medication, required this.familyId});

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
  FamilyMedication? _medication;
  List<String> _selectedMembers = [];

  @override
  void initState() {
  super.initState();
  _medication = widget.medication;
  _nameController = TextEditingController(text: _medication?.name);
  _dosageController = TextEditingController(text: _medication?.dosage);
  _reasonController = TextEditingController(text: _medication?.reason);
  _expirationDate = _medication?.expirationDate ?? DateTime.now();
  _expirationDateController = TextEditingController(
    text: DateFormat('MM/yyyy').format(_expirationDate));
  _selectedMembers = _medication?.members ?? [];
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
      initialDatePickerMode: DatePickerMode.year,
    );
    if (picked != null && picked != _expirationDate) {
      setState(() {
        _expirationDate = DateTime(picked.year, picked.month + 1, 0);
        _expirationDateController.text =
            DateFormat('MM/yyyy').format(_expirationDate);
      });
    }
  }

  void _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      FamilyMedication medication = FamilyMedication(
        id: _medication?.id,
        name: _nameController.text,
        dosage: _dosageController.text,
        expirationDate: _expirationDate,
        members: _selectedMembers,
        reason: _reasonController.text,
      );
      if (_medication?.id == null) {
        await ref.read(familyServiceProvider).addFamilyMedication(widget.familyId,medication);
      } else {
        await ref.read(familyServiceProvider).updateFamilyMedication(widget.familyId, medication.id!, medication.toJson());
      }

      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.scheduleNotificationsForMedication(medication);
      //final _ = await ref.refresh(medicationListProvider.future);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _deleteMedication() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteMedication),
        content: Text(l10n.areYouSureYouWantToDeleteThisMedication),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(notificationServiceProvider).cancelAllNotificationsForMedication(_medication!.id!);
      await ref.read(familyServiceProvider).deleteFamilyMedication(widget.familyId,_medication!.id!);
      final _ = await ref.refresh(medicationListProvider.future);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
    final membersList = ref.watch(familyMembersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _medication == null ? l10n.addMedication : l10n.editMedication,
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
              Text(l10n.medicationName),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: inputDecoration.copyWith(hintText: l10n.egIbuprofen),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterAName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(l10n.dosage),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dosageController,
                decoration: inputDecoration.copyWith(hintText: l10n.eg2Pills200mg1Spray),
              ),
              const SizedBox(height: 16),
              Text(l10n.forMedication),
              const SizedBox(height: 8),
              membersList.when(
                data: (members) {
                  return InkWell(
                    onTap: () async {
                      final selectedMemberIds = await showDialog<List<String>>(
                        context: context,
                        builder: (context) => MultiSelectDialog(
                          members: members,
                          selectedUserIds: _selectedMembers,
                        ),
                      );
                      if (selectedMemberIds != null) {
                        setState(() {
                          _selectedMembers = selectedMemberIds;
                        });
                      }
                    },
                    child: InputDecorator(
                      decoration: inputDecoration,
                      child: Text(
                        _selectedMembers.isEmpty
                            ? l10n.selectFamilyMember
                            : members
                                .where((member) => _selectedMembers.contains(member.id))
                                .map((member) => member.name)
                                .join(', '),
                      ),
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text(l10n.couldNotLoadUsers),
              ),
              const SizedBox(height: 16),
              Text(l10n.reasonForUse),
              const SizedBox(height: 8),
              TextFormField(
                controller: _reasonController,
                decoration: inputDecoration.copyWith(hintText: l10n.egHeadache),
              ),
              const SizedBox(height: 16),
              Text(l10n.expirationDate),
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
            /* ElevatedButton(
              onPressed: () {
                final notificationService = ref.read(notificationServiceProvider);
                notificationService.scheduleNotification(
                  id: 999,
                  title: l10n.testNotification,
                  body: 'This is a test notification.',
                  scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
                );
              },
              child: Text(l10n.testNotification),
            ), */
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saveMedication,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(l10n.save, style: theme.textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
