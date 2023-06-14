import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth/service_charechteristic_list.dart';

class DeviceDetailsScreen extends StatefulWidget {
  final BluetoothDevice device;

  const DeviceDetailsScreen({super.key, required this.device});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<BluetoothService>> getBluServ() async {
    List<BluetoothService> services = await widget.device.discoverServices();

    return services;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<BluetoothService>>(
        future: getBluServ(),
        builder: (context, snap) {
          if (snap.hasData) {
            List<BluetoothService>? services = snap.data;
            return ListView.separated(
                itemBuilder: (context, index) {
                  BluetoothService bluetoothService = services![index];

                  return ListTile(
                    title: Text("$bluetoothService"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ServiseCharect(
                                  carect: bluetoothService.characteristics,
                                ))),
                  );
                },
                separatorBuilder: (context, int) {
                  return const Divider(
                    height: 5,
                    color: Colors.red,
                  );
                },
                itemCount: services!.length);
          }
          return Center(child: const CircularProgressIndicator());
        },
      ),
    );
  }
}
