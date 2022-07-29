class Order {
  late OrderState _state;

  Order() {
    _state = PendingOrder(this);
  }

  OrderState get state => _state;

  void start() {
    _state.start();
  }

  void arrive() {
    _state.arrive();
  }
}

class PendingOrder implements OrderState {
  final Order _order;

  const PendingOrder(Order order) : _order = order;

  @override
  void start() {
    _order._state = EnrouteOrder();
  }

  @override
  void arrive() {
    throw OrderStateException();
  }
}

class EnrouteOrder implements OrderState {
  @override
  void start() {
    // TODO: implement start
  }

  @override
  void arrive() {
    // TODO: implement arrive
  }
}

abstract class OrderState {
  void start();
  void arrive();
}

class OrderStateException implements Exception {}
