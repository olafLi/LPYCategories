//
//  CALayer+Additions.m
//  Piaoyoung
//
//  Created by CHENZHEN on 15/12/4.
//  Copyright © 2015年 HangZhou LiuYi Co.Ltd. All rights reserved.
//

#import <LPYCategories/CALayer+Additions.h>

@implementation CALayer (Additions)
- (void)setCornerRadius:(CGFloat)cornerRadius masksToBounds:(BOOL)masksToBounds {
    self.cornerRadius = cornerRadius;
    self.masksToBounds = masksToBounds;
}
@end
