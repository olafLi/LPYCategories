//
//  NSMutableAttributedString+Additions.m
//  Piaoyoung
//
//  Created by TengFeiLi on 16/1/18.
//  Copyright © 2016年 HangZhou LiuYi Co.Ltd. All rights reserved.
//

#import <LPYCategories/NSMutableAttributedString+Additions.h>

@implementation NSMutableAttributedString (Additions)
- (NSRange)lpy_rangeOfAll {
    return NSMakeRange(0, self.length);
}
@end
