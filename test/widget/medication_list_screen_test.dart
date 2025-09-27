import 'package:flutter_test/flutter_test.dart';
import 'package:kura/main.dart';

void main() {
  testWidgets('Medication List Screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the title is displayed.
    expect(find.text('Medication Manager'), findsOneWidget);

    // Verify that the "No medications found" message is displayed.
    expect(find.text('No medications found'), findsOneWidget);
  });
}
