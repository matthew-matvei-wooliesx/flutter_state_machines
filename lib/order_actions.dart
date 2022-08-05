import 'order.dart';

class OrderActions {
  final void Function() _newOrder;

  const OrderActions._({required void Function() newOrder})
      : _newOrder = newOrder;

  static List<_Action> from(
    Order? optionalOrder, {
    required OrderActionsCallbacks callbacks,
  }) {
    if (optionalOrder == null) {
      return OrderActions._(newOrder: callbacks._newOrder)._actions;
    }

    throw UnimplementedError();
  }

  List<_Action> get _actions => [_newOrderAction];

  _Action get _newOrderAction => _Action(label: "New", callback: _newOrder);
}

class OrderActionsCallbacks {
  final void Function() _newOrder;

  const OrderActionsCallbacks({required void Function() newOrder})
      : _newOrder = newOrder;
}

class _Action {
  final String label;
  final void Function() _callback;

  const _Action({required this.label, required void Function() callback})
      : _callback = callback;

  void call() => _callback();
}
