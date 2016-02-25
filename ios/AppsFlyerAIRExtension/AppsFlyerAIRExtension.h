//  Created by Admin on 24.07.14.
//  Copyright (c) 2014 Oren Baranes. All rights reserved.
//

#ifndef AdobeeAirExtensionIOS_AdobeeAirExtensionIOS_h
#define AdobeeAirExtensionIOS_AdobeeAirExtensionIOS_h

FOUNDATION_EXPORT NSString *const EXTENSION_TYPE;

#endif

#import <UIKit/UIKit.h>

@interface  AppsFlyerAIRExtension : NSObject <UIApplicationDelegate>
+ (NSDictionary*) convertFromJSonString:(NSString*)jsonString;
@end

typedef void (^ RestorationHandler)(NSArray*);

BOOL continueUserActivity(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, RestorationHandler restorationHandler);                    
BOOL openURL(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation);