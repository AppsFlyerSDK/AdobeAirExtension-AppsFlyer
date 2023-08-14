#import "FlashRuntimeExtensions.h"

#import <UIKit/UIKit.h>
#import <AppsFlyerLib/AppsFlyerLib.h>

FOUNDATION_EXPORT NSString *const EXTENSION_TYPE;

@interface  AppsFlyerAIRExtension : NSObject <UIApplicationDelegate>
+ (NSDictionary*) convertFromJSonString:(NSString*)jsonString;
+ (NSString*) convertToJSonString:(NSDictionary*)data;
+ (NSString*) getString:(FREObject*)value;
+ (void) dispatchStatusEvent:(FREContext) ctx withType: (NSString*) eventType level: (NSString*) eventLevel;
+ (NSData *)dataFromHexString:(NSString *)string;
@end

typedef void (^ RestorationHandler)(NSArray*);
