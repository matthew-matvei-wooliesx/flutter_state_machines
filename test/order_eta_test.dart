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
      expect(orderEta.etaUpdater, isNull);
    });
  });

  group("Given an 'en route' order", () {
    test("Then a current ETA is shown", () {
      throw UnimplementedError();
    });

    test("Then the ETA can be updated", () {
      throw UnimplementedError();
    });
  });

  group("Given an arrived order", () {
    test("Then a current ETA is shown", () {
      throw UnimplementedError();
    });

    test("Then updating the ETA is not allowed", () {
      throw UnimplementedError();
    });
  });
}
