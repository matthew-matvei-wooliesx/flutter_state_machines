import 'package:clock/clock.dart';
import 'package:flutter_state_machines/order.dart';
import 'package:flutter_state_machines/order_eta.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Given there's no order", () {
    const Order? order = null;
    final orderEta = OrderEta.from(order);

    test("Then there's no current ETA to show", () {
      expect(orderEta.currentEta, isNull);
    });

    test("Then updating the ETA is not allowed", () {
      expect(orderEta.canUpdateEta, isFalse);
    });
  });

  group("Given an 'en route' order", () {
    final order = Order(eta: clock.fromNow(hours: 6));
    order.start();
    final orderEta = OrderEta.from(order);

    test("Then a current ETA is shown", () {
      expect(orderEta.currentEta, order.eta);
    });

    test("Then the ETA can be updated", () {
      expect(orderEta.canUpdateEta, isTrue);
    });
  });

  group("Given an arrived order", () {
    final order = Order(eta: clock.fromNow(hours: 6))
      ..start()
      ..arrive();
    final orderEta = OrderEta.from(order);

    test("Then a current ETA is shown", () {
      expect(orderEta.currentEta, order.eta);
    });

    test("Then updating the ETA is not allowed", () {
      expect(orderEta.canUpdateEta, isFalse);
    });
  });
}
