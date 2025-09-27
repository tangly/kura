import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kura/main.dart';

void main() {
  testWidgets('Add/Edit Medication Screen smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the text fields are displayed.
    expect(find.byType(TextField), findsNWidgets(4));

    // Verify that the save button is displayed.
    expect(find.text('Save'), findsOneWidget);
  });
}
