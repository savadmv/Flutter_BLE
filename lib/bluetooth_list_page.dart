import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_bluetooth/devise_details_screen.dart';

class BluetoothListPage extends StatefulWidget {
  const BluetoothListPage({super.key});

  @override
  State<StatefulWidget> createState() => StateBluetoothListPage();
}

class StateBluetoothListPage extends State<BluetoothListPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<ScanResult>? scanRes;

  @override
  void initState() {
    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 10));

// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      setState(() {
        scanRes = results;
      });
      // do something with scan results
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    flutterBlue.startScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                flutterBlue.startScan(timeout: const Duration(seconds: 10));
              },
              child: const Text('Scan')),
        ],
      ),
      body: scanRes == null
          ? const Center(
              child: Text("Scanning.."),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.blue,
                  child: ListTile(
                    onTap: () {
                      var res = scanRes![index]
                          .device
                          .connect(
                            timeout: const Duration(minutes: 10),
                          )
                          .whenComplete(() => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeviceDetailsScreen(
                                      device: scanRes![index].device))));
                    },
                    title: Text(scanRes![index].device.name.isEmpty
                        ? scanRes![index].device.id.toString()
                        : scanRes![index].device.name),
                  ),
                );
              },
              itemCount: scanRes!.length,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                  height: 2,
                );
              },
            ),
    );
  }
}
