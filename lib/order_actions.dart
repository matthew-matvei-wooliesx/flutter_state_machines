import 'order.dart';

abstract class OrderActions {
  final Order? _optionalOrder;

  const OrderActions._({required Order? optionalOrder})
      : _optionalOrder = optionalOrder;

  static Iterable<OrderAction> from(
    Order? optionalOrder, {
    required OrderActionsCallbacks callbacks,
  }) {
    return DefaultOrderActions._(newOrder: callbacks._newOrder)._actions;
  }

  Iterable<OrderAction> get _actions =>
      [_newOrderAction, if (_optionalOrder != null) ...[]];

  OrderAction get _newOrderAction;
}

class DefaultOrderActions extends OrderActions {
  final void Function() _newOrder;

  const DefaultOrderActions._({
    required void Function() newOrder,
  })  : _newOrder = newOrder,
        super._(optionalOrder: null);

  @override
  OrderAction get _newOrderAction => OrderAction._(
        label: "New",
        callback: _newOrder,
      );
}

class OrderActionsCallbacks {
  final void Function() _newOrder;
  final void Function() _startOrder;

  const OrderActionsCallbacks({
    required void Function() newOrder,
    required void Function() startOrder,
    required void Function() arriveOrder,
    required void Function() completeOrder,
  })  : _newOrder = newOrder,
        _startOrder = startOrder;
}

class OrderAction {
  final String label;
  final void Function()? _callback;

  const OrderAction._({required this.label, required void Function()? callback})
      : _callback = callback;

  bool get callable => _callback != null;

  void call() {
    if (callable) {
      _callback!();
    }
  }
}
