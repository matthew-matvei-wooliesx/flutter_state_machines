class Order {
  late OrderState _state;
  DateTime _eta;
  CustomerSignature? _customerSignature;

  Order({required DateTime eta}) : _eta = eta {
    _state = PendingOrder(this);
  }

  OrderState get state => _state;
  DateTime get eta => _eta;

  CustomerSignature? get customerSignature => _customerSignature;

  void start() {
    _state.start();
  }

  void arrive() {
    _state.arrive();
  }

  void updateEtaBy(Duration etaUpdateDuration) {
    _state.updateEtaTo(_eta.add(etaUpdateDuration));
  }

  void complete({required CustomerSignature customerSignature}) {
    _state.complete();
    _customerSignature = customerSignature;
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

  @override
  void updateEtaTo(DateTime newEta) {
    _order._eta = newEta;
  }

  @override
  void complete() {
    // TODO: implement complete
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
    _order._state = ArrivedOrder(_order);
  }

  @override
  void updateEtaTo(DateTime newEta) {
    _order._eta = newEta;
  }

  @override
  void complete() {
    // TODO: implement complete
  }
}

class ArrivedOrder implements OrderState {
  final Order _order;

  const ArrivedOrder(Order order) : _order = order;

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

  @override
  void complete() {
    _order._state = CompletedOrder();
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

  @override
  void complete() {
    // TODO: implement complete
  }
}

abstract class OrderState {
  void start();
  void arrive();
  void updateEtaTo(DateTime newEta);
  void complete();
}

class CustomerSignature {}

class OrderStateException implements Exception {}

class EtaUpdateException implements Exception {}
