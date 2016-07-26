
#import "FlashRuntimeExtensions.h"
#import "AppsFlyerTracker.h"
#import "AppsFlyerConversionDelegate.h"
#import "AppsFlyerAIRExtension.h"

#import <UIKit/UIApplication.h>

#import <objc/runtime.h>
#import <objc/message.h>


#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

@implementation AppsFlyerAIRExtension 

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

static IMP __original_continueUserActivity_Imp;
BOOL continueUserActivity(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, RestorationHandler restorationHandler) {
    NSLog(@"continueUserActivity: %@", self);
    [[AppsFlyerTracker sharedTracker] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return ((BOOL(*)(id,SEL,UIApplication*,NSUserActivity*, RestorationHandler))__original_continueUserActivity_Imp)(self, _cmd, application, userActivity, restorationHandler);
}
static IMP __original_openURL_Imp;
BOOL openURL(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation) {
    NSLog(@"openURL: %@", self);
    [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    return ((BOOL(*)(id, SEL, UIApplication*, NSURL*, NSString*, id))__original_openURL_Imp)(self, _cmd, application, url, sourceApplication, annotation);
}

static IMP __original_didReceiveRemoteNotification_Imp;
BOOL didReceiveRemoteNotificationHandler(id self, SEL _cmd, UIApplication* application, NSDictionary* userInfo) {
    NSLog(@"didReceiveRemoteNotification: %@", self);
    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
    return ((BOOL(*)(id, SEL, UIApplication*, NSDictionary*))__original_didReceiveRemoteNotification_Imp)(self, _cmd, application, userInfo);
}

//static IMP __original_didRegisterForRemoteNotificationsWithDeviceToken_Imp;
//BOOL didRegisterForRemoteNotificationsWithDeviceTokenHandler(id self, SEL _cmd, UIApplication* application, NSData* deviceToken) {
//    [[AppsFlyerTracker sharedTracker] registerUninstall:deviceToken];
//    return ((BOOL(*)(id, SEL, UIApplication*, NSData*))__original_didRegisterForRemoteNotificationsWithDeviceToken_Imp)(self, _cmd, application, deviceToken);
//}


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

DEFINE_ANE_FUNCTION(registerUninstall)
{
//    // iOS8+ selector
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
//        
//        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//        
//        [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
//        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//        
//    } else { // iOS7 or less
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
//    }
    uint32_t string1Length;
    const uint8_t *string1;
    FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
    NSString *deviceTokenStr = [NSString stringWithUTF8String:(char*)string1];
    NSData *deviceToken = [deviceTokenStr dataUsingEncoding:NSUTF8StringEncoding];
    [[AppsFlyerTracker sharedTracker] registerUninstall:deviceToken];
    return nil;
}

DEFINE_ANE_FUNCTION(registerConversionListener)
{
    //NSLog(@"registerConversionListener method is not supported on iOS");
    [AppsFlyerTracker sharedTracker].delegate = conversionDelegate;
    return NULL;
}

DEFINE_ANE_FUNCTION(setCollectAndroidID)
{
    NSLog(@"setCollectAndroidID method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setAndroidIdData)
{
    NSLog(@"setAndroidIdData method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setImeiData)
{
    NSLog(@"setImeiData method is not supported on iOS");
    return NULL;
}



DEFINE_ANE_FUNCTION(setCollectIMEI)
{
    NSLog(@"setCollectIMEI method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setGCMProjectNumber)
{
    NSLog(@"setGCMProjectID method is not supported on iOS");
    return NULL;
}

void AFExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{

    UIApplication *application = UIApplication.sharedApplication;

    id delegate = application.delegate;
    
    Class objectClass = object_getClass(delegate);
    
    SEL originalContinueUserActivitySelector = @selector(application:continueUserActivity:restorationHandler:);
    SEL originalOpenURLSelector = @selector(application:openURL:options:);
    SEL originalDidReceiveRemoteNotificationSelector = @selector(application:didReceiveRemoteNotification:);
//    SEL originalDidRegisterForRemoteNotificationsWithDeviceTokenSelector = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
    
    Method originalContinueUserActivityMethod = class_getInstanceMethod(objectClass, originalContinueUserActivitySelector);
    Method originalOpenURLMethod = class_getInstanceMethod(objectClass, originalOpenURLSelector);
    Method originalDidReceiveRemoteNotificationMethod = class_getInstanceMethod(objectClass, originalDidReceiveRemoteNotificationSelector);
//    Method originalDidRegisterForRemoteNotificationsWithDeviceTokenMethod = class_getInstanceMethod(objectClass, originalDidRegisterForRemoteNotificationsWithDeviceTokenSelector);

    __original_continueUserActivity_Imp = method_setImplementation(originalContinueUserActivityMethod, (IMP)continueUserActivity);
    __original_openURL_Imp = method_setImplementation(originalOpenURLMethod, (IMP)openURL);
    __original_didReceiveRemoteNotification_Imp = method_setImplementation(originalDidReceiveRemoteNotificationMethod, (IMP)didReceiveRemoteNotificationHandler);
//    __original_didRegisterForRemoteNotificationsWithDeviceToken_Imp = method_setImplementation(originalDidRegisterForRemoteNotificationsWithDeviceTokenMethod, (IMP)didRegisterForRemoteNotificationsWithDeviceTokenHandler);
    
    *numFunctionsToTest = 18;
    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*)"setDeveloperKey";
    func[0].functionData = NULL;
    func[0].function = &setDeveloperKey;
    
    func[1].name = (const uint8_t*)"trackAppLaunch";
    func[1].functionData = NULL;
    func[1].function = &trackAppLaunch;
    
    func[2].name = (const uint8_t*)"registerConversionListener";
    func[2].functionData = NULL;
    func[2].function = &registerConversionListener;
    
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
    
    func[14].name = (const uint8_t*)"setGCMProjectNumber";
    func[14].functionData = NULL;
    func[14].function = &setGCMProjectNumber;
    
    func[15].name = (const uint8_t*)"registerUninstall";
    func[15].functionData = NULL;
    func[15].function = &registerUninstall;
    
    func[16].name = (const uint8_t*)"setAndroidIdData";
    func[16].functionData = NULL;
    func[16].function = &setAndroidIdData;
    
    func[17].name = (const uint8_t*)"setImeiData";
    func[17].functionData = NULL;
    func[17].function = &setImeiData;
    
    
    
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














