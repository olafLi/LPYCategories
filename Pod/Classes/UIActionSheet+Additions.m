//
//  UIActionSheet+Additions.m
//  CreditCardManager
//
//  Created by _tauCross on 14-8-1.
//  Copyright (c) 2014年 Enniu. All rights reserved.
//

#import <LPYCategories/UIActionSheet+Additions.h>
#import <objc/runtime.h>

static char action_sheet_complete_block_key;

@implementation UIActionSheet (Additions)

- (void)showInView:(UIView *)view withBlock:(ActionSheetCompleteBlock)block {
    if (block) {
        self.block = block;
        self.delegate = self;
    }
    [self showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.block) {
        self.block(buttonIndex, actionSheet);
    }
}

- (ActionSheetCompleteBlock)block {
    return objc_getAssociatedObject(self, &action_sheet_complete_block_key);
}

- (void)setBlock:(ActionSheetCompleteBlock)block {
    objc_setAssociatedObject(self, &action_sheet_complete_block_key, block, OBJC_ASSOCIATION_COPY);
}
@end
