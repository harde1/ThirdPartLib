//
//  AppDelegate+Wechat.m
//  WuKongUserClient
//
//  Created by yangminqin on 15/8/5.
//  Copyright (c) 2015年 cong. All rights reserved.
//

#import "AppDelegate+Wechat.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation AppDelegate (Wechat)

-(void)wxRegisterAppID:(NSString *)appid{
    
    
    BOOL isFound = ([[[[NSBundle mainBundle] infoDictionary] description] rangeOfString:appid].location == NSNotFound)?NO:YES;
    if (!isFound) {
        NSLog(@"微信库配置缺少一步：info --> URL types-->点击＋号后填写[identifier=weixing,Schemes=%@]",appid);
        return;
    }
    
    //appid自己填写
    [WXApi registerApp:appid];
    
    [[self rac_signalForSelector:@selector(application:openURL:sourceApplication:annotation:)] subscribeNext:^(RACTuple * tuple) {
        
        NSURL * url = [tuple second];
        [self handleOpenWeChatURL:url]; //微信
        
    }];
    
    [[self rac_signalForSelector:@selector(application:handleOpenURL:)] subscribeNext:^(RACTuple * tuple) {
        
        NSURL * url = [tuple second];
        [self handleOpenWeChatURL:url]; //微信
    }];
}

-(BOOL)handleOpenWeChatURL:(NSURL *)url{
    return  [WXApi handleOpenURL:url delegate:self];
    
}
//onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void)onReq:(BaseReq *)req{
    NSLog(@"onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面：\n%@",req);
}
//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void)onResp:(BaseResp *)resp{
    NSLog(@"如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。：\n%@",resp);
    
    NSString *string;
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        //微信分享成功
        switch (resp.errCode) {
            case WXSuccess:
            {
                //分享成功
                string = @"分享成功";
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"shareSuccess" object:string userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
                break;
            case WXErrCodeSentFail:
            {
                //分享失败
                string = @"分享失败";
            }
                break;
            case WXErrCodeUserCancel:
            {
                //用户取消分享
                string = @"取消分享";
            }
                break;
                
            default:
                break;
        }
        
        NSLog(@"%@",string);
        //分享拦截
        return;
    }
    
    //qq登陆居然是同样的方法命名，onResp:(BaseResp *)resp王八蛋
    if ([NSStringFromClass([resp class]) isEqualToString:@"SendMessageToQQResp"]) {
        
        string = @"返回信息可能来自于QQ分享";
        NSLog(@"%@",string);
        return;
    }
    
    SendAuthResp * sendAuthResp = (SendAuthResp *)resp;
    NSString*code=[sendAuthResp code];
    
    NSLog(@"%@:resp--err==%d,%@, type--%d,",code,resp.errCode,resp.errStr,resp.type);
    
    //公用的方法，有点慢，也可以获取到用户的信息
    [self getWXTokenByCode:code];
}

-(void)weChatLogin {
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //req.openID=WXCHAT_APPID;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

-(void)isWXAppInstalledHide:(UIView *)view {
    if (![WXApi isWXAppInstalled]) {
        view.hidden = YES;
    }
}

/**
 通过code换取的网页授权access_token,获取到网页授权access_token的同时，也获取到了 openid，snsapi_base式的网页授权
 https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
 
 返回
 {
 "access_token":"ACCESS_TOKEN",
 "expires_in":7200,
 "refresh_token":"REFRESH_TOKEN",
 "openid":"OPENID",
 "scope":"SCOPE"
 }
 https://api.weixin.qq.com/sns/userinfo?access_token=ACCESS_TOKEN&openid=OPENID
 
 {
 city = Haidian;
 country = CN;
 headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
 language = "zh_CN";
 nickname = "xxx";
 openid = oyAaTjsDx7pl4xxxxxxx;
 privilege =     (
 );
 province = Beijing;
 sex = 1;
 unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
 }
 
 */
-(void)getWXTokenByCode:(NSString *)code{
    
    NSString * strGetToken = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",@"",@"",code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:strGetToken];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"获取token成功：%@",dict);
            
            //再获取用户的信息
            NSString * strGetUserInfo = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",dict[@"access_token"],dict[@"openid"]];
            
            NSURL *urlGetUserInfo = [NSURL URLWithString:strGetUserInfo];
            NSString *userInfo = [NSString stringWithContentsOfURL:urlGetUserInfo encoding:NSUTF8StringEncoding error:nil];
            NSData *dataUserInfo = [userInfo dataUsingEncoding:NSUTF8StringEncoding];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataUserInfo) {
                    NSDictionary *dictUserInfo = [NSJSONSerialization JSONObjectWithData:dataUserInfo options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"获取微信用户的信息：%@",dictUserInfo);
                }
            });
        }
    });
}

-(void)weChatLoginBlock:(id (^)(NSDictionary * dict))successBlock {
    
}

@end
