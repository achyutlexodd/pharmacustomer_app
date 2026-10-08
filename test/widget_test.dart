import 'package:flutter_test/flutter_test.dart';

import 'package:pharmacustomer_app/app/app.dart';

void main() {
  testWidgets('App smoke test — renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    // SplashScreen should be the first thing rendered.
    expect(find.text('AuraCare'), findsOneWidget);
  });
}
