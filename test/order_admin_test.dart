import 'package:flutter/material.dart';
import 'package:flutter_state_machines/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Given an order has not yet been created", () {
    testWidgets("Then a button to create a new route is shown", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      expect(find.widgetWithText(ElevatedButton, "New"), findsOneWidget);
    });
  });

  group("Given an order exists", () {
    testWidgets("Then the order's ID is shown", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      await tester.tap(find.widgetWithText(ElevatedButton, "New"));
      await tester.pump();

      final orderIdText = find.byKey(const Key("OrderId"));

      expect(orderIdText, findsOneWidget);

      expect(tester.firstWidget<Text>(orderIdText).data, isNotEmpty);
    });

    testWidgets("Then a button to create a new route is shown", (tester) {
      throw UnimplementedError();
    });
  });
}
