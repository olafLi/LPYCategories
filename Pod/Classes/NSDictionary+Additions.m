//
// Created by CHENZHEN on 15/12/3.
// Copyright (c) 2015 HangZhou LiuYi Co.Ltd. All rights reserved.
//

#import <LPYCategories/NSDictionary+Additions.h>

@implementation NSDictionary (Additions)

- (NSString *)JSONString {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (instancetype)dictionaryWithJSONString:(NSString *)JSONString error:(NSError *__autoreleasing *)error {
    if (JSONString == nil && JSONString.length > 0) {
        return nil;
    }
    NSData *data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:error];
}

@end
