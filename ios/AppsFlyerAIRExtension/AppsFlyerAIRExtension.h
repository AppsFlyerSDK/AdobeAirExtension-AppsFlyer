
#ifndef AdobeeAirExtensionIOS_AdobeeAirExtensionIOS_h
#define AdobeeAirExtensionIOS_AdobeeAirExtensionIOS_h

FOUNDATION_EXPORT NSString *const EXTENSION_TYPE;

#endif

#import <UIKit/UIKit.h>

@interface  AppsFlyerAIRExtension : NSObject <UIApplicationDelegate>
+ (NSDictionary*) convertFromJSonString:(NSString*)jsonString;
@end

typedef void (^ RestorationHandler)(NSArray*);