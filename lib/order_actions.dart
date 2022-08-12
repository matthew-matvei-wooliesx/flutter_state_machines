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
      return _DefaultOrderActions._(
        optionalOrder: null,
        newOrder: callbacks._newOrder,
      )._actions;
    } else {
      switch (optionalOrder.status) {
        case "pending":
          return _NewOrderActions._(
            order: optionalOrder,
            newOrder: callbacks._newOrder,
            startOrder: callbacks._startOrder,
          )._actions;
        case "en route":
          return _EnRouteOrderActions._(
            order: optionalOrder,
            newOrder: callbacks._newOrder,
            arriveOrder: callbacks._arriveOrder,
          )._actions;
        case "arrived":
          return _ArrivedOrderActions._(
            order: optionalOrder,
            newOrder: callbacks._newOrder,
            completeOrder: callbacks._completeOrder,
          )._actions;
        case "complete":
          return _CompletedOrderActions._(
            order: optionalOrder,
            newOrder: callbacks._newOrder,
          )._actions;
        default:
          throw ArgumentError.value(
            optionalOrder.status,
            "optionalOrder",
            "Unrecognised order status",
          );
      }
    }
  }

  Iterable<OrderAction> get _actions sync* {
    yield _newOrderAction;

    if (_optionalOrder != null) {
      yield _startOrderAction;
      yield _arriveOrderAction;
      yield _completeOrderAction;
    }
  }

  OrderAction get _newOrderAction;
  OrderAction get _startOrderAction;
  OrderAction get _arriveOrderAction;
  OrderAction get _completeOrderAction;
}

class _DefaultOrderActions extends OrderActions {
  final void Function() _newOrder;

  const _DefaultOrderActions._({
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

  @override
  OrderAction get _arriveOrderAction => const OrderAction._(
        label: "Arrive",
        callback: null,
      );

  @override
  OrderAction get _completeOrderAction => const OrderAction._(
        label: "Complete",
        callback: null,
      );
}

class _NewOrderActions extends _DefaultOrderActions {
  final void Function() _startOrder;

  const _NewOrderActions._({
    required Order order,
    required Function() newOrder,
    required Function() startOrder,
  })  : _startOrder = startOrder,
        super._(
          optionalOrder: order,
          newOrder: newOrder,
        );

  @override
  OrderAction get _startOrderAction =>
      super._startOrderAction._withCallback(_startOrder);
}

class _EnRouteOrderActions extends _DefaultOrderActions {
  final void Function() _arriveOrder;

  const _EnRouteOrderActions._({
    required Order order,
    required void Function() newOrder,
    required void Function() arriveOrder,
  })  : _arriveOrder = arriveOrder,
        super._(optionalOrder: order, newOrder: newOrder);

  @override
  OrderAction get _arriveOrderAction =>
      super._arriveOrderAction._withCallback(_arriveOrder);
}

class _ArrivedOrderActions extends _DefaultOrderActions {
  final void Function() _completeOrder;

  const _ArrivedOrderActions._({
    required Order order,
    required void Function() newOrder,
    required void Function() completeOrder,
  })  : _completeOrder = completeOrder,
        super._(optionalOrder: order, newOrder: newOrder);

  @override
  OrderAction get _completeOrderAction =>
      super._completeOrderAction._withCallback(_completeOrder);
}

class _CompletedOrderActions extends _DefaultOrderActions {
  const _CompletedOrderActions._({
    required Order order,
    required void Function() newOrder,
  }) : super._(optionalOrder: order, newOrder: newOrder);
}

class OrderActionsCallbacks {
  final void Function() _newOrder;
  final void Function() _startOrder;
  final void Function() _arriveOrder;
  final void Function() _completeOrder;

  const OrderActionsCallbacks({
    required void Function() newOrder,
    required void Function() startOrder,
    required void Function() arriveOrder,
    required void Function() completeOrder,
  })  : _newOrder = newOrder,
        _startOrder = startOrder,
        _arriveOrder = arriveOrder,
        _completeOrder = completeOrder;
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

  OrderAction _withCallback(void Function() callback) => OrderAction._(
        label: label,
        callback: callback,
      );
}
