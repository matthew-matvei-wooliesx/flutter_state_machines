import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_state_machines/date_time_picker.dart';
import 'package:flutter_state_machines/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testTimeSnapshot = DateTime.now();

  group("Given an order has not yet been created", () {
    testWidgets("Then a button to create a new order is shown", (tester) async {
      await tester.pumpWidget(_orderAdminPage());
      expect(_findingNewButton(), findsOneWidget);
    });

    testWidgets(
      "Then buttons to modify the order do not exist",
      (tester) async {
        await tester.pumpWidget(_orderAdminPage());
        expect(_findingStartButton(), findsNothing);
        expect(_findingArriveButton(), findsNothing);
        expect(_findingCompleteButton(), findsNothing);
      },
    );

    testWidgets("Then a current ETA is not shown", (tester) async {
      await tester.pumpWidget(_orderAdminPage());
      expect(_findingEtaDisplay(), findsNothing);
    });
  });

  group("Given an order exists", () {
    testWidgets("Then the order's ID is shown", (tester) async {
      await tester.pumpWidget(_orderAdminPage());
      await tester.createNewOrder();

      final orderIdText = find.byKey(const Key("OrderId"));
      expect(orderIdText, findsOneWidget);

      expect(tester.firstWidget<Text>(orderIdText).data, isNotEmpty);
    });

    testWidgets("Then a button to create a new order is shown", (tester) async {
      await tester.pumpWidget(_orderAdminPage());
      await tester.createNewOrder();
      expect(_findingNewButton(), findsOneWidget);
    });

    testWidgets("Then buttons to modify the order exist", (tester) async {
      await tester.pumpWidget(_orderAdminPage());
      await tester.createNewOrder();
      expect(_findingStartButton(), findsOneWidget);
      expect(_findingArriveButton(), findsOneWidget);
      expect(_findingCompleteButton(), findsOneWidget);
    });

    testWidgets("Then the order's current ETA is shown", (tester) async {
      await tester.pumpWidget(_orderAdminPage());
      await tester.createNewOrder();

      expect(_findingEtaDisplay(), findsOneWidget);
      expect(tester.firstWidget<Text>(_findingEtaDisplay()).data, isNotEmpty);
    });
  });

  group("Given an order has been started", () {
    testWidgets("Then the order cannot be started again", (tester) async {
      await tester.pumpWidget(_orderAdminPage());
      await tester.startNewOrder();

      expect(_findingStartButton(), findsOneWidget);
      expect(
        tester.firstWidget<ElevatedButton>(_findingStartButton()).enabled,
        isFalse,
      );
    });

    testWidgets("Then the order's ETA can be updated", (tester) async {
      withClock(Clock.fixed(testTimeSnapshot), () async {
        const expectedOrderEta = Duration(hours: 6);
        final twoHourDelay = clock.fromNowBy(expectedOrderEta).add(
              const Duration(hours: 2),
            );
        await tester.pumpWidget(
          _orderAdminPage(
            overrides: [
              dateTimePickerProvider.overrideWithValue(() async => twoHourDelay)
            ],
          ),
        );
        await tester.startNewOrder();

        expect(
          tester.firstWidget<Text>(_findingEtaDisplay()).data,
          clock.fromNow(hours: 6).toString(),
        );

        expect(_findingUpdateEta(), findsOneWidget);

        await tester.tap(_findingUpdateEta());
        await tester.pumpAndSettle();

        expect(
          tester.firstWidget<Text>(_findingEtaDisplay()).data,
          clock.fromNow(hours: 8).toString(),
        );
      });
    });
  });

  group("Given an order has arrived", () {
    testWidgets("Then the order cannot arrive again", (tester) async {
      await tester.pumpWidget(_orderAdminPage());
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
      skipOffstage: false,
    );
Finder _findingStartButton() => find.widgetWithText(
      ElevatedButton,
      "Start",
      skipOffstage: false,
    );
Finder _findingArriveButton() => find.widgetWithText(
      ElevatedButton,
      "Arrive",
      skipOffstage: false,
    );
Finder _findingCompleteButton() => find.widgetWithText(
      ElevatedButton,
      "Complete",
      skipOffstage: false,
    );
Finder _findingEtaDisplay() => find.byKey(
      const Key("EtaDisplay"),
      skipOffstage: false,
    );
Finder _findingUpdateEta() => find.widgetWithText(
      ElevatedButton,
      "Update ETA",
      skipOffstage: false,
    );

Widget _orderAdminPage({
  List<Override>? overrides,
}) =>
    ProviderScope(
      child: const OrderAdmin(),
      overrides: overrides ?? [],
    );
