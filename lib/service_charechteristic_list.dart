import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ServiseCharect extends StatefulWidget {
  final List<BluetoothCharacteristic> carect;

  const ServiseCharect({super.key, required this.carect});

  @override
  State<ServiseCharect> createState() => _ServiseCharectState();
}

class _ServiseCharectState extends State<ServiseCharect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          itemBuilder: (context, index) {
            BluetoothCharacteristic cr = widget.carect[index];

            return ListTile(
              title: Text("$cr"),
            );
          },
          separatorBuilder: (context, int) {
            return const Divider(
              height: 5,
              color: Colors.red,
            );
          },
          itemCount: widget.carect.length),
    );
  }
}
