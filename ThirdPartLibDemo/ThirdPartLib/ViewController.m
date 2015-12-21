//
//  ViewController.m
//  ThirdPartLib
//
//  Created by wukong on 15/12/21.
//  Copyright © 2015年 lhc. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate+Wechat.h"
#define APP (AppDelegate *)[UIApplication sharedApplication].delegate
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)clickWx:(UIButton *)sender {
    
    
    [APP weChatLogin];
}
- (IBAction)clickQQ:(UIButton *)sender {
    
}
- (IBAction)clickWeibo:(UIButton *)sender {
    
}

@end
