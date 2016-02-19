//
//  UIApplication+Additions.m
//  Piaoyoung
//
//  Created by CHENZHEN on 15/12/5.
//  Copyright © 2015年 HangZhou LiuYi Co.Ltd. All rights reserved.
//

#import "UIApplication+Additions.h"

NSString *const kFirstTimeLaunchApplication = @"kFirstTimeLaunchApplication";
NSString *const kFirstTimeLaunchApplicationVersion = @"kFirstTimeLaunchApplicationVersion";

@implementation UIApplication (Additions)

- (void)callWithPhone:(NSString *)number {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@", number];
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

+ (BOOL)isFirstTimeLaunchApplicationWithVersion {
    NSString *last_version = [[NSUserDefaults standardUserDefaults] stringForKey:kFirstTimeLaunchApplicationVersion];
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    //判断 最后一次运行时的版本号 是否和当前版本 一致
    return last_version.doubleValue != version.doubleValue;
}

+ (BOOL)isFirstTimeLaunchApplication {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFirstTimeLaunchApplication];
}


+ (void)setLaunchApplication {
    NSString *version = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kFirstTimeLaunchApplicationVersion];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstTimeLaunchApplication];
}
@end
