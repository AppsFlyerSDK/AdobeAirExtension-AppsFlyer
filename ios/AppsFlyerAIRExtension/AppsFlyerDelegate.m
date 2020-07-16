//  Created by Oren Baranes on 3/25/14.
//  Copyright (c) 2014 Oren Baranes. All rights reserved.
//

#import "AppsFlyerDelegate.h"

@implementation AppsFlyerDelegate

@synthesize ctx;

- (void) onConversionDataSuccess:(NSDictionary*) conversionInfo
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:conversionInfo
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        dispatchStatusEvent(ctx,@"installConversionDataLoaded",jsonString);
    }
}

- (void)onConversionDataFail:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    NSString *errorString = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
    NSLog(@"The error is: %@", errorString);
    dispatchStatusEvent(ctx, @"installConversionFailure", error.localizedDescription);
}	}

- (void) onAppOpenAttribution:(NSDictionary*) installData {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:installData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        dispatchStatusEvent(ctx,@"appOpenAttribution",jsonString);
    }
}

- (void) onAppOpenAttributionFailure:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    NSString *errorString = [[userInfo objectForKey:NSUnderlyingErrorKey] localizedDescription];
    NSLog(@"The error is: %@", errorString);
    dispatchStatusEvent(ctx, @"attributionFailure", error.localizedDescription);
}

- (void) sendLaunch:(UIApplication *)application {
    NSLog(@"[AppsFlyerAIRExtension] launch (from notification)");
    [[AppsFlyerTracker sharedTracker] trackAppLaunch];
}

void dispatchStatusEvent(FREContext ctx,NSString *eventType, NSString *eventLevel) {
    
    if (ctx == NULL) {
        return;
    }
    
    const uint8_t* levelCode = (const uint8_t*) [eventLevel UTF8String];
    const uint8_t* eventCode = (const uint8_t*) [eventType UTF8String];
    FREDispatchStatusEventAsync(ctx,eventCode,levelCode);
}

@end
