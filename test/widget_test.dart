import 'package:flutter_test/flutter_test.dart';

import 'package:stackrushneon/app.dart';

void main() {
  testWidgets('shows splash title', (WidgetTester tester) async {
    await tester.pumpWidget(const StackRushNeonApp());

    expect(find.text('STACK RUSH'), findsOneWidget);
  });
}
