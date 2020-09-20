#import "ModelRendererPlugin.h"
#if __has_include(<model_renderer/model_renderer-Swift.h>)
#import <model_renderer/model_renderer-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "model_renderer-Swift.h"
#endif

@implementation ModelRendererPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftModelRendererPlugin registerWithRegistrar:registrar];
}
@end
