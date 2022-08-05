import 'package:flutter/material.dart';

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
      home: ElevatedButton(onPressed: () {}, child: const Text("New")),
    );
  }
}
