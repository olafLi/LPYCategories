//
// Created by ashen on 15/6/19.
// Copyright (c) 2015 PiaoYoung Co.Ltd. All rights reserved.
//

#import <LPYCategories/NSString+Additions.h>
#include <CommonCrypto/CommonCrypto.h>

NSString *gen_uuid() {
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);

    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *) uuid_string_ref];

    CFRelease(uuid_string_ref);
    return uuid;
}

static NSString *const regex_email = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
static NSString *const regex_password = @"^[a-zA-Z0-9_]{6,20}+$";
/**
  * 手机号码
  * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
  * 联通：130,131,132,152,155,156,185,186
  * 电信：133,1349,153,180,189
  */
static NSString *const regex_mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
/**
  10  * 中国移动：China Mobile
  11  * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
  12  */
static NSString *const regex_mobile_cm = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
/**
  15  * 中国联通：China Unicom
  16  * 130,131,132,152,155,156,185,186
  17  */
static NSString *const regex_mobile_cu = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
/**
  20  * 中国电信：China Telecom
  21  * 133,1349,153,180,189
  22  */
static NSString *const regex_mobile_ct = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";

@implementation NSString (Additions)

- (CGSize)boundingSizeWithSize:(CGSize)size attribute:(NSDictionary *)attribute fontSize:(float)fs {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [mutableDictionary addEntriesFromDictionary:attribute];
    if (fs > 0) {
        [mutableDictionary addEntriesFromDictionary:@{NSFontAttributeName : [UIFont systemFontOfSize:fs]}];
    }
    CGRect rect = [self boundingRectWithSize:size options:
                    NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:mutableDictionary
                                     context:nil];
    rect.size.height = ceilf(rect.size.height);
    rect.size.width = ceilf(rect.size.width);
    return rect.size;
}

- (CGRect)boundingRectWithSize:(CGSize)size attribute:(NSDictionary *)attribute {
    if (!attribute) {
        attribute = @{
                NSFontAttributeName : [UIFont systemFontOfSize:14.0f],
        };
    }
    CGRect rect = [self boundingRectWithSize:size
                                     options:
                                             NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil];
    rect.size.height = ceilf(rect.size.height);
    rect.size.width = ceilf(rect.size.width);

    return rect;
}

- (CGSize)boundingSizeWithSize:(CGSize)size attribute:(NSDictionary *)attribute {
    return [self boundingSizeWithSize:size attribute:attribute fontSize:0];
}

- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

#if !(__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_9) && !(__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)

    if (![self respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        return [data base64Encoding];
    }

#endif

    return [data base64EncodedStringWithOptions:(NSDataBase64EncodingOptions) 0];
}

- (NSString *)base64DecodedString {
    NSData *data = nil;

#if !(__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_9) && !(__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)

    if (![NSData instancesRespondToSelector:@selector(initWithBase64EncodedString:options:)]) {
        data = [[NSData alloc] initWithBase64Encoding:self];
    }
    else

#endif

    {
        data = [[NSData alloc] initWithBase64EncodedString:self options:(NSDataBase64DecodingOptions) 0];
    }

    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BOOL)isNull {
    if (self == nil) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isEmpty {
    if ([self isNull]) {
        return YES;
    }
    return self.length <= 0;
}

BOOL NSStringEmpty(NSString *string) {
    return string == nil || string.empty;
}

- (NSString *)md5 {
    const char *original_str = self.UTF8String;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG) strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02X", result[i]];
    }
    return hash.lowercaseString;
}

//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    return [email isValidateEmail];
}

//手机号码验证
+ (BOOL)validateMobile:(NSString *)mobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(\\+{0,1}[0-9]{4})?([0-9]{8,11})$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

///// 手机号码的有效性判断
//检测是否是手机号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_mobile];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_mobile_cm];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_mobile_cu];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex_mobile_ct];

    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
            || ([regextestcm evaluateWithObject:mobileNum] == YES)
            || ([regextestct evaluateWithObject:mobileNum] == YES)
            || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    }
    else {
        return NO;
    }
}

//用户名
+ (BOOL)validateUserName:(NSString *)name {
    NSString *userNameRegex = @"^[a-zA-Z0-9_]+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    return [userNamePredicate evaluateWithObject:name];
}

//密码
+ (BOOL)validatePassword:(NSString *)passWord {
    NSString *passWordRegex = @"^[a-zA-Z0-9_]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//昵称
+ (BOOL)validateNickname:(NSString *)nickname {
    NSString *nicknameRegex = @"^[a-zA-Z0-9_]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nicknameRegex];
    return [predicate evaluateWithObject:nickname];
}

//身份证号
+ (BOOL)validateIdentityCard:(NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

- (BOOL)isPhone {
    return [NSString validateMobile:self];
}

- (BOOL)isEmail {
    return [NSString validateEmail:self];
}

- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSNumber *)doubleNumber {
    return @(self.doubleValue);
}

- (NSNumber *)integerNumber {
    return @(self.integerValue);
}


@end