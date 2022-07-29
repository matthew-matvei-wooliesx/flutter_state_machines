class Order {
  OrderState get state => PendingOrder();
}

class PendingOrder implements OrderState {}

abstract class OrderState {}
