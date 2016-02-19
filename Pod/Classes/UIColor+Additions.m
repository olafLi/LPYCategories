//
//  UIColor+Helper.m
//  ketuitui
//
//  Created by apple on 14-10-27.
//  Copyright (c) 2014年 HangZhou PiaoYoung Co.Ltd. All rights reserved.
//

//
//UIColor * color_hex(NSInteger hex){
//    return [UIColor colorWithRed:( hex >> 16 & 0x0000ff) / 255.0 green:(hex >> 8 & 0x0000ff) / 255.0 blue:(hex & 0x0000ff) / 255.0 alpha:1.0];
//}
#import <LPYCategories/UIColor+Additions.h>
@implementation UIColor (Additions)

+ (UIColor *)placeColor {
    return color_hex(0xf4f4f4);
}
@end
