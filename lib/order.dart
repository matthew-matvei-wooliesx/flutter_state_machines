class Order {
  late OrderState _state;
  DateTime _eta;
  CustomerSignature? _customerSignature;

  Order({required DateTime eta}) : _eta = eta {
    _state = _PendingOrder(this);
  }

  OrderState get state => _state;
  DateTime get eta => _eta;

  CustomerSignature? get customerSignature => _customerSignature;

  String get status => _state._status;

  void start() {
    _state._start();
  }

  void arrive() {
    _state._arrive();
  }

  void updateEtaBy(Duration etaUpdateDuration) {
    _state._updateEtaTo(_eta.add(etaUpdateDuration));
  }

  void complete({required CustomerSignature customerSignature}) {
    _state._complete();
    _customerSignature = customerSignature;
  }
}

abstract class _DefaultStateBehaviour implements OrderState {
  const _DefaultStateBehaviour();

  @override
  void _arrive() {
    throw OrderStateException();
  }

  @override
  void _complete() {
    throw OrderStateException();
  }

  @override
  void _start() {
    throw OrderStateException();
  }

  @override
  void _updateEtaTo(DateTime newEta) {
    throw EtaUpdateException();
  }
}

class _PendingOrder extends _DefaultStateBehaviour {
  final Order _order;

  const _PendingOrder(Order order) : _order = order;

  @override
  void _start() {
    _order._state = EnrouteOrder(_order);
  }

  @override
  void _updateEtaTo(DateTime newEta) {
    _order._eta = newEta;
  }

  @override
  String get _status => "pending";
}

class EnrouteOrder extends _DefaultStateBehaviour {
  final Order _order;

  const EnrouteOrder(Order order) : _order = order;

  @override
  void _arrive() {
    _order._state = ArrivedOrder(_order);
  }

  @override
  void _updateEtaTo(DateTime newEta) {
    _order._eta = newEta;
  }

  @override
  // TODO: implement _status
  String get _status => throw UnimplementedError();
}

class ArrivedOrder extends _DefaultStateBehaviour {
  final Order _order;

  const ArrivedOrder(Order order) : _order = order;

  @override
  void _complete() {
    _order._state = CompletedOrder();
  }

  @override
  // TODO: implement _status
  String get _status => throw UnimplementedError();
}

class CompletedOrder extends _DefaultStateBehaviour {
  @override
  // TODO: implement _status
  String get _status => throw UnimplementedError();
}

abstract class OrderState {
  String get _status;
  void _start();
  void _arrive();
  void _updateEtaTo(DateTime newEta);
  void _complete();
}

class CustomerSignature {}

class OrderStateException implements Exception {}

class EtaUpdateException implements Exception {}
