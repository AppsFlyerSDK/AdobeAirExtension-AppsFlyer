
#import "FlashRuntimeExtensions.h"
#import "AppsFlyerTracker.h"
#import "AppsFlyerDelegate.h"
#import "AppsFlyerAIRExtension.h"

#import <UIKit/UIApplication.h>
#import <UserNotifications/UserNotifications.h>

#import <objc/runtime.h>
#import <objc/message.h>


#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

@implementation AppsFlyerAIRExtension 

+ (NSDictionary*) convertFromJSonString:(NSString*)jsonString
{
    NSError *error = nil;
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error != nil) {
        NSLog(@"[AppsFlyerAIRExtension] JSON to NSDictionnary error: %@", error.localizedDescription);
        return NULL;
    }
    return json;
}

+ (NSString*) convertToJSonString:(NSDictionary*)data
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error != nil) {
        NSLog(@"[AppsFlyerAIRExtension] NSDictionnary to JSON error: %@", error.localizedDescription);
        return @"";
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString*) getString:(FREObject*)value {
    uint32_t stringLength;
    const uint8_t *string;
    FREGetObjectAsUTF8(value, &stringLength, &string);
    return [NSString stringWithUTF8String:(char*)string];
}

+ (void) dispatchStatusEvent:(FREContext) ctx withType: (NSString*) eventType level: (NSString*) eventLevel {
    const uint8_t* levelCode = (const uint8_t*) [eventLevel UTF8String];
    const uint8_t* eventCode = (const uint8_t*) [eventType UTF8String];
    FREDispatchStatusEventAsync(ctx,eventCode,levelCode);
}

+ (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}

+ (void) sendLaunch:(UIApplication *)application {
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

@end

// Reports app open from a Universal Link for iOS 9
static IMP __original_continueUserActivity_Imp;
BOOL continueUserActivity(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, RestorationHandler restorationHandler) {
    NSLog(@"continueUserActivity: %@", self);
    [[AppsFlyerTracker sharedTracker] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return ((BOOL(*)(id,SEL,UIApplication*,NSUserActivity*, RestorationHandler))__original_continueUserActivity_Imp)(self, _cmd, application, userActivity, restorationHandler);
}
// Reports app open from deeplink for iOS 8 or below (DEPRECATED)
static IMP __original_openURLDeprecated_Imp;
BOOL openURLDeprecated(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation) {
    NSLog(@"openURL: %@", self);
    [[AppsFlyerTracker sharedTracker] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    return ((BOOL(*)(id, SEL, UIApplication*, NSURL*, NSString*, id))__original_openURLDeprecated_Imp)(self, _cmd, application, url, sourceApplication, annotation);
}
// Reports app open from deeplink for iOS 10
static IMP __original_openURL_Imp;
BOOL openURL(id self, SEL _cmd, UIApplication* application, NSURL* url, NSDictionary * options) {
    [[AppsFlyerTracker sharedTracker] handleOpenUrl:url options:options];
    return ((BOOL(*)(id, SEL, UIApplication*, NSURL*, NSDictionary*))__original_openURL_Imp)(self, _cmd, application, url, options);
}

static IMP __original_didReceiveRemoteNotification_Imp;
BOOL didReceiveRemoteNotificationHandler(id self, SEL _cmd, UIApplication* application, NSDictionary* userInfo) {
    NSLog(@"didReceiveRemoteNotification: %@", self);
    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
    return ((BOOL(*)(id, SEL, UIApplication*, NSDictionary*))__original_didReceiveRemoteNotification_Imp)(self, _cmd, application, userInfo);
}

AppsFlyerDelegate * conversionDelegate;

DEFINE_ANE_FUNCTION(init)
{
    NSString *developerKey = [AppsFlyerAIRExtension getString: argv[0]];
    NSString *appId = [AppsFlyerAIRExtension getString: argv[1]];
   
    [AppsFlyerTracker sharedTracker].appsFlyerDevKey = developerKey;
    [AppsFlyerTracker sharedTracker].appleAppID = appId;
    return NULL;
}

DEFINE_ANE_FUNCTION(startTracking)
{
    // Creating an observer to track background-foreground transitions
    UIApplication *application = UIApplication.sharedApplication;
    [[NSNotificationCenter defaultCenter] addObserver:application //or self? -> not sure if we can have access to the application (UIApplication) instance here.
    selector:@selector(sendLaunch:)
    name:UIApplicationDidBecomeActiveNotification
    object:nil];
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

DEFINE_ANE_FUNCTION(stopTracking)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [AppsFlyerTracker sharedTracker].isStopTracking = value;
    return NULL;
}

DEFINE_ANE_FUNCTION(isTrackingStopped)
{
    FREObject result = nil;
    uint32_t isStoppedTracking = [[AppsFlyerTracker sharedTracker] isStopTracking];
    FRENewObjectFromBool(isStoppedTracking, &result);
    return result;
}

DEFINE_ANE_FUNCTION(trackAppLaunch)
{
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    return NULL;
}

DEFINE_ANE_FUNCTION(trackEvent)
{
    if(argv[0] != NULL) {
        NSString *eventName = [AppsFlyerAIRExtension getString: argv[0]];
        NSString *eventValue = [AppsFlyerAIRExtension getString: argv[1]];
        NSDictionary *values = [AppsFlyerAIRExtension convertFromJSonString:eventValue];
        
        [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValues:values];
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setCurrency)
{
    NSString *currency = [AppsFlyerAIRExtension getString: argv[0]];
    
    [AppsFlyerTracker sharedTracker].currencyCode = currency;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setAppUserId)
{
    NSString *appUserId = [AppsFlyerAIRExtension getString: argv[0]];
    
    [AppsFlyerTracker sharedTracker].customerUserID = appUserId;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setUserEmails)
{
    FREObject arr = argv[0];
    uint32_t arr_len;
    FREGetArrayLength(arr, &arr_len);
    NSMutableArray *emails = [[NSMutableArray alloc] init];
    for(int32_t i=arr_len-1; i>=0;i--){
        FREObject element;
        FREGetArrayElementAt(arr, i, &element);
        [emails addObject: [AppsFlyerAIRExtension getString: element]];
    }
    
    [[AppsFlyerTracker sharedTracker] setUserEmails:emails withCryptType:EmailCryptTypeSHA1];
    return NULL;
}

DEFINE_ANE_FUNCTION(setResolveDeepLinkURLs)
{
    FREObject arr = argv[0];
    uint32_t arr_len;
    FREGetArrayLength(arr, &arr_len);
    NSMutableArray *urls = [[NSMutableArray alloc] init];
    for(int32_t i=arr_len-1; i>=0;i--){
        FREObject element;
        FREGetArrayElementAt(arr, i, &element);
        [urls addObject: [AppsFlyerAIRExtension getString: element]];
    }
    
    [[AppsFlyerTracker sharedTracker] setResolveDeepLinkURLs:urls];
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

DEFINE_ANE_FUNCTION(setDebug)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [AppsFlyerTracker sharedTracker].isDebug = value;
    return NULL;
}

DEFINE_ANE_FUNCTION(handlePushNotification)
{
    NSString *userInfoString = [AppsFlyerAIRExtension getString: argv[0]];
    NSDictionary *userInfo = [AppsFlyerAIRExtension convertFromJSonString:userInfoString];

    [[AppsFlyerTracker sharedTracker] handlePushNotification:userInfo];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(registerUninstall)
{
    NSString *deviceTokenStr = [AppsFlyerAIRExtension getString: argv[0]];
    NSData *deviceToken = [AppsFlyerAIRExtension dataFromHexString:deviceTokenStr];
    [[AppsFlyerTracker sharedTracker] registerUninstall:deviceToken];
    return NULL;
}

DEFINE_ANE_FUNCTION(registerConversionListener)
{
    [AppsFlyerTracker sharedTracker].delegate = conversionDelegate;
    return NULL;
}

DEFINE_ANE_FUNCTION(validateAndTrackInAppPurchase)
{

    NSString *productIdentifier = [AppsFlyerAIRExtension getString: argv[0]];
    NSString *transactionIdentifier = [AppsFlyerAIRExtension getString: argv[1]];

    NSString *price = [AppsFlyerAIRExtension getString: argv[3]];
    NSString *currency = [AppsFlyerAIRExtension getString: argv[4]];
    NSDictionary *params = [NSMutableDictionary dictionary];
    NSString *additionalParameters = [AppsFlyerAIRExtension getString: argv[5]];
    if(additionalParameters.length > 0) {
        params = [AppsFlyerAIRExtension convertFromJSonString:additionalParameters];
    }
    
    [[AppsFlyerTracker sharedTracker] validateAndTrackInAppPurchase:productIdentifier
                                                              price:price
                                                           currency:currency
                                                      transactionId:transactionIdentifier
                                               additionalParameters:params
                                                            success:^(NSDictionary *result){
                                                                NSString* res = @"";
                                                                if (result != nil) {
                                                                    if([result objectForKey:@"receipt"] != nil) {
                                                                        res = [AppsFlyerAIRExtension convertToJSonString: result[@"receipt"]];
                                                                    } else {
                                                                        res = [AppsFlyerAIRExtension convertToJSonString: result];
                                                                    }
                                                                }                                                                [AppsFlyerAIRExtension dispatchStatusEvent: conversionDelegate.ctx withType: @"validateInApp" level:res];
                                                            } failure:^(NSError *error, id response) {
                                                                NSString *errorString = [NSString stringWithFormat:@"%@", response];
                                                                
                                                                [AppsFlyerAIRExtension dispatchStatusEvent: conversionDelegate.ctx withType: @"validateInAppFailure" level:errorString];
                                                            }];
    return NULL;
}

DEFINE_ANE_FUNCTION(useReceiptValidationSandbox)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [AppsFlyerTracker sharedTracker].useReceiptValidationSandbox = value;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(sendDeepLinkData)
{
    NSLog(@"sendDeepLinkData method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(registerValidatorListener)
{
    NSLog(@"registerValidatorListener method is not supported on iOS");
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

DEFINE_ANE_FUNCTION(waitForCustomerUserId)
{
    NSLog(@"waitForCustomerUserId method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setCustomerIdAndTrack)
{
    NSLog(@"setCustomerIdAndTrack method is not supported on iOS");
    return NULL;
}

void AFExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{

    UIApplication *application = UIApplication.sharedApplication;

    id delegate = application.delegate;
    
    Class objectClass = object_getClass(delegate);
    
    SEL originalContinueUserActivitySelector = @selector(application:continueUserActivity:restorationHandler:);
    SEL originalOpenURLDeprecatedSelector = @selector(application:openURL:sourceApplication:annotation:);
    SEL originalOpenURLSelector = @selector(application:openURL:options:);
    SEL originalDidReceiveRemoteNotificationSelector = @selector(application:didReceiveRemoteNotification:);
    
    Method originalContinueUserActivityMethod = class_getInstanceMethod(objectClass, originalContinueUserActivitySelector);
    Method originalOpenURLDeprecatedMethod = class_getInstanceMethod(objectClass, originalOpenURLDeprecatedSelector);
    Method originalOpenURLMethod = class_getInstanceMethod(objectClass, originalOpenURLSelector);
    Method originalDidReceiveRemoteNotificationMethod = class_getInstanceMethod(objectClass, originalDidReceiveRemoteNotificationSelector);

    __original_continueUserActivity_Imp = method_setImplementation(originalContinueUserActivityMethod, (IMP)continueUserActivity);
    __original_openURLDeprecated_Imp = method_setImplementation(originalOpenURLDeprecatedMethod, (IMP)openURLDeprecated);
    __original_openURL_Imp = method_setImplementation(originalOpenURLMethod, (IMP)openURL);
    __original_didReceiveRemoteNotification_Imp = method_setImplementation(originalDidReceiveRemoteNotificationMethod, (IMP)didReceiveRemoteNotificationHandler);
    
    *numFunctionsToTest = 26;
    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[19].name = (const uint8_t*)"init";
    func[19].functionData = NULL;
    func[19].function = &startTracking;
    
    func[20].name = (const uint8_t*)"stopTracking";
    func[20].functionData = NULL;
    func[20].function = &stopTracking;
    
    func[21].name = (const uint8_t*)"isTrackingStopped";
    func[21].functionData = NULL;
    func[21].function = &isTrackingStopped;
    
    func[22].name = (const uint8_t*)"setUserEmails";
    func[22].functionData = NULL;
    func[22].function = &setUserEmails;
    
    func[23].name = (const uint8_t*)"waitForCustomerUserId";
    func[23].functionData = NULL;
    func[23].function = &waitForCustomerUserId;
    
    func[24].name = (const uint8_t*)"setCustomerIdAndTrack";
    func[24].functionData = NULL;
    func[24].function = &setCustomerIdAndTrack;
    
    func[25].name = (const uint8_t*)"setResolveDeepLinkURLs";
    func[25].functionData = NULL;
    func[25].function = &setResolveDeepLinkURLs;
    
    func[0].name = (const uint8_t*)"startTracking";
    func[0].functionData = NULL;
    func[0].function = &startTracking;
    
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
    
    func[9].name = (const uint8_t*)"registerValidatorListener";
    func[9].functionData = NULL;
    func[9].function = &registerValidatorListener;
    
    func[10].name = (const uint8_t*)"useReceiptValidationSandbox";
    func[10].functionData = NULL;
    func[10].function = &useReceiptValidationSandbox;
    
    func[11].name = (const uint8_t*)"setCollectAndroidID";
    func[11].functionData = NULL;
    func[11].function = &setCollectAndroidID;
    
    func[12].name = (const uint8_t*)"setCollectIMEI";
    func[12].functionData = NULL;
    func[12].function = &setCollectIMEI;
    
    func[13].name = (const uint8_t*)"handlePushNotification";
    func[13].functionData = NULL;
    func[13].function = &handlePushNotification;
    
    func[14].name = (const uint8_t*)"sendDeepLinkData";
    func[14].functionData = NULL;
    func[14].function = &sendDeepLinkData;
    
    func[15].name = (const uint8_t*)"registerUninstall";
    func[15].functionData = NULL;
    func[15].function = &registerUninstall;
    
    func[16].name = (const uint8_t*)"setAndroidIdData";
    func[16].functionData = NULL;
    func[16].function = &setAndroidIdData;
    
    func[17].name = (const uint8_t*)"setImeiData";
    func[17].functionData = NULL;
    func[17].function = &setImeiData;
    
    func[18].name = (const uint8_t*)"validateAndTrackInAppPurchase";
    func[18].functionData = NULL;
    func[18].function = &validateAndTrackInAppPurchase;
    
    *functionsToSet = func;
    
    conversionDelegate = [[AppsFlyerDelegate alloc] init];
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














