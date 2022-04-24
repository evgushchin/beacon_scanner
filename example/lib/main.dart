import 'package:flutter/material.dart';
import 'dart:async';

import 'package:beacon_scanner/beacon_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final StreamController<String> _beaconEventsController = StreamController<String>.broadcast();

  @override
  void initState() {
    super.initState();
    _init();
  }

  ///
  /// Init
  Future<void> _init() async {
    BeaconScanner.setDebugLevel(2);
    BeaconScanner.listenToBeacons(_beaconEventsController);

    _beaconEventsController.stream.listen(
      (data) {
        print("Beacons DataReceived: " + data);
      },
      onError: (error) {
        debugPrint("[Beacon Service][Monitoring] Error: $error");
      },
    );

    await BeaconScanner.startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running.. Check console'),
        ),
      ),
    );
  }
}
