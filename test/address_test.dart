import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacustomer_app/features/cart/address.dart';

void main() {
  testWidgets('address selection updates the delivery summary', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Address()));

    expect(find.text('Select Delivery Address'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Parents’ Home'), findsOneWidget);
    await tester.tap(find.text('Work / Office'));
    await tester.pump();

    expect(find.text('Delivering to: Work / Office'), findsOneWidget);
  });

  testWidgets('saving an address closes its editor without stale controllers', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Address()));
    await tester.tap(find.text('Add new'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Clinic');
    await tester.enterText(find.byType(TextField).at(1), '12 Health Street');
    await tester.tap(find.text('Save address'));
    await tester.pumpAndSettle();

    expect(find.text('Clinic'), findsOneWidget);
    expect(find.text('Delivering to: Clinic'), findsOneWidget);
  });

  testWidgets('editing an address uses the same safe dialog close path', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Address()));
    await tester.tap(find.byTooltip('Edit Home address'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'My Home');
    await tester.tap(find.text('Save address'));
    await tester.pumpAndSettle();

    expect(find.text('My Home'), findsOneWidget);
    expect(find.text('Delivering to: My Home'), findsOneWidget);
  });
}
