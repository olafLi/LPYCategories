//
//  UIFont+Additions.h
//  Piaoyoung
//
//  Created by CHENZHEN on 15/12/28.
//  Copyright © 2015年 HangZhou LiuYi Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline NSMutableParagraphStyle *questionTitleParagraphStyle(CGFloat lineSpace) {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace;
    return paragraphStyle;
}

@interface UIFont (Additions)

@end
