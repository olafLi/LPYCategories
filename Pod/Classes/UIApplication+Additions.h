//
//  UIApplication+Additions.h
//  Piaoyoung
//
//  Created by CHENZHEN on 15/12/5.
//  Copyright © 2015年 HangZhou LiuYi Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const kFirstTimeLaunchApplication;
UIKIT_EXTERN NSString *const kFirstTimeLaunchApplicationVersion;

@interface UIApplication (Additions)

- (void)callWithPhone:(NSString *)number;

+ (BOOL)isFirstTimeLaunchApplicationWithVersion;

+ (void)setLaunchApplication;

+ (BOOL)isFirstTimeLaunchApplication;

@end


