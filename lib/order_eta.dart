import 'order.dart';

abstract class OrderEta {
  const OrderEta._();

  static OrderEta from(Order? optionalOrder) {
    if (optionalOrder == null) {
      return const _NoOrderEta();
    } else {
      switch (optionalOrder.status) {
        case "en route":
          return _EnRouteOrderEta(optionalOrder);

        default:
          return _DefaultOrderEta(optionalOrder);
      }
    }
  }

  DateTime? get current;
  bool get canBeUpdated;
}

class _NoOrderEta extends OrderEta {
  const _NoOrderEta() : super._();

  @override
  DateTime? get current => null;

  @override
  bool get canBeUpdated => false;
}

class _DefaultOrderEta extends OrderEta {
  final Order _order;

  const _DefaultOrderEta(this._order) : super._();

  @override
  DateTime? get current => _order.eta;

  @override
  bool get canBeUpdated => false;
}

class _EnRouteOrderEta extends _DefaultOrderEta {
  const _EnRouteOrderEta(Order order) : super(order);

  @override
  bool get canBeUpdated => true;
}
