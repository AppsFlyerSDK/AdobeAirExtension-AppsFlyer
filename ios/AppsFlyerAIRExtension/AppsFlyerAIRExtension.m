//  Created by Oren Baranes on 12/9/13.
//  Copyright (c) 2013 Oren Baranes. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "AppsFlyerTracker.h"
#import "AppsFlyerConversionDelegate.h"
#import "AppsFlyerAIRExtension.h"

#import <UIKit/UIApplication.h>

#import <objc/runtime.h>
#import <objc/message.h>


#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

@implementation AppsFlyerAIRExtension 

//empty delegate functions, stubbed signature is so we can find this method in the delegate
//and override it with our custom implementation
- (BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *_Nullable))restorationHandler{ return TRUE; }
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString*)sourceApplication annotation:(id)annotation{ return TRUE; }

+ (NSDictionary*) convertFromJSonString:(NSString*)jsonString
{
    NSError *jsonError = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if (jsonError != nil) {
        NSLog(@"[AppsFlyerAIRExtension] JSON to NSDictionnary error: %@", jsonError.localizedDescription);
        return NULL;
    }
    return json;
}

@end

BOOL continueUserActivity(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, RestorationHandler restorationHandler) {
    [[AppsFlyerTracker sharedTracker] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return YES;
}
BOOL openURL(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation) {
    [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication];
    return YES;
}

AdobeAirConversionDelegate * conversionDelegate;


NSString *const EXTENSION_TYPE = @"AIR";

DEFINE_ANE_FUNCTION(setDeveloperKey)
{
    uint32_t string1Length;
    const uint8_t *string1;
    FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
    NSString *developerKey = [NSString stringWithUTF8String:(char*)string1];
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = developerKey;

    uint32_t string2Length;
    const uint8_t *string2;
    FREGetObjectAsUTF8(argv[1], &string2Length, &string2);
    NSString *appId = [NSString stringWithUTF8String:(char*)string2];
    [AppsFlyerTracker sharedTracker].appleAppID = appId;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(trackAppLaunch)
{
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    return NULL;
}

//DEFINE_ANE_FUNCTION(sendTrackingWithEvent)
//{
//    
//    if(argv[0]!=NULL)
//    {
//        uint32_t string1Length;
//        const uint8_t *string1;
//        FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
//        NSString *eventName = [NSString stringWithUTF8String:(char*)string1];
//        
//        
//        uint32_t string2Length;
//        const uint8_t *string2;
//        FREGetObjectAsUTF8(argv[1], &string2Length, &string2);
//        NSString *eventValue = [NSString stringWithUTF8String:(char*)string2];
//        
//        [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValue:eventValue];
//    }
//    
//    return NULL;
//}

DEFINE_ANE_FUNCTION(trackEvent)
{
    
    if(argv[0]!=NULL)
    {
        uint32_t string1Length;
        const uint8_t *string1;
        FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
        NSString *eventName = [NSString stringWithUTF8String:(char*)string1];
        
        
        uint32_t string2Length;
        const uint8_t *string2;
        FREGetObjectAsUTF8(argv[1], &string2Length, &string2);
        NSString *eventValue = [NSString stringWithUTF8String:(char*)string2];
        
        NSError *jsonError;
        NSData *objectData = [eventValue dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *values = [NSJSONSerialization JSONObjectWithData:objectData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&jsonError];

        [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValues:values];
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setCurrency)
{
    uint32_t string1Length;
    const uint8_t *string1;
    FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
    NSString *currency = [NSString stringWithUTF8String:(char*)string1];
    [AppsFlyerTracker sharedTracker].currencyCode = currency;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setAppUserId)
{
    uint32_t string1Length;
    const uint8_t *value;
    FREGetObjectAsUTF8(argv[0], &string1Length, &value);
    NSString *appUserId = [NSString stringWithUTF8String:(char*)value];
    [AppsFlyerTracker sharedTracker].customerUserID = appUserId;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(getConversionData)
{
    [AppsFlyerTracker sharedTracker].delegate = conversionDelegate;
    return NULL;
}


DEFINE_ANE_FUNCTION(getAppsFlyerUID)
{
    FREObject uid = nil;
    NSString *value = (NSString *)[[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
    FRENewObjectFromUTF8(strlen((const char*)[value UTF8String]) + 1.0, (const uint8_t*)[value UTF8String], &uid);
    return uid;
}

DEFINE_ANE_FUNCTION(getAdvertiserId)
{
    FREObject id = nil;
    NSString *value = @"-1";
    FRENewObjectFromUTF8(strlen((const char*)[value UTF8String]) + 1.0, (const uint8_t*)[value UTF8String], &id);
    return id;
}

DEFINE_ANE_FUNCTION(getAdvertiserIdEnabled)
{
    FREObject res = nil;
    FRENewObjectFromBool(0, &res);
    return res;
}

DEFINE_ANE_FUNCTION(setDebug)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [AppsFlyerTracker sharedTracker].isDebug = value;
    return NULL;
}

DEFINE_ANE_FUNCTION(setCollectAndroidID)
{
    NSLog(@"setCollectAndroidID method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setCollectIMEI)
{
    NSLog(@"setCollectIMEI method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(handlePushNotification)
{
    uint32_t string1Length;
    const uint8_t *value;
    FREGetObjectAsUTF8(argv[0], &string1Length, &value);
    NSString *userInfoString = [NSString stringWithUTF8String:(char*)value];
    NSDictionary *userInfo = [AppsFlyerAIRExtension convertFromJSonString:userInfoString];
    //NSLog(@"handlePushNotification %@ userInfo %@", userInfoString, userInfo);
    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
    return NULL;
}

DEFINE_ANE_FUNCTION(registerConversionListener)
{
    NSLog(@"registerConversionListener method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setGCMProjectID)
{
    NSLog(@"setGCMProjectID method is not supported on iOS");
    return NULL;
}

//FREObject setExtension(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
//{
//    uint32_t string1Length;
//    const uint8_t *string1;
//    FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
//    NSString *extensionType = [NSString stringWithUTF8String:(char*)string1];
//    [AppsFlyerTracker sharedTracker].sdkExtension = extensionType;
//    return NULL;
//}


void AFExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    
    UIApplication *application = UIApplication.sharedApplication;
    //injects our modified delegate functions into the sharedApplication delegate
    id delegate = application.delegate;
    
    Class objectClass = object_getClass(delegate);
    
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class modDelegate = NSClassFromString(newClassName);
    
    if (modDelegate == nil) {
        // this class doesn't exist; create it
        // allocate a new class
        modDelegate = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        
        SEL selectorToOverride1 = @selector(application:continueUserActivity:restorationHandler:);
        
        SEL selectorToOverride2 = @selector(application:openURL:sourceApplication:annotation:);
        
        // get the info on the method we're going to override
        Method m1 = class_getInstanceMethod(objectClass, selectorToOverride1);
        Method m2 = class_getInstanceMethod(objectClass, selectorToOverride2);
        // add the method to the new class
        class_addMethod(modDelegate, selectorToOverride1, (IMP)continueUserActivity, method_getTypeEncoding(m1));
        class_addMethod(modDelegate, selectorToOverride2, (IMP)openURL, method_getTypeEncoding(m2));
        
        
        // register the new class with the runtime
        objc_registerClassPair(modDelegate);
    }
    // change the class of the object
    object_setClass(delegate, modDelegate);
    
    *numFunctionsToTest = 15;
    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*)"setDeveloperKey";
    func[0].functionData = NULL;
    func[0].function = &setDeveloperKey;
    
    func[1].name = (const uint8_t*)"trackAppLaunch";
    func[1].functionData = NULL;
    func[1].function = &trackAppLaunch;
    
//    func[2].name = (const uint8_t*)"sendTrackingWithEvent";
//    func[2].functionData = NULL;
//    func[2].function = &sendTrackingWithEvent;
    
    func[3].name = (const uint8_t*)"setCurrency";
    func[3].functionData = NULL;
    func[3].function = &setCurrency;
    
    func[4].name = (const uint8_t*)"setAppUserId";
    func[4].functionData = NULL;
    func[4].function = &setAppUserId;
    
    func[5].name = (const uint8_t*)"getConversionData";
    func[5].functionData = NULL;
    func[5].function = &getConversionData;
    
    func[6].name = (const uint8_t*)"getAppsFlyerUID";
    func[6].functionData = NULL;
    func[6].function = &getAppsFlyerUID;
    
    func[7].name = (const uint8_t*)"trackEvent";
    func[7].functionData = NULL;
    func[7].function = &trackEvent;
    
    func[8].name = (const uint8_t*)"setDebug";
    func[8].functionData = NULL;
    func[8].function = &setDebug;
    
    func[9].name = (const uint8_t*)"getAdvertiserId";
    func[9].functionData = NULL;
    func[9].function = &getAdvertiserId;
    
    func[10].name = (const uint8_t*)"getAdvertiserIdEnabled";
    func[10].functionData = NULL;
    func[10].function = &getAdvertiserIdEnabled;
    
    func[11].name = (const uint8_t*)"setCollectAndroidID";
    func[11].functionData = NULL;
    func[11].function = &setCollectAndroidID;
    
    func[12].name = (const uint8_t*)"setCollectIMEI";
    func[12].functionData = NULL;
    func[12].function = &setCollectIMEI;
    
    func[13].name = (const uint8_t*)"handlePushNotification";
    func[13].functionData = NULL;
    func[13].function = &handlePushNotification;
    
    func[2].name = (const uint8_t*)"registerConversionListener";
    func[2].functionData = NULL;
    func[2].function = &registerConversionListener;
    
    func[14].name = (const uint8_t*)"setGCMProjectID";
    func[14].functionData = NULL;
    func[14].function = &setGCMProjectID;
    
    *functionsToSet = func;
    
    conversionDelegate = [[AdobeAirConversionDelegate alloc] init];
    conversionDelegate.ctx = ctx;
    
    
}


void AFExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AFExtContextInitializer;
}

void AFExtensionFinalizer(FREContext ctx)
{
    return;
}














