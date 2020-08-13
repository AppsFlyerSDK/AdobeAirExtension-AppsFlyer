//  Created by Oren Baranes on 3/25/14.
//  Copyright (c) 2014 Oren Baranes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppsFlyerLib.h"
#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>

@interface AppsFlyerDelegate : NSObject<AppsFlyerLibDelegate> {
    FREContext ctx;
}

- (void) sendLaunch:(UIApplication *)application;

@property (nonatomic,assign) FREContext ctx;

@end
