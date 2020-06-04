//  Created by Oren Baranes on 3/25/14.
//  Copyright (c) 2014 Oren Baranes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsFlyerTracker.h"
#import "FlashRuntimeExtensions.h"

@interface AppsFlyerDelegate : NSObject<AppsFlyerTrackerDelegate> {
    FREContext ctx;
}

- (void) sendLaunch:(UIApplication *)application;

@property (nonatomic,assign) FREContext ctx;

@end
