import 'order.dart';

class OrderActions {
  const OrderActions._();

  static List<_Action> from(Order? optionalOrder) {
    if (optionalOrder == null) {
      return const OrderActions._()._actions;
    }

    throw UnimplementedError();
  }

  List<_Action> get _actions => [_newOrderAction];

  _Action get _newOrderAction => const _Action(label: "New");
}

class _Action {
  final String label;

  const _Action({required this.label});
}
