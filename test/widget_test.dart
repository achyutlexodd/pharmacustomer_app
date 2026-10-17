import 'package:flutter_test/flutter_test.dart';

import 'package:pharmacustomer_app/app/app.dart';

void main() {
  testWidgets('App smoke test — renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('PharmaCustomer'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
