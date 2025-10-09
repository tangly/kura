import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/models/user.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/medication_list_screen.dart';

void main() {
  final user1 = User(id: 1, name: 'User 1');
  final user2 = User(id: 2, name: 'User 2');

  final now = DateTime.now();
  final medications = [
    Medication(id: 1, name: 'Aspirin', dosage: '100mg', expirationDate: now.add(const Duration(days: 10)), user: user1),
    Medication(id: 2, name: 'Ibuprofen', dosage: '200mg', expirationDate: now.add(const Duration(days: 5)), user: user2),
    Medication(id: 3, name: 'Paracetamol', dosage: '500mg', expirationDate: now.subtract(const Duration(days: 1)), user: user1),
  ];

  testWidgets('MedicationListScreen displays all medications when filter is all', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          medicationFilterProvider.overrideWith((ref) => MedicationFilter.all),
          medicationListProvider.overrideWith((ref) => Future.value(medications)),
          userListProvider.overrideWith((ref) => Future.value([user1, user2])),
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
          medicationListProvider.overrideWith((ref) => Future.value(medications.where((med) => med.user?.id == user2.id).toList())),
          userListProvider.overrideWith((ref) => Future.value([user1, user2])),
        ],
        child: const MaterialApp(home: MedicationListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Aspirin'), findsNothing);
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.text('Paracetamol'), findsNothing);
  });

  testWidgets('MedicationListScreen filters medications by expired', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          medicationFilterProvider.overrideWith((ref) => MedicationFilter.expired),
          medicationListProvider.overrideWith((ref) => Future.value(medications.where((med) => med.expirationDate.isBefore(now)).toList())),
          userListProvider.overrideWith((ref) => Future.value([user1, user2])),
        ],
        child: const MaterialApp(home: MedicationListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Aspirin'), findsNothing);
    expect(find.text('Ibuprofen'), findsNothing);
    expect(find.text('Paracetamol'), findsOneWidget);
  });
}
