//
// Created by CHENZHEN on 15/12/3.
// Copyright (c) 2015 HangZhou LiuYi Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (Additions)

@property(nonatomic, readonly, copy) NSString *JSONString;

+ (instancetype)dictionaryWithJSONString:(NSString *)JSONString error:(NSError **)error;

@end
