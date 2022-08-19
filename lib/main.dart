import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_machines/order.dart';
import 'package:flutter_state_machines/order_actions.dart';

void main() {
  runApp(const OrderAdmin());
}

class OrderAdmin extends StatelessWidget {
  const OrderAdmin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Admin Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _OrderAdminPage(),
    );
  }
}

class _OrderAdminPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OrderAdminPageState();
}

class _OrderAdminPageState extends State<_OrderAdminPage> {
  Order? _order;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_order != null) ...[
          Row(
            children: [
              const Expanded(child: Text("Order")),
              Expanded(
                child: Text(_order!.id, key: const Key("OrderId")),
              )
            ],
          ),
          Row(
            children: [
              const Expanded(child: Text("Current ETA")),
              Expanded(
                  child: Text(
                _order!.eta.toString(),
                key: const Key("EtaDisplay"),
              )),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Update ETA"),
                ),
              )
            ],
          )
        ],
        ButtonBar(children: _orderActions()),
      ],
    );
  }

  List<Widget> _orderActions() => OrderActions.from(
        _order,
        callbacks: OrderActionsCallbacks(
          newOrder: _createNewOrder,
          startOrder: _startOrder,
          arriveOrder: _arriveOrder,
          completeOrder: () {},
        ),
      ).map(_actionToButton).toList();

  void _createNewOrder() {
    setState(() {
      _order = Order(eta: clock.hoursFromNow(6));
    });
  }

  void _startOrder() {
    setState(() {
      _order!.start();
    });
  }

  void _arriveOrder() {
    setState(() {
      _order!.arrive();
    });
  }
}

Widget _actionToButton(OrderAction action) => ElevatedButton(
      onPressed: action.callable ? () => action() : null,
      child: Text(action.label),
    );
