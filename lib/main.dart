import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_machines/order.dart';

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
        if (_order != null)
          Row(
            children: [
              const Expanded(child: Text("Order")),
              Expanded(
                child: Text(_order!.id, key: const Key("OrderId")),
              )
            ],
          ),
        ButtonBar(
          children: [
            ElevatedButton(onPressed: _createNewOrder, child: const Text("New"))
          ],
        ),
      ],
    );
  }

  void _createNewOrder() {
    setState(() {
      _order = Order(eta: clock.hoursFromNow(6));
    });
  }
}
