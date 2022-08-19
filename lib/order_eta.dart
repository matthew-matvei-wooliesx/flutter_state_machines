import 'order.dart';

abstract class OrderEta {
  const OrderEta();

  static OrderEta from(Order? optionalOrder) {
    if (optionalOrder == null) {
      return const _NoOrderEta();
    }

    throw UnimplementedError();
  }

  DateTime? get currentEta;
  void Function(DateTime newEta)? get etaUpdater;
}

class _NoOrderEta extends OrderEta {
  const _NoOrderEta();

  @override
  DateTime? get currentEta => null;

  @override
  void Function(DateTime _)? get etaUpdater => null;
}
