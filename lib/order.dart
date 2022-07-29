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
    _state.updateEtaTo(_eta.add(etaUpdateDuration));
  }

  void complete() {}
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

  @override
  void updateEtaTo(DateTime newEta) {
    _order._eta = newEta;
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

  @override
  void updateEtaTo(DateTime newEta) {
    _order._eta = newEta;
  }
}

class ArrivedOrder implements OrderState {
  @override
  void arrive() {
    // TODO: implement arrive
  }

  @override
  void start() {
    throw OrderStateException();
  }

  @override
  void updateEtaTo(DateTime newEta) {
    throw EtaUpdateException();
  }
}

class CompletedOrder implements OrderState {
  @override
  void arrive() {
    // TODO: implement arrive
  }

  @override
  void start() {
    // TODO: implement start
  }

  @override
  void updateEtaTo(DateTime newEta) {
    // TODO: implement updateEtaTo
  }
}

abstract class OrderState {
  void start();
  void arrive();
  void updateEtaTo(DateTime newEta);
}

class OrderStateException implements Exception {}

class EtaUpdateException implements Exception {}
