#import "BeaconScannerPlugin.h"
#if __has_include(<beacon_scanner/beacon_scanner-Swift.h>)
#import <beacon_scanner/beacon_scanner-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "beacon_scanner-Swift.h"
#endif

@implementation BeaconScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBeaconScannerPlugin registerWithRegistrar:registrar];
}
@end
