import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:v2log/app.dart';

void main() {
  testWidgets('V2log app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: V2logApp(),
      ),
    );

    // Verify that app loads
    await tester.pumpAndSettle();

    // App should render without errors
    expect(find.byType(V2logApp), findsOneWidget);
  });
}
