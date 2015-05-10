//
//  AppDelegate.m
//  iBank
//
//  Created by McKee on 15/4/18.
//  Copyright (c) 2015年 McKee. All rights reserved.
//

#import "AppDelegate.h"
#import "dataHelper.h"
#import "aliveHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _lastTouchTimestamp = 0;
    [aliveHelper helper].inteval = 300;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if( ![dataHelper helper].sessionid ){
        return;
    }
    
    NSTimeInterval timestamp = [NSDate date].timeIntervalSince1970;
    int interval = [dataHelper helper].timeoutInterval;
    if( timestamp - _lastTouchTimestamp > interval ){
        [[aliveHelper helper] stopKeepAlive];
        [dataHelper helper].passwordTextField.text = @"";
        [dataHelper helper].verifyCodeTextField.text = @"";
        [dataHelper helper].sessionid = nil;
        [[dataHelper helper].verifyImageSrv request];
        UINavigationController *nav = (UINavigationController*) self.window.rootViewController;
        [nav popToRootViewControllerAnimated:YES];
    }
    else{
        _lastTouchTimestamp = timestamp;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"-----*****___");
    [super touchesBegan:touches withEvent:event];
}

@end
