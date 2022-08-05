import 'package:flutter_state_machines/order.dart';
import 'package:flutter_state_machines/order_actions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Given no order", () {
    const Order? order = null;

    group("When getting Order Actions", () {
      final orderActions = OrderActions.from(order);

      test("Then only a button for creating a new order is returned", () {
        expect(orderActions, hasLength(1));
        expect(orderActions.first.label, equals("New"));
      });
    });
  });
}
