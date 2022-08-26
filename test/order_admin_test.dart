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
      await tester.runApp();
      expect(_findingNewButton(), findsOneWidget);
    });

    testWidgets(
      "Then buttons to modify the order do not exist",
      (tester) async {
        await tester.runApp();
        expect(_findingStartButton(), findsNothing);
        expect(_findingArriveButton(), findsNothing);
        expect(_findingCompleteButton(), findsNothing);
      },
    );

    testWidgets("Then a current ETA is not shown", (tester) async {
      await tester.runApp();
      expect(_findingEtaDisplay(), findsNothing);
    });

    testWidgets("Then no customer signature is displayed", (tester) async {
      await tester.runApp();
      expect(_findingCustomerSignature(), findsNothing);
    });
  });

  group("Given an order exists", () {
    testWidgets("Then the order's ID is shown", (tester) async {
      await tester.runApp();
      await tester.createNewOrder();

      final orderIdText = find.byKey(const Key("OrderId"));
      expect(orderIdText, findsOneWidget);

      expect(tester.firstWidget<Text>(orderIdText).data, isNotEmpty);
    });

    testWidgets("Then a button to create a new order is shown", (tester) async {
      await tester.runApp();
      await tester.createNewOrder();
      expect(_findingNewButton(), findsOneWidget);
    });

    testWidgets("Then buttons to modify the order exist", (tester) async {
      await tester.runApp();
      await tester.createNewOrder();
      expect(_findingStartButton(), findsOneWidget);
      expect(_findingArriveButton(), findsOneWidget);
      expect(_findingCompleteButton(), findsOneWidget);
    });

    testWidgets("Then the order's current ETA is shown", (tester) async {
      await tester.runApp();
      await tester.createNewOrder();

      expect(_findingEtaDisplay(), findsOneWidget);
      expect(tester.firstWidget<Text>(_findingEtaDisplay()).data, isNotEmpty);
    });
  });

  group("Given an order has been started", () {
    testWidgets("Then the order cannot be started again", (tester) async {
      await tester.runApp();
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
        await tester.runApp(
          withOverrides: [
            dateTimePickerProvider.overrideWithValue(
              _FakeDateTimePicker(alwaysReturn: twoHourDelay),
            ),
          ],
        );
        await tester.startNewOrder();

        expect(
          tester.firstWidget<Text>(_findingEtaDisplay()).data,
          clock.fromNow(hours: 6).toString(),
        );

        expect(_findingUpdateEta(), findsOneWidget);

        await tester.tapWhenReady(_findingUpdateEta());
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
      await tester.runApp();
      await tester.arriveNewOrder();

      expect(_findingArriveButton(), findsOneWidget);
      expect(
        tester.firstWidget<ElevatedButton>(_findingArriveButton()).enabled,
        isFalse,
      );
    });

    testWidgets("Then the order's ETA cannot be updated", (tester) async {
      withClock(Clock.fixed(testTimeSnapshot), () async {
        const expectedOrderEta = Duration(hours: 6);
        final twoHourDelay = clock.fromNowBy(expectedOrderEta).add(
              const Duration(hours: 2),
            );
        await tester.runApp(
          withOverrides: [
            dateTimePickerProvider.overrideWithValue(
              _FakeDateTimePicker(alwaysReturn: twoHourDelay),
            ),
          ],
        );
        await tester.arriveNewOrder();

        expect(_findingUpdateEta(), findsNothing);
      });
    });

    testWidgets("Then no customer signature is displayed", (tester) async {
      await tester.runApp();
      await tester.arriveNewOrder();
      expect(_findingCustomerSignature(), findsNothing);
    });
  });

  group("Given an order has been completed", () {
    testWidgets("Then customer signature is displayed", (tester) async {
      await tester.runApp();
      await tester.completeNewOrder();
      expect(_findingCustomerSignature(), findsOneWidget);
    });
  });
}

extension _OrderInteractions on WidgetTester {
  Future<void> createNewOrder() async {
    await tapWhenReady(_findingNewButton());
    await pump();
  }

  Future<void> startNewOrder() async {
    await createNewOrder();
    await tapWhenReady(_findingStartButton());
    await pump();
  }

  Future<void> arriveNewOrder() async {
    await startNewOrder();
    await tapWhenReady(_findingArriveButton());
    await pump();
  }

  Future<void> completeNewOrder() async {
    await arriveNewOrder();
    await tapWhenReady(_findingCompleteButton());
    await pump();
  }
}

extension _TestApp on WidgetTester {
  Future<void> runApp({List<Override>? withOverrides}) async =>
      await pumpWidget(
        ProviderScope(
          child: const OrderAdmin(),
          overrides: withOverrides ?? [],
        ),
      );

  Future<void> tapWhenReady(Finder finder) async {
    await ensureVisible(finder);
    await pumpAndSettle();
    await tap(finder);
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
Finder _findingCustomerSignature() => find.text(
      "Customer Signature Received",
      skipOffstage: false,
    );

class _FakeDateTimePicker implements DateTimePicker {
  final DateTime? _staticDateTime;

  const _FakeDateTimePicker({required DateTime? alwaysReturn})
      : _staticDateTime = alwaysReturn;

  @override
  Future<DateTime?> pick(BuildContext _) async => _staticDateTime;
}
