//
//  NSNumber+Additions.m
//  PiaoYoung
//
//  Created by LiTengFei on 15/2/10.
//  Copyright (c) 2015年 HangZhou PiaoYoung Co.Ltd. All rights reserved.
//

#import <LPYCategories/NSNumber+Additions.h>

@implementation NSNumber (Additions)
- (NSDecimalNumber *)decimalNumber {
    return [[NSDecimalNumber alloc] initWithString:self.stringValue];
}

- (NSNumber *)addWithNumber:(NSNumber *)number {
    return [[self decimalNumber] decimalNumberByAdding:[number decimalNumber]];
}

- (NSNumber *)subtractWithNumber:(NSNumber *)number; {
    return @(self.integerValue - number.integerValue);
}

- (NSNumber *)multiplyWithNumber:(NSNumber *)number; {
    return @((NSInteger) (self.floatValue * number.floatValue));
}

- (NSNumber *)divideWithNumber:(NSNumber *)number; {
    return @((NSInteger) (self.floatValue / number.floatValue));
}

- (NSNumber *)vaildNumber {
    if ([self isKindOfClass:[NSNumber class]]) {
        return self;
    }
    if ([self isKindOfClass:[NSString class]]) {
        NSString *string = (NSString *) self;
        if (string.length > 0) {
            return @(string.integerValue);
        } else {
            return @0;
        }
    } else {
        return self;
    }
}

- (NSNumber *)toNumber {
    return self;
}

@end
