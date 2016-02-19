//
//  NSDate+Additions.m
//  Community
//
//  Created by LiTengFei on 14/12/9.
//  Copyright (c) 2014年 HangZhou PiaoYoung Co.Ltd. All rights reserved.
//

#import <LPYCategories/NSDate+Additions.h>

NSString *const default_date_formatter = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDate (Additions)

- (NSString *)stringWithFormatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateStyle = (NSDateFormatterStyle) kCFDateFormatterShortStyle;
    fmt.locale = [NSLocale currentLocale];
    fmt.dateFormat = formatter;
    return [fmt stringFromDate:self];
}

+ (NSDate *)dateWithDateString:(NSString *)string {
    return [NSDate dateWithDateString:string formatter:default_date_formatter];
}

+ (NSDate *)dateWithDateString:(NSString *)string formatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateStyle = (NSDateFormatterStyle) kCFDateFormatterShortStyle;
    fmt.locale = [NSLocale currentLocale];
    fmt.dateFormat = formatter;
    return [fmt dateFromString:string];
}

+ (NSDate *)dateWithDateString:(NSString *)string formatter:(NSString *)formatter local:(NSLocale *)local {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateStyle = (NSDateFormatterStyle) kCFDateFormatterShortStyle;
    if (local) {fmt.locale = local;}
    fmt.dateFormat = formatter;
    return [fmt dateFromString:string];
}
@end

@implementation NSDate (Compare)

NSString *CompareStringWithDate(NSDate *fromDate, NSDate *toDate) {
    return @"";
}

+ (NSString *)intervalSinceNow:(NSString *)theDate {
    
    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    date.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *d = [date dateFromString:theDate];
    
    NSTimeInterval cha = -d.timeIntervalSinceNow;
    
    NSString *timeString = @"";
    
    //    NSTimeInterval cha = now - late;
    
    if (cha / 3600 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha / 60];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
    }
    if (cha / 3600 > 1 && cha / 86400 < 1) {
        timeString = [NSString stringWithFormat:@"%f", cha / 3600];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
    }
    if (cha / 86400 > 1) {
        timeString = [NSString stringWithFormat:@"%f", cha / 86400];
        timeString = [timeString substringToIndex:timeString.length - 7];
        timeString = [NSString stringWithFormat:@"%@天前", timeString];
    }
    return timeString;
}

@end