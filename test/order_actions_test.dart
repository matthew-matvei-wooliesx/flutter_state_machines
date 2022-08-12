import 'package:clock/clock.dart';
import 'package:flutter_state_machines/order.dart';
import 'package:flutter_state_machines/order_actions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late _ActionCallback mockNewOrderCallback;
  late _ActionCallback mockStartOrderCallback;
  late _ActionCallback mockArriveOrderCallback;
  late _ActionCallback mockCompleteOrderCallback;

  setUp(() {
    mockNewOrderCallback = _MockActionCallback();
    mockStartOrderCallback = _MockActionCallback();
    mockArriveOrderCallback = _MockActionCallback();
    mockCompleteOrderCallback = _MockActionCallback();
  });

  group("Given no order", () {
    const Order? order = null;

    group("When getting Order Actions", () {
      late Iterable<OrderAction> orderActions;

      setUp(() {
        mockNewOrderCallback = _MockActionCallback();
        orderActions = OrderActions.from(
          order,
          callbacks: OrderActionsCallbacks(
            newOrder: mockNewOrderCallback,
            startOrder: mockStartOrderCallback,
            arriveOrder: mockArriveOrderCallback,
            completeOrder: mockCompleteOrderCallback,
          ),
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
      late Iterable<OrderAction> orderActions;

      setUp(() {
        mockNewOrderCallback = _MockActionCallback();
        orderActions = OrderActions.from(
          order,
          callbacks: OrderActionsCallbacks(
            newOrder: mockNewOrderCallback,
            startOrder: mockStartOrderCallback,
            arriveOrder: mockArriveOrderCallback,
            completeOrder: mockCompleteOrderCallback,
          ),
        );
      });

      test("Then a button for creating a new order is returned", () {
        expect(orderActions, isNotEmpty);
        expect(
          orderActions,
          contains(predicate((OrderAction action) => action.label == "New")),
        );
      });

      test("Then a new order can still be created", () {
        expect(orderActions, isNotEmpty);

        orderActions.firstWhere((action) => action.label == "New").call();

        verify(mockNewOrderCallback()).called(1);
      });

      test("Then the order can be started", () {
        throw UnimplementedError();
      });

      test("Then the order cannot arrive", () {
        throw UnimplementedError();
      });

      test("Then the order cannot be completed", () {
        throw UnimplementedError();
      });
    });
  });

  group("Given an en route order", () {
    final Order order = Order(eta: clock.now());
    order.start();

    group("When getting Order Actions", () {
      late Iterable<OrderAction> orderActions;

      setUp(() {
        orderActions = OrderActions.from(
          order,
          callbacks: OrderActionsCallbacks(
            newOrder: mockNewOrderCallback,
            startOrder: mockStartOrderCallback,
            arriveOrder: mockArriveOrderCallback,
            completeOrder: mockCompleteOrderCallback,
          ),
        );
      });

      test("Then a new order can still be created", () {
        expect(orderActions, isNotEmpty);

        orderActions.firstWhere((action) => action.label == "New").call();

        verify(mockNewOrderCallback()).called(1);
      });

      test("Then the order cannot be started", () {
        expect(orderActions, isNotEmpty);

        final newOrderAction =
            orderActions.firstWhere((action) => action.label == "Start");

        newOrderAction.call();

        expect(newOrderAction.callable, isFalse);
        verifyNever(mockStartOrderCallback());
      });

      test("Then the order can arrive", () {
        expect(orderActions, isNotEmpty);

        orderActions.firstWhere((action) => action.label == "Arrive").call();

        verify(mockArriveOrderCallback()).called(1);
      });

      test("Then the order cannot be completed", () {
        expect(orderActions, isNotEmpty);

        final completeOrderAction =
            orderActions.firstWhere((action) => action.label == "Complete");

        completeOrderAction.call();

        expect(completeOrderAction.callable, isFalse);
        verifyNever(mockCompleteOrderCallback());
      });
    });
  });

  group("Given an arrived order", () {
    group("When getting Order Actions", () {
      test("Then a new order can still be created", () {
        throw UnimplementedError();
      });

      test("Then the order cannot be started", () {
        throw UnimplementedError();
      });

      test("Then the order cannot arrive", () {
        throw UnimplementedError();
      });

      test("Then the order can be completed", () {
        throw UnimplementedError();
      });
    });
  });
}

abstract class _ActionCallback {
  void call();
}

class _MockActionCallback extends Mock implements _ActionCallback {}
