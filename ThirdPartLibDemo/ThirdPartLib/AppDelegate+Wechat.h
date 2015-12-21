//
//  AppDelegate+Wechat.h
//  WuKongUserClient
//
//  Created by yangminqin on 15/8/5.
//  Copyright (c) 2015年 cong. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
@interface AppDelegate (Wechat)<WXApiDelegate>
/*
 第一步：
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions里面调用
 */
-(void)wxRegisterAppID:(NSString *)appid;
/*
 第二步：
 添加在
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
 */
-(BOOL)handleOpenWeChatURL:(NSURL *)url;
/**
 第三步：
 点击登录
 在需要执行的Viewcontroller里面执行
 [[UIApplication sharedApplication].delegate performSelector:@selector(weChatLogin)];
 就会调用此句
 */
-(void)weChatLogin;
//(id (^)(id accumulator, id value))combine

-(void)weChatLoginBlock:(id (^)(NSDictionary * dict))successBlock;

-(void)isWXAppInstalledHide:(UIView *)view;
@end
