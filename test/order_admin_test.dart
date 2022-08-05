import 'package:flutter/material.dart';
import 'package:flutter_state_machines/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Given an order has not yet been created", () {
    testWidgets("Then a button to create a new order is shown", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      expect(_findingNewButton(), findsOneWidget);
    });

    testWidgets(
      "Then buttons to modify the order do not exist",
      (tester) async {
        await tester.pumpWidget(const OrderAdmin());
        expect(_findingStartButton(), findsNothing);
        expect(_findingArriveButton(), findsNothing);
        expect(_findingCompleteButton(), findsNothing);
      },
    );
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

    testWidgets("Then buttons to modify the order exist", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      await tester.createNewOrder();
      expect(_findingStartButton(), findsOneWidget);
      expect(_findingArriveButton(), findsOneWidget);
      expect(_findingCompleteButton(), findsOneWidget);
    });
  });
}

extension _OrderInteractions on WidgetTester {
  Future<void> createNewOrder() async {
    await tap(_findingNewButton());
    await pump();
  }
}

Finder _findingNewButton() => find.widgetWithText(
      ElevatedButton,
      "New",
    );
Finder _findingStartButton() => find.widgetWithText(
      ElevatedButton,
      "Start",
    );
Finder _findingArriveButton() => find.widgetWithText(
      ElevatedButton,
      "Arrive",
    );
Finder _findingCompleteButton() => find.widgetWithText(
      ElevatedButton,
      "Complete",
    );
