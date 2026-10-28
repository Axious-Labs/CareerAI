import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:careerai_mobile/main.dart';

void main() {
  testWidgets('CareerAI initial smoke test and screen transition', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CareerAIApp(),
      ),
    );

    // Verify CareerAI initial branding
    expect(find.text('CareerAI'), findsOneWidget);

    // Advance virtual clock past the splash screen timer duration
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();

    // Verify app rendered successfully
    expect(find.text('CareerAI'), findsWidgets);
  });
}
