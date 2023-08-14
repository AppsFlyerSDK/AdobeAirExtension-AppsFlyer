//  Created by Oren Baranes on 3/25/14.
//  Copyright (c) 2014 Oren Baranes. All rights reserved.
//
#import "FlashRuntimeExtensions.h"

#import <UIKit/UIKit.h>
#import <AppsFlyerLib/AppsFlyerLib.h>

@interface AppsFlyerDelegate : NSObject<AppsFlyerLibDelegate> {
    FREContext ctx;
}

- (void) sendLaunch:(UIApplication *)application;

@property (nonatomic,assign) FREContext ctx;

@end
