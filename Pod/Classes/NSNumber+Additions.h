//
//  NSNumber+Additions.h
//  PiaoYoung
//
//  Created by LiTengFei on 15/2/10.
//  Copyright (c) 2015年 HangZhou PiaoYoung Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Additions)

- (NSNumber *)addWithNumber:(NSNumber *)number;

- (NSNumber *)subtractWithNumber:(NSNumber *)number;

- (NSNumber *)multiplyWithNumber:(NSNumber *)number;

- (NSNumber *)divideWithNumber:(NSNumber *)number;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSNumber *toNumber;


@end
