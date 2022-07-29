class Order {
  late OrderState _state;
  DateTime _eta;

  Order({required DateTime eta}) : _eta = eta {
    _state = PendingOrder(this);
  }

  OrderState get state => _state;
  DateTime get eta => _eta;

  void start() {
    _state.start();
  }

  void arrive() {
    _state.arrive();
  }

  void updateEtaBy(Duration etaUpdateDuration) {
    _eta = _eta.add(etaUpdateDuration);
  }
}

class PendingOrder implements OrderState {
  final Order _order;

  const PendingOrder(Order order) : _order = order;

  @override
  void start() {
    _order._state = EnrouteOrder(_order);
  }

  @override
  void arrive() {
    throw OrderStateException();
  }
}

class EnrouteOrder implements OrderState {
  final Order _order;

  const EnrouteOrder(Order order) : _order = order;

  @override
  void start() {
    // TODO: implement start
  }

  @override
  void arrive() {
    _order._state = ArrivedOrder();
  }
}

class ArrivedOrder implements OrderState {
  @override
  void arrive() {
    // TODO: implement arrive
  }

  @override
  void start() {
    // TODO: implement start
  }
}

abstract class OrderState {
  void start();
  void arrive();
}

class OrderStateException implements Exception {}
