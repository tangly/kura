import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kura/src/models/medication.dart';
import 'package:kura/src/providers.dart';
import 'package:kura/src/views/medication_list_screen.dart';

void main() {
  testWidgets('MedicationListScreen displays medications correctly', (WidgetTester tester) async {
    final now = DateTime.now();
    final medications = [
      Medication(id: 1, name: 'Aspirin', dosage: '100mg', expirationDate: now.add(const Duration(days: 10))),
      Medication(id: 2, name: 'Ibuprofen', dosage: '200mg', expirationDate: now.add(const Duration(days: 5))),
      Medication(id: 3, name: 'Paracetamol', dosage: '500mg', expirationDate: now.subtract(const Duration(days: 1))),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          medicationListProvider.overrideWith((ref) => Future.value(medications)),
        ],
        child: const MaterialApp(home: MedicationListScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Aspirin'), findsOneWidget);
    expect(find.text('Ibuprofen'), findsOneWidget);
    expect(find.text('Paracetamol'), findsOneWidget);

    final ibuprofenTile = tester.widget<ListTile>(find.ancestor(of: find.text('Ibuprofen'), matching: find.byType(ListTile)));
    expect(ibuprofenTile.tileColor, Colors.yellow);

    final paracetamolTile = tester.widget<ListTile>(find.ancestor(of: find.text('Paracetamol'), matching: find.byType(ListTile)));
    expect(paracetamolTile.tileColor, Colors.red);
  });
}
