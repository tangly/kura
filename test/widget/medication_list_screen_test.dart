import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kura/src/models/app_user.dart';
import 'package:kura/src/models/family_medication.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/medication_list_screen.dart';

void main() {
  final user1 = AppUser(id: '1', name: 'User 1', createdAt: Timestamp.now());
  final user2 = AppUser(id: '2', name: 'User 2', createdAt: Timestamp.now());

  final now = DateTime.now();
  final medications = [
    Medication(id: '1', name: 'Aspirin', dosage: '100mg', expirationDate: now.add(const Duration(days: 10)), familyId: 'family1'),
    Medication(id: '2', name: 'Ibuprofen', dosage: '200mg', expirationDate: now.add(const Duration(days: 5)), familyId: 'family1'),
    Medication(id: '3', name: 'Paracetamol', dosage: '500mg', expirationDate: now.subtract(const Duration(days: 1)), familyId: 'family1'),
  ];

  testWidgets('MedicationListScreen displays all medications when filter is all', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          medicationFilterProvider.overrideWith((ref) => MedicationFilter.all),
          medicationListProvider.overrideWith((ref) => Stream.value(medications)),
          userListProvider.overrideWith((ref) => Stream.value([user1, user2])),
          currentUserProvider.overrideWith((ref) => Stream.value(user1.copyWith(families: ['family1']))),
        ],
        child: const MaterialApp(home: MedicationListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);
  });

  testWidgets('MedicationListScreen filters medications by selected user', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          medicationFilterProvider.overrideWith((ref) => MedicationFilter.user),
          selectedUserProvider.overrideWith((ref) => user2),
          medicationListProvider.overrideWith((ref) => Stream.value(medications.where((med) => med.familyId == 'family1').toList())),
          userListProvider.overrideWith((ref) => Stream.value([user1, user2])),
          currentUserProvider.overrideWith((ref) => Stream.value(user1.copyWith(families: ['family1']))),
        ],
        child: const MaterialApp(home: MedicationListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Aspirin'), findsNothing);
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.text('Paracetamol'), findsNothing);
  });

  
}
