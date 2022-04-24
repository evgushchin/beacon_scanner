
import 'dart:async';

import 'package:flutter/services.dart';

class BeaconScanner {
  static const MethodChannel _channel = MethodChannel('beacon_scanner');
  static const event_channel = EventChannel('beacon_scanner_stream');

  // 0 = no messages, 1 = only errors, 2 = all
  static int _debugLevel = 0;

  /// Set the message level value [value] for debugging purpose. 0 = no messages, 1 = errors, 2 = all
  static void setDebugLevel(int value) {
    _debugLevel = value;
  }

  // Send the message [msg] with the [msgDebugLevel] value. 1 = error, 2 = info
  static void printDebugMessage(String? msg, int msgDebugLevel) {
    if (_debugLevel >= msgDebugLevel) {
      print('beacons_plugin: $msg');
    }
  }

  static Future<void> startMonitoring() async {
    final String? result = await _channel.invokeMethod('startMonitoring');
    printDebugMessage(result, 2);
  }

  static Future<void> stopMonitoring() async {
    final String? result = await _channel.invokeMethod('stopMonitoring');
    printDebugMessage(result, 2);
  }

  static listenToBeacons(StreamController controller) async {
    event_channel.receiveBroadcastStream().listen((dynamic event) {
      printDebugMessage('Received: $event', 2);
      controller.add(event);
    }, onError: (dynamic error) {
      printDebugMessage('Received error: ${error.message}', 1);
    });
  }
}
