import 'package:clock/clock.dart';
import 'package:flutter_state_machines/order.dart';
import 'package:flutter_state_machines/order_actions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("Given no order", () {
    const Order? order = null;

    group("When getting Order Actions", () {
      late _ActionCallback mockNewOrderCallback;
      late List<OrderAction> orderActions;

      setUp(() {
        mockNewOrderCallback = _MockActionCallback();
        orderActions = OrderActions.from(
          order,
          callbacks: OrderActionsCallbacks(newOrder: mockNewOrderCallback),
        );
      });

      test("Then only a button for creating a new order is returned", () {
        expect(orderActions, hasLength(1));
        expect(orderActions.first.label, equals("New"));
      });

      test("Then an action can be invoked to create a new order", () {
        expect(orderActions, hasLength(1));

        orderActions.first();

        verify(mockNewOrderCallback()).called(1);
      });
    });
  });

  group("Given a new order", () {
    final Order order = Order(eta: clock.now());

    group("When getting Order Actions", () {
      late _ActionCallback mockNewOrderCallback;
      late List<OrderAction> orderActions;

      setUp(() {
        mockNewOrderCallback = _MockActionCallback();
        orderActions = OrderActions.from(
          order,
          callbacks: OrderActionsCallbacks(newOrder: mockNewOrderCallback),
        );
      });

      test("Then a button for creating a new order is returned", () {
        expect(orderActions, isNotEmpty);
        expect(
          orderActions,
          contains(predicate((OrderAction action) => action.label == "New")),
        );
      });

      test("Then an action can be invoked to create a new order", () {
        expect(orderActions, isNotEmpty);

        orderActions.firstWhere((action) => action.label == "New").call();

        verify(mockNewOrderCallback()).called(1);
      });
    });
  });
}

abstract class _ActionCallback {
  void call();
}

class _MockActionCallback extends Mock implements _ActionCallback {}
