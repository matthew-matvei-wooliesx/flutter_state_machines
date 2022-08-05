import 'package:flutter/material.dart';
import 'package:flutter_state_machines/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Given an order has not yet been created", () {
    testWidgets("Then a button to create a new order is shown", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      expect(_findingNewButton(), findsOneWidget);
    });
  });

  group("Given an order exists", () {
    testWidgets("Then the order's ID is shown", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      await tester.createNewOrder();

      final orderIdText = find.byKey(const Key("OrderId"));
      expect(orderIdText, findsOneWidget);

      expect(tester.firstWidget<Text>(orderIdText).data, isNotEmpty);
    });

    testWidgets("Then a button to create a new order is shown", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      await tester.createNewOrder();
      expect(_findingNewButton(), findsOneWidget);
    });
  });
}

extension _OrderInteractions on WidgetTester {
  Future<void> createNewOrder() async {
    await tap(_findingNewButton());
    await pump();
  }
}

Finder _findingNewButton() => find.widgetWithText(ElevatedButton, "New");
