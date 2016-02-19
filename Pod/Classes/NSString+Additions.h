//
// Created by ashen on 15/6/19.
// Copyright (c) 2015 PiaoYoung Co.Ltd. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>

#define regex(regex, string)                                                   \
({                                                                           \
NSPredicate *emailTest =                                                   \
[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];           \
[emailTest evaluateWithObject:string];                                     \
})

extern NSString *gen_uuid();

extern BOOL NSStringEmpty(NSString *string);

@interface NSString (Additions)

- (CGSize)boundingSizeWithSize:(CGSize)size attribute:(NSDictionary *)attribute fontSize:(float)fs;

- (CGSize)boundingSizeWithSize:(CGSize)size attribute:(NSDictionary *)attribute;

- (CGRect)boundingRectWithSize:(CGSize)size attribute:(NSDictionary *)attribute;


@property(nonatomic, readonly, copy) NSString *base64EncodedString;

@property(nonatomic, readonly, copy) NSString *base64DecodedString;

@property(nonatomic, getter=isEmpty, readonly) BOOL empty;


@property(nonatomic, readonly, copy) NSString *md5;

+ (BOOL)validateEmail:(NSString *)email;

+ (BOOL)validateMobile:(NSString *)mobile;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)validateUserName:(NSString *)name;

+ (BOOL)validatePassword:(NSString *)passWord;

+ (BOOL)validateNickname:(NSString *)nickname;

+ (BOOL)validateIdentityCard:(NSString *)identityCard;

@property(nonatomic, assign, readonly) BOOL isEmail;
@property(nonatomic, assign, readonly) BOOL isPhone;

@property(nonatomic, readonly) NSNumber *doubleNumber;
@property(nonatomic, readonly) NSNumber *integerNumber;


@end