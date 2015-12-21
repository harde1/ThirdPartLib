//
//  AppDelegate.m
//  ThirdPartLib
//
//  Created by wukong on 15/12/21.
//  Copyright © 2015年 lhc. All rights reserved.
//

#import "AppDelegate.h"

//微信appID
static NSString * const WXCHAT_APPID = @"wxde59e50c52476f7c";
static NSString * const WXCHAT_APPSECRET = @"1fe89d959f796f8c119d26c76722062c";





#import "AppDelegate+Wechat.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //微信登录
    [self wxRegisterAppID:WXCHAT_APPID];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
