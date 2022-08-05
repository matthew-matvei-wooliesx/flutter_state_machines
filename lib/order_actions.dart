import 'order.dart';

class OrderActions {
  final void Function() _newOrder;

  const OrderActions._({required void Function() newOrder})
      : _newOrder = newOrder;

  static List<OrderAction> from(
    Order? optionalOrder, {
    required OrderActionsCallbacks callbacks,
  }) {
    return OrderActions._(newOrder: callbacks._newOrder)._actions;
  }

  List<OrderAction> get _actions => [_newOrderAction];

  OrderAction get _newOrderAction => OrderAction._(
        label: "New",
        callback: _newOrder,
      );
}

class OrderActionsCallbacks {
  final void Function() _newOrder;

  const OrderActionsCallbacks({required void Function() newOrder})
      : _newOrder = newOrder;
}

class OrderAction {
  final String label;
  final void Function() _callback;

  const OrderAction._({required this.label, required void Function() callback})
      : _callback = callback;

  void call() => _callback();
}
