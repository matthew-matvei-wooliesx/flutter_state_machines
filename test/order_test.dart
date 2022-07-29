import 'package:flutter_state_machines/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Order order;

  setUp(() {
    order = Order();
  });

  group("Given an order is pending", () {
    test("Then the order's state is 'pending'", () {
      expect(order.state, isInstanceOf<PendingOrder>());
    });

    group("When the order is started", () {
      setUp(() {
        order.start();
      });

      test("Then the order's state is 'en route'", () {
        expect(order.state, isInstanceOf<EnrouteOrder>());
      });
    });

    group("When the order arrives", () {
      orderArrives() => order.arrive();

      test("Then an OrderStateException is thrown", () {
        expect(orderArrives, throws<OrderStateException>());
      });
    });

    group("When the ETA is updated", () {
      test("Then the order's ETA is successfully updated", () {
        throw UnimplementedError();
      });
    });
  });

  group("Given an order is en route", () {
    group("When the order is marked pending", () {
      test("Then an OrderStateException is thrown", () {
        throw UnimplementedError();
      });
    });

    group("When the order arrives", () {
      test("Then the order's state is 'arrived'", () {
        throw UnimplementedError();
      });
    });

    group("When the ETA is updated", () {
      test("Then the order's ETA is successfully updated", () {
        throw UnimplementedError();
      });
    });
  });

  group("Given an order is arrived", () {
    group("When the order is started", () {
      test("Then an OrderStateException is thrown", () {
        throw UnimplementedError();
      });
    });

    group("When the ETA is updated", () {
      test("Then an EtaUpdateException is thrown", () {
        throw UnimplementedError();
      });
    });

    group("When the order is marked complete", () {
      test("Then the order's state is 'complete'", () {
        throw UnimplementedError();
      });
    });
  });

  group("Given an order is complete", () {
    test("Then the customer signature is available", () {
      throw UnimplementedError();
    });
  });
}

throws<T extends Exception>() => throwsA(TypeMatcher<T>());
