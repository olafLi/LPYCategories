//
//  NSDate+Additions.h
//  Community
//
//  Created by LiTengFei on 14/12/9.
//  Copyright (c) 2014年 HangZhou PiaoYoung Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const default_date_formatter;

@interface NSDate (Additions)

/***
* 根据指定的格式 格式化日期
* **/

- (NSString *)stringWithFormatter:(NSString *)formatter;

+ (NSDate *)dateWithDateString:(NSString *)string;

+ (NSDate *)dateWithDateString:(NSString *)string formatter:(NSString *)formatter;

+ (NSDate *)dateWithDateString:(NSString *)string formatter:(NSString *)formatter local:(NSLocale *)local;

@end

@interface NSDate (Compare)

extern NSString *CompareStringWithDate(NSDate *fromDate, NSDate *toDate);

+ (NSString *)intervalSinceNow:(NSString *)theDate;

@end
