import 'order.dart';

abstract class OrderActions {
  final Order? _optionalOrder;

  const OrderActions._({required Order? optionalOrder})
      : _optionalOrder = optionalOrder;

  static Iterable<OrderAction> from(
    Order? optionalOrder, {
    required OrderActionsCallbacks callbacks,
  }) {
    if (optionalOrder == null) {
      return DefaultOrderActions._(
        optionalOrder: null,
        newOrder: callbacks._newOrder,
      )._actions;
    } else {
      switch (optionalOrder.status) {
        case "pending":
          return NewOrderActions._(
            order: optionalOrder,
            newOrder: callbacks._newOrder,
            startOrder: callbacks._startOrder,
          )._actions;
        default:
          throw ArgumentError.value(
            optionalOrder,
            "optionalOrder",
            "Unrecognised order status",
          );
      }
    }
  }

  Iterable<OrderAction> get _actions => [
        _newOrderAction,
        if (_optionalOrder != null) ...[_startOrderAction]
      ];

  OrderAction get _newOrderAction;
  OrderAction get _startOrderAction;
}

class DefaultOrderActions extends OrderActions {
  final void Function() _newOrder;

  const DefaultOrderActions._({
    required Order? optionalOrder,
    required void Function() newOrder,
  })  : _newOrder = newOrder,
        super._(optionalOrder: optionalOrder);

  @override
  OrderAction get _newOrderAction => OrderAction._(
        label: "New",
        callback: _newOrder,
      );

  @override
  OrderAction get _startOrderAction => const OrderAction._(
        label: "Start",
        callback: null,
      );
}

class NewOrderActions extends DefaultOrderActions {
  final void Function() _startOrder;

  const NewOrderActions._({
    required Order order,
    required Function() newOrder,
    required Function() startOrder,
  })  : _startOrder = startOrder,
        super._(
          optionalOrder: order,
          newOrder: newOrder,
        );

  @override
  OrderAction get _startOrderAction => OrderAction._(
        label: "Start",
        callback: _startOrder,
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
