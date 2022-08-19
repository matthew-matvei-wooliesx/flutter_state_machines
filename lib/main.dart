import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_state_machines/date_time_picker.dart';
import 'package:flutter_state_machines/order.dart';
import 'package:flutter_state_machines/order_actions.dart';
import 'package:flutter_state_machines/order_eta.dart';

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
    return ListView(
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
        ..._etaSection(),
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

  Iterable<Widget> _etaSection() sync* {
    final eta = OrderEta.from(_order);

    if (eta.current != null) {
      yield eta._renderDisplay();

      if (eta.canBeUpdated) {
        yield eta._renderUpdateButton(updateOrderEta: (etaDifference) {
          setState(() {
            _order!.updateEtaBy(etaDifference);
          });
        });
      }
    }
  }
}

Widget _actionToButton(OrderAction action) => ElevatedButton(
      onPressed: action.callable ? () => action() : null,
      child: Text(action.label),
    );

extension _EtaRendering on OrderEta {
  Widget _renderDisplay() => Row(
        children: [
          const Expanded(child: Text("Current ETA")),
          Expanded(
              child: Text(
            current.toString(),
            key: const Key("EtaDisplay"),
          )),
        ],
      );

  Widget _renderUpdateButton({
    required void Function(Duration etaUpdate) updateOrderEta,
  }) =>
      Row(
        children: [
          Expanded(
            child: Consumer(
              builder: (_, ref, __) => ElevatedButton(
                child: const Text("Update ETA"),
                onPressed: () async {
                  final newEta = await ref.read(dateTimePickerProvider).call();

                  final etaDifference = newEta?.difference(current!);

                  if (etaDifference != null) {
                    updateOrderEta(etaDifference);
                  }
                },
              ),
            ),
          ),
        ],
      );
}
