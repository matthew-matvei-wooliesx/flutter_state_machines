import 'package:flutter_state_machines/order.dart';
import 'package:flutter_state_machines/order_actions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group("Given no order", () {
    const Order? order = null;

    group("When getting Order Actions", () {
      late _ActionCallback mockNewOrderCallback;
      late List<dynamic> orderActions;

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
}

abstract class _ActionCallback {
  void call();
}

class _MockActionCallback extends Mock implements _ActionCallback {}
