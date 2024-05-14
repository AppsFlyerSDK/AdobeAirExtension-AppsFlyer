#import "AppsFlyerDelegate.h"
#import "AppsFlyerAIRExtension.h"

#import <UserNotifications/UserNotifications.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#import <objc/runtime.h>
#import <objc/message.h>


#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

@implementation AppsFlyerAIRExtension

static IMP __original_applicationDidBecomeActive_Imp;
void applicationDidBecomeActive(id self, SEL _cmd, UIApplication* application) {
    NSLog(@"[AppsFlyerAIRExtension] applicationDidBecomeActive: %@", self);
    return ((void(*)(id, SEL, UIApplication*))__original_applicationDidBecomeActive_Imp)(self, _cmd, application);
}

// Reports app open from a Universal Link for iOS 9
static IMP __original_continueUserActivity_Imp;
BOOL continueUserActivity(id self, SEL _cmd, UIApplication* application, NSUserActivity* userActivity, RestorationHandler restorationHandler) {
    NSLog(@"[AppsFlyerAIRExtension] continueUserActivity: %@", self);
    [[AppsFlyerLib shared] continueUserActivity:userActivity restorationHandler:restorationHandler];
    return ((BOOL(*)(id,SEL,UIApplication*,NSUserActivity*, RestorationHandler))__original_continueUserActivity_Imp)(self, _cmd, application, userActivity, restorationHandler);
}
// Reports app open from deeplink for iOS 8 or below (DEPRECATED)
static IMP __original_openURLDeprecated_Imp;
BOOL openURLDeprecated(id self, SEL _cmd, UIApplication* application, NSURL* url, NSString* sourceApplication, id annotation) {
    NSLog(@"[AppsFlyerAIRExtension] openURLDeprecated: %@", self);
    [[AppsFlyerLib shared] handleOpenURL:url sourceApplication:sourceApplication withAnnotation:annotation];
    return ((BOOL(*)(id, SEL, UIApplication*, NSURL*, NSString*, id))__original_openURLDeprecated_Imp)(self, _cmd, application, url, sourceApplication, annotation);
}
// Reports app open from deeplink for iOS 10
static IMP __original_openURL_Imp;
BOOL openURL(id self, SEL _cmd, UIApplication* application, NSURL* url, NSDictionary * options) {
    NSLog(@"[AppsFlyerAIRExtension] openURL: %@", self);
    [[AppsFlyerLib shared] handleOpenUrl:url options:options];
    return ((BOOL(*)(id, SEL, UIApplication*, NSURL*, NSDictionary*))__original_openURL_Imp)(self, _cmd, application, url, options);
}

static IMP __original_didReceiveRemoteNotification_Imp;
BOOL didReceiveRemoteNotificationHandler(id self, SEL _cmd, UIApplication* application, NSDictionary* userInfo) {
    NSLog(@"[AppsFlyerAIRExtension] didReceiveRemoteNotification: %@", self);
    [[AppsFlyerLib shared] handlePushNotification:userInfo];
    return ((BOOL(*)(id, SEL, UIApplication*, NSDictionary*))__original_didReceiveRemoteNotification_Imp)(self, _cmd, application, userInfo);
}

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"[AppsFlyerAIRExtension] swizzling START");
        Class objectClass = NSClassFromString(@"CTAppController");
        if (!objectClass) {
            NSLog(@"[AppsFlyerAIRExtension] unable to swizzle CTAppController");
        } else {
            SEL originalApplicationDidBecomeActiveSelector = @selector(applicationDidBecomeActive:);
            SEL originalContinueUserActivitySelector = @selector(application:continueUserActivity:restorationHandler:);
            SEL originalOpenURLDeprecatedSelector = @selector(application:openURL:sourceApplication:annotation:);
            SEL originalOpenURLSelector = @selector(application:openURL:options:);
            SEL originalDidReceiveRemoteNotificationSelector = @selector(application:didReceiveRemoteNotification:);

            Method originalApplicationDidBecomeActiveMethod = class_getInstanceMethod(objectClass, originalApplicationDidBecomeActiveSelector);
            Method originalContinueUserActivityMethod = class_getInstanceMethod(objectClass, originalContinueUserActivitySelector);
            Method originalOpenURLDeprecatedMethod = class_getInstanceMethod(objectClass, originalOpenURLDeprecatedSelector);
            Method originalOpenURLMethod = class_getInstanceMethod(objectClass, originalOpenURLSelector);
            Method originalDidReceiveRemoteNotificationMethod = class_getInstanceMethod(objectClass, originalDidReceiveRemoteNotificationSelector);

            __original_applicationDidBecomeActive_Imp = method_setImplementation(originalApplicationDidBecomeActiveMethod, (IMP)applicationDidBecomeActive);
            __original_continueUserActivity_Imp = method_setImplementation(originalContinueUserActivityMethod, (IMP)continueUserActivity);
            __original_openURLDeprecated_Imp = method_setImplementation(originalOpenURLDeprecatedMethod, (IMP)openURLDeprecated);
            __original_openURL_Imp = method_setImplementation(originalOpenURLMethod, (IMP)openURL);
            __original_didReceiveRemoteNotification_Imp = method_setImplementation(originalDidReceiveRemoteNotificationMethod, (IMP)didReceiveRemoteNotificationHandler);
        }
    });
}

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

+ (int) getInt:(FREObject*)value {
    int32_t nativeInt = 0;
    FREGetObjectAsInt32(value, &nativeInt);
    return nativeInt;
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

@end

AppsFlyerDelegate * conversionDelegate;

DEFINE_ANE_FUNCTION(init)
{
    NSString *developerKey = [AppsFlyerAIRExtension getString: argv[0]];
    NSString *appId = [AppsFlyerAIRExtension getString: argv[1]];
    [[AppsFlyerLib shared] setPluginInfoWith:AFSDKPluginAdobeAir
                               pluginVersion:@"6.14.3"
                            additionalParams:nil];
    [AppsFlyerLib shared].appsFlyerDevKey = developerKey;
    [AppsFlyerLib shared].appleAppID = appId;

    return NULL;
}

DEFINE_ANE_FUNCTION(start)
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ {
        [[NSNotificationCenter defaultCenter] addObserver:conversionDelegate
                                                 selector:@selector(sendLaunch:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    });
    [[AppsFlyerLib shared] start];
    return NULL;
}

DEFINE_ANE_FUNCTION(stop)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [AppsFlyerLib shared].isStopped = value;
    return NULL;
}

DEFINE_ANE_FUNCTION(isStopped)
{
    FREObject result = nil;
    uint32_t isStopped = [[AppsFlyerLib shared] isStopped];
    FRENewObjectFromBool(isStopped, &result);
    return result;
}

DEFINE_ANE_FUNCTION(setOneLinkCustomDomain)
{
    FREObject arr = argv[0];
    uint32_t arr_len;
    FREGetArrayLength(arr, &arr_len);
    NSMutableArray *domains = [[NSMutableArray alloc] init];
    for(int32_t i=arr_len-1; i>=0;i--){
        FREObject element;
        FREGetArrayElementAt(arr, i, &element);
        [domains addObject: [AppsFlyerAIRExtension getString: element]];
    }
    
    [[AppsFlyerLib shared] setOneLinkCustomDomains:domains];

    return NULL;
}

DEFINE_ANE_FUNCTION(setSharingFilter)
{
    FREObject arr = argv[0];
    uint32_t arr_len;
    FREGetArrayLength(arr, &arr_len);
    NSMutableArray *filters = [[NSMutableArray alloc] init];
    for(int32_t i=arr_len-1; i>=0;i--){
        FREObject element;
        FREGetArrayElementAt(arr, i, &element);
        [filters addObject: [AppsFlyerAIRExtension getString: element]];
    }
    [AppsFlyerLib shared].sharingFilter = filters;
    return NULL;
}

DEFINE_ANE_FUNCTION(setSharingFilterForAllPartners)
{
    [[AppsFlyerLib shared] setSharingFilterForAllPartners];
    return NULL;
}

DEFINE_ANE_FUNCTION(performOnAppAttribution)
{
    NSString *strUrl = [AppsFlyerAIRExtension getString: argv[0]];
    NSURL *url = [NSURL URLWithString: strUrl];
    [[AppsFlyerLib shared] performOnAppAttributionWithURL:url];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setCurrency)
{
    NSString *currency = [AppsFlyerAIRExtension getString: argv[0]];
    
    [AppsFlyerLib shared].currencyCode = currency;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(logEvent)
{
    if(argv[0] != NULL) {
        NSString *eventName = [AppsFlyerAIRExtension getString: argv[0]];
        NSString *eventValue = [AppsFlyerAIRExtension getString: argv[1]];
        NSDictionary *values = [AppsFlyerAIRExtension convertFromJSonString:eventValue];
    
        [[AppsFlyerLib shared] logEvent:eventName withValues:values];
    }
    
    return NULL;
}

DEFINE_ANE_FUNCTION(setCustomerUserId)
{
    NSString *appUserId = [AppsFlyerAIRExtension getString: argv[0]];
    
    [AppsFlyerLib shared].customerUserID = appUserId;
    
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
    
    [[AppsFlyerLib shared] setUserEmails:emails withCryptType:EmailCryptTypeSHA256];
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
    
    [[AppsFlyerLib shared] setResolveDeepLinkURLs:urls];
    return NULL;
}

DEFINE_ANE_FUNCTION(getAppsFlyerUID)
{
    FREObject uid = nil;
    NSString *value = (NSString *)[[AppsFlyerLib shared] getAppsFlyerUID];
    FRENewObjectFromUTF8(strlen((const char*)[value UTF8String]) + 1.0, (const uint8_t*)[value UTF8String], &uid);
    return uid;
}

DEFINE_ANE_FUNCTION(setDebug)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [AppsFlyerLib shared].isDebug = value;
    return NULL;
}

DEFINE_ANE_FUNCTION(handlePushNotification)
{
    NSString *userInfoString = [AppsFlyerAIRExtension getString: argv[0]];
    NSDictionary *userInfo = [AppsFlyerAIRExtension convertFromJSonString:userInfoString];

    [[AppsFlyerLib shared] handlePushNotification:userInfo];
    
    return NULL;
}

DEFINE_ANE_FUNCTION(registerUninstall)
{
    NSString *deviceTokenStr = [AppsFlyerAIRExtension getString: argv[0]];
    NSData *deviceToken = [AppsFlyerAIRExtension dataFromHexString:deviceTokenStr];
    [[AppsFlyerLib shared] registerUninstall:deviceToken];
    return NULL;
}

DEFINE_ANE_FUNCTION(registerConversionListener)
{
    [AppsFlyerLib shared].delegate = conversionDelegate;
    return NULL;
}

DEFINE_ANE_FUNCTION(validateAndLogInAppPurchase)
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
    
    [[AppsFlyerLib shared] validateAndLogInAppPurchase:productIdentifier
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
    [AppsFlyerLib shared].useReceiptValidationSandbox = value;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(registerValidatorListener)
{
    NSLog(@"[AppsFlyerAIRExtension] registerValidatorListener method is not supported on iOS");
    return NULL;
}


DEFINE_ANE_FUNCTION(setCollectAndroidID)
{
    NSLog(@"[AppsFlyerAIRExtension] setCollectAndroidID method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setAndroidIdData)
{
    NSLog(@"[AppsFlyerAIRExtension] setAndroidIdData method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setImeiData)
{
    NSLog(@"[AppsFlyerAIRExtension] setImeiData method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(setCollectIMEI)
{
    NSLog(@"[AppsFlyerAIRExtension] setCollectIMEI method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(waitForCustomerUserId)
{
    NSLog(@"[AppsFlyerAIRExtension] waitForCustomerUserId method is not supported on iOS");
    return NULL;
}

DEFINE_ANE_FUNCTION(startWithCUID)
{
    NSString *appUserId = [AppsFlyerAIRExtension getString: argv[0]];
    [AppsFlyerLib shared].customerUserID = appUserId;
    [[AppsFlyerLib shared] start];
    return NULL;
}

DEFINE_ANE_FUNCTION(waitForATTUserAuthorization)
{
    if (@available(iOS 14, *)) {
        int interval = [AppsFlyerAIRExtension getInt: argv[0]];
        double timeoutInterval = (double)interval;
        [[AppsFlyerLib shared] waitForATTUserAuthorizationWithTimeoutInterval:timeoutInterval];
    }
    return NULL;
}

DEFINE_ANE_FUNCTION(disableSKAdNetwork)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [AppsFlyerLib shared].disableSKAdNetwork = value;
    return NULL;
}

DEFINE_ANE_FUNCTION(disableAdvertisingIdentifier)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [AppsFlyerLib shared].disableAdvertisingIdentifier = value;
    return NULL;
}

DEFINE_ANE_FUNCTION(setCurrentDeviceLanguage)
{
    NSString *language = [AppsFlyerAIRExtension getString: argv[0]];
    [AppsFlyerLib shared].currentDeviceLanguage = language;
    return NULL;
}

DEFINE_ANE_FUNCTION(setSharingFilterForPartners)
{
    FREObject arr = argv[0];
    uint32_t arr_len;
    FREGetArrayLength(arr, &arr_len);
    NSMutableArray *partners = [[NSMutableArray alloc] init];
    for(int32_t i=arr_len-1; i>=0;i--){
        FREObject element;
        FREGetArrayElementAt(arr, i, &element);
        [partners addObject: [AppsFlyerAIRExtension getString: element]];
    }
    [[AppsFlyerLib shared] setSharingFilterForPartners:partners];
    return NULL;
}

DEFINE_ANE_FUNCTION(EnableTCFDataCollection)
{
    uint32_t value;
    FREGetObjectAsBool(argv[0], &value);
    [[AppsFlyerLib shared] enableTCFDataCollection:value];
    return NULL;
}

DEFINE_ANE_FUNCTION(SetConsentForNonGDPRUser)
{
    id consent = [[AppsFlyerConsent alloc] initNonGDPRUser];
    [[AppsFlyerLib shared] setConsentData:consent];
    return NULL;
}

// void SetConsentForGDPRUser(bool hasConsentForDataUsage, bool hasConsentForAdsPersonalization)
DEFINE_ANE_FUNCTION(SetConsentForGDPRUser)
{
    uint32_t hasConsentForDataUsage;
    FREGetObjectAsBool(argv[0], &hasConsentForDataUsage);
    
    uint32_t hasConsentForAdsPersonalization;
    FREGetObjectAsBool(argv[0], &hasConsentForAdsPersonalization);
    
    
    id consent = [[AppsFlyerConsent alloc] initForGDPRUserWithHasConsentForDataUsage:hasConsentForDataUsage
                                                     hasConsentForAdsPersonalization:hasConsentForAdsPersonalization];
    [[AppsFlyerLib shared] setConsentData:consent];
    return NULL;
}


void AFExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 35;
    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*)"start";
    func[0].functionData = NULL;
    func[0].function = &start;

    func[1].name = (const uint8_t*)"logEvent";
    func[1].functionData = NULL;
    func[1].function = &logEvent;
    
    func[2].name = (const uint8_t*)"registerConversionListener";
    func[2].functionData = NULL;
    func[2].function = &registerConversionListener;
    
    func[3].name = (const uint8_t*)"setCurrency";
    func[3].functionData = NULL;
    func[3].function = &setCurrency;
    
    func[4].name = (const uint8_t*)"setCustomerUserId";
    func[4].functionData = NULL;
    func[4].function = &setCustomerUserId;
    
    func[5].name = (const uint8_t*)"setSharingFilterForAllPartners";
    func[5].functionData = NULL;
    func[5].function = &setSharingFilterForAllPartners;
    
    func[6].name = (const uint8_t*)"getAppsFlyerUID";
    func[6].functionData = NULL;
    func[6].function = &getAppsFlyerUID;
    
    func[7].name = (const uint8_t*)"setOneLinkCustomDomain";
    func[7].functionData = NULL;
    func[7].function = &setOneLinkCustomDomain;
    
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
    
    func[14].name = (const uint8_t*)"waitForATTUserAuthorization";
    func[14].functionData = NULL;
    func[14].function = &waitForATTUserAuthorization;
    
    func[15].name = (const uint8_t*)"registerUninstall";
    func[15].functionData = NULL;
    func[15].function = &registerUninstall;
    
    func[16].name = (const uint8_t*)"setAndroidIdData";
    func[16].functionData = NULL;
    func[16].function = &setAndroidIdData;
    
    func[17].name = (const uint8_t*)"setImeiData";
    func[17].functionData = NULL;
    func[17].function = &setImeiData;
    
    func[18].name = (const uint8_t*)"validateAndLogInAppPurchase";
    func[18].functionData = NULL;
    func[18].function = &validateAndLogInAppPurchase;
    
    func[19].name = (const uint8_t*)"init";
    func[19].functionData = NULL;
    func[19].function = &init;
    
    func[20].name = (const uint8_t*)"stop";
    func[20].functionData = NULL;
    func[20].function = &stop;
    
    func[21].name = (const uint8_t*)"isStopped";
    func[21].functionData = NULL;
    func[21].function = &isStopped;
    
    func[22].name = (const uint8_t*)"setUserEmails";
    func[22].functionData = NULL;
    func[22].function = &setUserEmails;
    
    func[23].name = (const uint8_t*)"waitForCustomerUserId";
    func[23].functionData = NULL;
    func[23].function = &waitForCustomerUserId;
    
    func[24].name = (const uint8_t*)"startWithCUID";
    func[24].functionData = NULL;
    func[24].function = &startWithCUID;
    
    func[25].name = (const uint8_t*)"setResolveDeepLinkURLs";
    func[25].functionData = NULL;
    func[25].function = &setResolveDeepLinkURLs;
    
    func[26].name = (const uint8_t*)"performOnAppAttribution";
    func[26].functionData = NULL;
    func[26].function = &performOnAppAttribution;
    
    func[27].name = (const uint8_t*)"setSharingFilter";
    func[27].functionData = NULL;
    func[27].function = &setSharingFilter;

    func[28].name = (const uint8_t*)"disableSKAdNetwork";
    func[28].functionData = NULL;
    func[28].function = &disableSKAdNetwork;

    func[29].name = (const uint8_t*)"setDisableAdvertisingIdentifiers";
    func[29].functionData = NULL;
    func[29].function = &disableAdvertisingIdentifier;
    
    func[30].name = (const uint8_t*)"setCurrentDeviceLanguage";
    func[30].functionData = NULL;
    func[30].function = &setCurrentDeviceLanguage;

    func[31].name = (const uint8_t*)"setSharingFilterForPartners";
    func[31].functionData = NULL;
    func[31].function = &setSharingFilterForPartners;
    
    func[32].name = (const uint8_t*)"EnableTCFDataCollection";
    func[32].functionData = NULL;
    func[32].function = &EnableTCFDataCollection;
    
    func[33].name = (const uint8_t*)"SetConsentForNonGDPRUser";
    func[33].functionData = NULL;
    func[33].function = &SetConsentForNonGDPRUser;
    
    func[34].name = (const uint8_t*)"SetConsentForGDPRUser";
    func[34].functionData = NULL;
    func[34].function = &SetConsentForGDPRUser;
    
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














