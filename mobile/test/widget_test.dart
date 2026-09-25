import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:careerai_mobile/main.dart';

void main() {
  testWidgets('CareerAI initial smoke test', (WidgetTester tester) async {
    // Build our app wrapped in ProviderScope and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: CareerAIApp(),
      ),
    );

    // Verify that the CareerAI text is displayed.
    expect(find.text('CareerAI'), findsOneWidget);
  });
  testWidgets('CareerAI initial smoke test', (WidgetTester tester) async {

  }
}
