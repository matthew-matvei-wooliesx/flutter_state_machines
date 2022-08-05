import 'order.dart';

abstract class OrderActions {
  const OrderActions._();

  static List<_Action> from(Order? optionalOrder) {
    throw UnimplementedError();
  }
}

class _Action {
  final String label;

  _Action({required this.label});
}
