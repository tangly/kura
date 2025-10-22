import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kura/l10n/app_localizations.dart';
import 'package:kura/src/models/family_member.dart';
import 'package:kura/src/providers.dart';

class AddEditFamilyMemberScreen extends ConsumerStatefulWidget {
  final FamilyMember? familyMember;
  final String familyId;

  const AddEditFamilyMemberScreen(
      {super.key, this.familyMember, required this.familyId});

  @override
  ConsumerState<AddEditFamilyMemberScreen> createState() =>
      _AddEditFamilyMemberScreenState();
}

class _AddEditFamilyMemberScreenState
    extends ConsumerState<AddEditFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _notesController;
  FamilyMember? _familyMember;

  @override
  void initState() {
    super.initState();
    _familyMember = widget.familyMember;
    _nameController = TextEditingController(text: _familyMember?.name);
    _ageController = TextEditingController(text: _familyMember?.age.toString());
    _weightController =
        TextEditingController(text: _familyMember?.weight.toString());
    _notesController = TextEditingController(text: _familyMember?.notes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _capitalize(String s) {
    if (s.isEmpty) {
      return s;
    }
    return s[0].toUpperCase() + s.substring(1);
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final familyService = ref.read(familyServiceProvider);
      final currentUser = ref.read(authServiceProvider).firebaseAuth.currentUser;
      final member = FamilyMember(
        id: _familyMember?.id ?? '',
        name: _capitalize(_nameController.text),
        age: int.tryParse(_ageController.text) ?? 0,
        weight: int.tryParse(_weightController.text) ?? 0,
        notes: _notesController.text,
        createdAt: _familyMember?.createdAt ?? Timestamp.now(),
        createdBy: _familyMember?.createdBy ?? currentUser!.uid,
      );
      if (_familyMember == null) {
        await familyService.addFamilyMember(widget.familyId, member);
      } else {
        await familyService.updateFamilyMember(
            widget.familyId, _familyMember!.id, member.toJson());
      }

      // final _ = await ref.refresh(userListProvider.future);
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _deleteUser() async {
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
      final familyService = ref.read(familyServiceProvider);
      await familyService.deleteFamilyMember(
          widget.familyId, _familyMember!.id);
      // final _ = await ref.refresh(userListProvider.future);
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
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_familyMember == null
            ? l10n.addFamilyMember
            : l10n.editFamilyMember),
        actions: [
          if (_familyMember != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteUser,
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
              Text(l10n.name),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: inputDecoration.copyWith(hintText: l10n.egJohn),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterAName;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(l10n.age),
              const SizedBox(height: 8),
              TextFormField(
                controller: _ageController,
                decoration: inputDecoration.copyWith(hintText: l10n.eg30),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(l10n.weight),
              const SizedBox(height: 8),
              TextFormField(
                controller: _weightController,
                decoration: inputDecoration.copyWith(hintText: l10n.eg70_5),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(l10n.notes),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                decoration: inputDecoration.copyWith(hintText: l10n.egImportantMedicalHistory),
                maxLines: 3,
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
              onPressed: _saveUser,
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
