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

    testWidgets("Then a current ETA is not shown", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      expect(_findingEtaDisplay(), findsNothing);
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

    testWidgets("Then buttons to modify the order exist", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      await tester.createNewOrder();
      expect(_findingStartButton(), findsOneWidget);
      expect(_findingArriveButton(), findsOneWidget);
      expect(_findingCompleteButton(), findsOneWidget);
    });

    testWidgets("Then the order's current ETA is shown", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      await tester.createNewOrder();

      expect(_findingEtaDisplay(), findsOneWidget);
      expect(tester.firstWidget<Text>(_findingEtaDisplay()).data, isNotEmpty);
    });
  });

  group("Given an order has been started", () {
    testWidgets("Then the order cannot be started again", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      await tester.startNewOrder();

      expect(_findingStartButton(), findsOneWidget);
      expect(
        tester.firstWidget<ElevatedButton>(_findingStartButton()).enabled,
        isFalse,
      );
    });
  });

  group("Given an order has arrived", () {
    testWidgets("Then the order cannot arrive again", (tester) async {
      await tester.pumpWidget(const OrderAdmin());
      await tester.arriveNewOrder();

      expect(_findingArriveButton(), findsOneWidget);
      expect(
        tester.firstWidget<ElevatedButton>(_findingArriveButton()).enabled,
        isFalse,
      );
    });
  });
}

extension _OrderInteractions on WidgetTester {
  Future<void> createNewOrder() async {
    await tap(_findingNewButton());
    await pump();
  }

  Future<void> startNewOrder() async {
    await createNewOrder();
    await tap(_findingStartButton());
    await pump();
  }

  Future<void> arriveNewOrder() async {
    await startNewOrder();
    await tap(_findingArriveButton());
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
Finder _findingEtaDisplay() => find.byKey(const Key("EtaDisplay"));
