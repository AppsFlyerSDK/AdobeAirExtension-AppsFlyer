//
//  AdobeeAirExtensionIOS.m
//  AdobeeAirExtensionIOS
//
//  Created by Oren Baranes on 12/9/13.
//  Copyright (c) 2013 Oren Baranes. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "AppsFlyerTracker.h"
#import "AppsFlyerConversionDelegate.h"
#import "AppsFlyerAIRExtension.h"



AdobeAirConversionDelegate * conversionDelegate;


NSString *const EXTENSION_TYPE = @"AIR";

FREObject setDeveloperKey(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
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

FREObject sendTracking(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
    
    return NULL;
}

FREObject sendTrackingWithEvent(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
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
        
        [[AppsFlyerTracker sharedTracker] trackEvent:eventName withValue:eventValue];
    }
    
    return NULL;
}

FREObject sendTrackingWithValues(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
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

FREObject setCurrency(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    
    uint32_t string1Length;
    const uint8_t *string1;
    FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
    NSString *currency = [NSString stringWithUTF8String:(char*)string1];
    [AppsFlyerTracker sharedTracker].currencyCode = currency;
    
    return NULL;
}



FREObject setAppUserId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    
    uint32_t string1Length;
    const uint8_t *string1;
    FREGetObjectAsUTF8(argv[0], &string1Length, &string1);
    NSString *appUserId = [NSString stringWithUTF8String:(char*)string1];
    [AppsFlyerTracker sharedTracker].customerUserID = appUserId;
    
    
    return NULL;
}



FREObject getConversionData(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    
    [[AppsFlyerTracker sharedTracker] loadConversionDataWithDelegate: conversionDelegate];
    
    return NULL;
}


FREObject getAppsFlyerUID(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    FREObject uid = nil;
    NSString *value = (NSString *)[[AppsFlyerTracker sharedTracker] getAppsFlyerUID];
    FRENewObjectFromUTF8(strlen((const char*)[value UTF8String]) + 1, (const uint8_t*)[value UTF8String], &uid);
    return uid;
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
    
    *numFunctionsToTest = 8;
    FRENamedFunction* func = (FRENamedFunction*)malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*)"setDeveloperKey";
    func[0].functionData = NULL;
    func[0].function = &setDeveloperKey;
    
    func[1].name = (const uint8_t*)"sendTracking";
    func[1].functionData = NULL;
    func[1].function = &sendTracking;
    
    func[2].name = (const uint8_t*)"sendTrackingWithEvent";
    func[2].functionData = NULL;
    func[2].function = &sendTrackingWithEvent;
    
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
    
    func[7].name = (const uint8_t*)"sendTrackingWithValues";
    func[7].functionData = NULL;
    func[7].function = &sendTrackingWithValues;
    
//    func[7].name = (const uint8_t*)"setExtension";
//    func[7].functionData = NULL;
//    func[7].function = &setExtension;
    
    
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














