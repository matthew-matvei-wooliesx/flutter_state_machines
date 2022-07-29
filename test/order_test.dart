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
    test("Then the order's status is 'pending'", () {
      expect(order.status, "pending");
    });

    group("When the order is started", () {
      setUp(() {
        order.start();
      });

      test("Then the order's status is 'en route'", () {
        expect(order.status, "en route");
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

      test("Then the order's status is 'arrived'", () {
        expect(order.status, "arrived");
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

    test("Then the customer signature is not available", () {
      expect(order.customerSignature, isNull);
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

    group("When the order is completed", () {
      setUp(() {
        order.complete(customerSignature: CustomerSignature());
      });

      test("Then the order's status is 'complete'", () {
        expect(order.status, "complete");
      });
    });
  });

  group("Given an order is complete", () {
    setUp(() {
      order = newOrder();
      order.start();
      order.arrive();
      order.complete(customerSignature: CustomerSignature());
    });

    test("Then the customer signature is available", () {
      expect(order.customerSignature, isNotNull);
    });
  });
}

throws<T extends Exception>() => throwsA(TypeMatcher<T>());

newOrder() => Order(eta: clock.now());
