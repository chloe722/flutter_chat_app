import 'dart:async';
import 'dart:math';

import 'package:flash_chat/screens/device_screen.dart';
import 'package:flash_chat/widgets/bluetooth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return BluetoothScreen();
            }
            return BluetoothOffScreen(state: state);
          }),
    );
  }
}

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key key, this.state}) : super(key: key);

  final BluetoothState state;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.grey,
            ),
            Text(
              'Bluetooth Adapter is ${state.toString().substring(15)}.\n Please turn on Bluetooth on your device',
              style: Theme.of(context)
                  .primaryTextTheme
                  .subhead
                  .copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  static FlutterBlue flutterBlue;

  @override
  void initState() {
    flutterBlue = FlutterBlue.instance;
    super.initState();
  }

  void checkService(BluetoothDevice device) async {
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      print(service);
      // do something with service
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Bluetooth"),
      ),
      floatingActionButton: StreamBuilder<bool>(
          stream: flutterBlue.isScanning,
          initialData: false,
          builder: (context, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => flutterBlue.stopScan(),
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.bluetooth_searching),
                  onPressed: () {
                    flutterBlue.startScan(timeout: Duration(minutes: 1));
                  });
            }
          }),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 2))
                  .asyncMap((_) => flutterBlue.connectedDevices),
              initialData: [],
              builder: (context, snapshot) => Column(
                children: snapshot.data.map((d) {
                  print(' test data: ${snapshot.data}');
                  return ListTile(
                    title: Text(d.name),
                    subtitle: Text(d.id.toString()),
                    trailing: StreamBuilder<BluetoothDeviceState>(
                      stream: d.state,
                      initialData: BluetoothDeviceState.disconnected,
                      builder: (context, snapshot) {
                        print('connected ${snapshot.data}');
                        if (snapshot.data == BluetoothDeviceState.connected) {
                          return RaisedButton(
                            child: Text('Check'),
                            onPressed: () {
                              checkService(d);
                              return Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DeviceScreen(device: d)));
                            }
                          );
                        }
                        return Text(snapshot.data.toString());
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            StreamBuilder<List<ScanResult>>(
              stream: flutterBlue.scanResults,
              initialData: [],
              builder: (context, snapshot) {

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: snapshot.data.map((r) {
                    return ScanResultTile(
                      result: r,
                      onTap: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        r.device.connect();
                        return DeviceScreen(device: r.device);
                      })),
                    );
                  }).toList(),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
