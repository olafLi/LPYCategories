//
//  UIColor+Helper.h
//  ketuitui
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 HangZhou PiaoYoung Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


/*!
 @author 15-01-24 02:01:12
 
 @brief  C 语法 扩展
 
 @since 1.0
 */

#define color_hex(hex) ([UIColor colorWithRed:(hex >> 16 & 0x0000ff) / 255.0 green:(hex >> 8 & 0x0000ff) / 255.0 blue:(hex & 0x0000ff) / 255.0                              alpha:1.0])

#define color_hex_alpha(hex, _alpha)                                           \
([UIColor colorWithRed:(hex >> 16 & 0x0000ff) / 255.0                        \
green:(hex >> 8 & 0x0000ff) / 255.0                         \
blue:(hex & 0x0000ff) / 255.0                              \
alpha:_alpha])

#define color_rgb(r, g, b, a)                                                  \
([UIColor colorWithRed:(r) / 255.0                                           \
green:(g) / 255.0                                           \
blue:(b) / 255.0                                           \
alpha:(a)])

#define Color(r, g, b, a)                                                      \
([UIColor colorWithRed:(r) / 255.0                                           \
green:(g) / 255.0                                           \
blue:(b) / 255.0                                           \
alpha:(a)])

@interface UIColor (Additions)

extern UIColor *LightBlueColor;

+ (UIColor *)placeColor;

@end
