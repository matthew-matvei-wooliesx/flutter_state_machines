import 'package:clock/clock.dart';
import 'package:flutter_state_machines/order.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Order order;
  final DateTime testTimeSnapshot = clock.now();

  setUp(() {
    withClock(Clock.fixed(testTimeSnapshot), () {
      order = newOrder();
    });
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
      const etaUpdateDuration = Duration(hours: 2);

      setUp(() {
        order.updateEtaBy(etaUpdateDuration);
      });

      test("Then the order's ETA is successfully updated", () {
        withClock(Clock.fixed(testTimeSnapshot), () {
          expect(order.eta, clock.now().add(etaUpdateDuration));
        });
      });
    });
  });

  group("Given an order is en route", () {
    setUp(() {
      withClock(Clock.fixed(testTimeSnapshot), () {
        order = newOrder();
      });

      order.start();
    });

    group("When the order arrives", () {
      setUp(() {
        order.arrive();
      });

      test("Then the order's state is 'arrived'", () {
        expect(order.state, isInstanceOf<ArrivedOrder>());
      });
    });

    group("When the ETA is updated", () {
      const etaUpdateDuration = Duration(hours: 3);

      setUp(() {
        order.updateEtaBy(etaUpdateDuration);
      });

      test("Then the order's ETA is successfully updated", () {
        withClock(Clock.fixed(testTimeSnapshot), () {
          expect(order.eta, clock.now().add(etaUpdateDuration));
        });
      });
    });
  });

  group("Given an order is arrived", () {
    setUp(() {
      order = newOrder();
      order.start();
      order.arrive();
    });

    group("When the order is started", () {
      orderStarts() => order.start();

      test("Then an OrderStateException is thrown", () {
        expect(orderStarts, throws<OrderStateException>());
      });
    });

    group("When the ETA is updated", () {
      updatingEta() => order.updateEtaBy(const Duration(hours: 2));

      test("Then an EtaUpdateException is thrown", () {
        expect(updatingEta, throws<EtaUpdateException>());
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

newOrder() => Order(eta: clock.now());
