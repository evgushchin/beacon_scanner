import Flutter
import UIKit
import BeaconKit

public class SwiftBeaconScannerPlugin: NSObject, FlutterPlugin {
    var eventSink: FlutterEventSink?
    
    init(eventSink: FlutterEventSink?) {
        self.eventSink = eventSink
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "beacon_scanner", binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: "beacon_scanner_stream", binaryMessenger: registrar.messenger())
        let eventHandler = EventsStreamHandler(channel: channel, registrar: registrar)
        eventChannel.setStreamHandler(eventHandler)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "startMonitoring"{
            BeaconScanner.shared.delegate = self
            BeaconScanner.shared.recognizedBeaconTypes = [iBeacon.self]
            BeaconScanner.shared.start()
            result("Started scanning Beacons.")
        } else if call.method == "stopMonitoring"{
            BeaconScanner.shared.stop()
            result("Stopped scanning Beacons.")
        } else {
            result("Flutter method not implemented on iOS")
        }
    }
}


// MARK: BeaconScannerDelegate
extension SwiftBeaconScannerPlugin: BeaconScannerDelegate {
    
    public func beaconScanner(_ beaconScanner: BeaconScanner, didDiscover beacon: Beacon) {
        let data = "{\n" +
            "  \"uuid\": \"\(beacon.identifier)\",\n" +
            "  \"txPower\": \"\(beacon.txPower)\",\n" +
            "  \"rssi\": \"\(beacon.rssi)\",\n" +
            "  \"distanceMeters\": \"\(beacon.distanceMeters)\",\n" +
            "  \"identifier\": \"\(beacon.identifiers[0])\",\n" +
            "  \"minor\": \"\(beacon.identifiers[1])\",\n" +
            "  \"major\": \"\(beacon.identifiers[2])\",\n" +
        "}"
        eventSink?("\(data)")
    }
}


class EventsStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    private var fChannel:FlutterMethodChannel
    private var fRegistrar: FlutterPluginRegistrar?
    
    init(channel:FlutterMethodChannel,registrar: FlutterPluginRegistrar) {
        self.fChannel = channel
        self.fRegistrar = registrar
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        let instance = SwiftBeaconScannerPlugin(eventSink: eventSink)
        fRegistrar?.addMethodCallDelegate(instance, channel: fChannel)
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }
}
