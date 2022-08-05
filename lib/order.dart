import 'package:uuid/uuid.dart';

class Order {
  late OrderState _state;
  DateTime _eta;
  CustomerSignature? _customerSignature;

  final String id;

  Order({required DateTime eta})
      : _eta = eta,
        id = const Uuid().v4() {
    _state = _PendingOrder(this);
  }

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
    _order._state = _EnrouteOrder(_order);
  }

  @override
  void _updateEtaTo(DateTime newEta) {
    _order._eta = newEta;
  }

  @override
  String get _status => "pending";
}

class _EnrouteOrder extends _DefaultStateBehaviour {
  final Order _order;

  const _EnrouteOrder(Order order) : _order = order;

  @override
  void _arrive() {
    _order._state = _ArrivedOrder(_order);
  }

  @override
  void _updateEtaTo(DateTime newEta) {
    _order._eta = newEta;
  }

  @override
  String get _status => "en route";
}

class _ArrivedOrder extends _DefaultStateBehaviour {
  final Order _order;

  const _ArrivedOrder(Order order) : _order = order;

  @override
  void _complete() {
    _order._state = _CompletedOrder();
  }

  @override
  String get _status => "arrived";
}

class _CompletedOrder extends _DefaultStateBehaviour {
  @override
  String get _status => "complete";
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
