//
//  UIActionSheet+Additions.h
//  CreditCardManager
//
//  Created by _tauCross on 14-8-1.
//  Copyright (c) 2014年 Enniu. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^ActionSheetCompleteBlock)(NSInteger buttonIndex, UIActionSheet *actionSheet);

@interface UIActionSheet (Additions) <UIActionSheetDelegate>

@property(nonatomic, copy) ActionSheetCompleteBlock block;

- (void)showInView:(UIView *)view withBlock:(ActionSheetCompleteBlock)block;

@end
