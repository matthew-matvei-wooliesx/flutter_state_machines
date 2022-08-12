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

        orderActions.findNewAction().call();

        verify(mockNewOrderCallback()).called(1);
      });

      test("Then the order can be started", () {
        expect(orderActions, isNotEmpty);

        orderActions.findStartAction().call();

        verify(mockStartOrderCallback()).called(1);
      });

      test("Then the order cannot arrive", () {
        expect(orderActions, isNotEmpty);

        final arriveAction = orderActions.findArriveAction();
        arriveAction.call();

        expect(arriveAction.callable, isFalse);
        verifyNever(mockArriveOrderCallback());
      });

      test("Then the order cannot be completed", () {
        expect(orderActions, isNotEmpty);

        final completeAction = orderActions.findCompleteAction();
        completeAction.call();

        expect(completeAction.callable, isFalse);
        verifyNever(mockCompleteOrderCallback());
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

        orderActions.findNewAction().call();

        verify(mockNewOrderCallback()).called(1);
      });

      test("Then the order cannot be started", () {
        expect(orderActions, isNotEmpty);

        final startOrderAction = orderActions.findStartAction();

        startOrderAction.call();

        expect(startOrderAction.callable, isFalse);
        verifyNever(mockStartOrderCallback());
      });

      test("Then the order can arrive", () {
        expect(orderActions, isNotEmpty);

        orderActions.findArriveAction().call();

        verify(mockArriveOrderCallback()).called(1);
      });

      test("Then the order cannot be completed", () {
        expect(orderActions, isNotEmpty);

        final completeOrderAction = orderActions.findCompleteAction();

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

bool Function(OrderAction) _actionLabelIs(String label) =>
    (action) => action.label == label;

extension _ActionFinder on Iterable<OrderAction> {
  OrderAction findNewAction() => firstWhere(_actionLabelIs("New"));
  OrderAction findStartAction() => firstWhere(_actionLabelIs("Start"));
  OrderAction findArriveAction() => firstWhere(_actionLabelIs("Arrive"));
  OrderAction findCompleteAction() => firstWhere(_actionLabelIs("Complete"));
}
