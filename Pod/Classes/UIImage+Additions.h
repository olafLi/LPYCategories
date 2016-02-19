//
//  UIImage+Creation.h
//  PiaoYoung
//
//  Created by LiTengFei on 15/1/20.
//  Copyright (c) 2015年 HangZhou PiaoYoung Co.Ltd. All rights reserved.
//

#import "UIImage+Additions.h"
#import <UIKit/UIKit.h>


#ifndef image

#define image(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:@"png"]]

#endif


typedef NS_ENUM(unsigned int, GradientType) {
    topToBottom = 0,      //从上到下
    leftToRight = 1,      //从左到右
    upleftTolowRight = 2, //左上到右下
    uprightTolowLeft = 3, //右上到左下
};

@interface UIImage (Additions)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithPlaceColor;

- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode bounds:(CGSize)bounds interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize;

- (UIImage *)vImageScaledImage:(UIImage *)sourceImage withSize:(CGSize)destSize;

@property(nonatomic, readonly, strong) UIImage *resetImageSizeFromOImage;

+ (UIImage *)imageWithColor:(UIColor *)color andFrame:(CGRect)frame;

- (UIImage *)transformToSize:(CGSize)newSize;

- (UIImage *)resizedImage:(CGSize)newSize transform:(CGAffineTransform)transform drawTransposed:(BOOL)transpose interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage *)gradientImageFromColors:(NSArray *)colors gradientType:(GradientType)gradientType size:(CGSize)size;

+ (UIImage *)screenShot;

+ (UIImage *)screenShotSimple;

- (UIImage *)gaussianWithRadius:(CGFloat)radius;

@end
