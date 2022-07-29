class Order {
  late OrderState _state;

  Order() {
    _state = PendingOrder(this);
  }

  OrderState get state => _state;

  void start() {
    _state.start();
  }
}

class PendingOrder implements OrderState {
  final Order _order;

  const PendingOrder(Order order) : _order = order;

  @override
  void start() {
    _order._state = EnrouteOrder();
  }
}

class EnrouteOrder implements OrderState {
  @override
  void start() {
    // TODO: implement start
  }
}

abstract class OrderState {
  void start();
}
