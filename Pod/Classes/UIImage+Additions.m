//
//  UIImage+Creation.m
//  PiaoYoung
//
//  Created by LiTengFei on 15/1/20.
//  Copyright (c) 2015年 HangZhou PiaoYoung Co.Ltd. All rights reserved.
//

#import <LPYCategories/UIImage+Additions.h>
#import <Accelerate/Accelerate.h>

@implementation UIImage (Additions)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {

    @autoreleasepool {

        CGRect rect = CGRectMake(0, 0, size.width, size.height);

        UIGraphicsBeginImageContext(rect.size);

        CGContextRef context = UIGraphicsGetCurrentContext();

        CGContextSetFillColorWithColor(context, color.CGColor);

        CGContextFillRect(context, rect);

        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

        UIGraphicsEndImageContext();

        return img;
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(100, 100)];
}

+ (UIImage *)imageWithPlaceColor {
    return [self imageWithColor:[UIColor placeColor]];
}


// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, bounds);
    UIImage *croppedImage;
    if ([self respondsToSelector:@selector(scale)] && [UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    }
    else {
        croppedImage = [UIImage imageWithCGImage:imageRef];
    }
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];

    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
            round((resizedImage.size.height - thumbnailSize) / 2),
            thumbnailSize,
            thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];

    return croppedImage;
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;

    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;

        default:
            drawTransposed = NO;
    }

    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;

    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;

        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;

        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %ld", (long) contentMode];
    }

    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);

    return [self resizedImage:newSize interpolationQuality:quality];
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect;
    if ([self respondsToSelector:@selector(scale)])
        newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width * self.scale, newSize.height * self.scale));
    else
        newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;

    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
            newRect.size.width,
            newRect.size.height,
            CGImageGetBitsPerComponent(imageRef),
            0,
            CGImageGetColorSpace(imageRef),
            CGImageGetBitmapInfo(imageRef));

    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);

    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);

    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);

    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage;
    if ([self respondsToSelector:@selector(scale)] && [UIImage respondsToSelector:@selector(imageWithCGImage:scale:orientation:)]) {
        newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:self.imageOrientation];
    }
    else {
        newImage = [UIImage imageWithCGImage:newImageRef];
    }

    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);

    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (self.imageOrientation) {
        case UIImageOrientationDown: // EXIF = 3
        case UIImageOrientationDownMirrored: // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;

        case UIImageOrientationLeft: // EXIF = 6
        case UIImageOrientationLeftMirrored: // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;

        case UIImageOrientationRight: // EXIF = 8
        case UIImageOrientationRightMirrored: // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;

        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }

    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored: // EXIF = 2
        case UIImageOrientationDownMirrored: // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        case UIImageOrientationLeftMirrored: // EXIF = 5
        case UIImageOrientationRightMirrored: // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;

        default:
            break;
    }

    return transform;
}

- (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize {
    //DDLogInfo(@"imageByScalingAndCroppingForSize");
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        widthFactor = MIN(widthFactor, 1);
        heightFactor = MIN(heightFactor, 1);
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        }
        else {
            scaleFactor = heightFactor; // scale to fit width
        }

        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else {
            if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }

    UIGraphicsBeginImageContext(targetSize); // this will crop

    if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0f);
    }
    else {
        UIGraphicsBeginImageContext(targetSize);
    }

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = truncf(scaledWidth);
    thumbnailRect.size.height = truncf(scaledHeight);

    //    DDLogInfo(@"thumbnail width = %f", thumbnailRect.size.width);
    //    DDLogInfo(@"thumbnail height = %f", thumbnailRect.size.height);

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if (newImage == nil) {
        DDLogInfo(@"could not scale image");
    }

    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

// Method: vImageScaledImage:(UIImage*) sourceImage withSize:(CGSize) destSize
// Returns even better scaling than drawing to a context with kCGInterpolationHigh.
// This employs the vImage routines in Accelerate.framework.
// For more information about vImage, see https://developer.apple.com/library/mac/#documentation/performance/Conceptual/vImage/Introduction/Introduction.html#//apple_ref/doc/uid/TP30001001-CH201-TPXREF101
// Large quantities of memory are manually allocated and (hopefully) freed here.  Test your application for leaks before and after using this method.
- (UIImage *)vImageScaledImage:(UIImage *)sourceImage withSize:(CGSize)destSize {
    UIImage *destImage = nil;

    if (sourceImage) {
        // First, convert the UIImage to an array of bytes, in the format expected by vImage.
        // Thanks: http://stackoverflow.com/a/1262893/1318452
        CGImageRef sourceRef = sourceImage.CGImage;
        NSUInteger sourceWidth = CGImageGetWidth(sourceRef);
        NSUInteger sourceHeight = CGImageGetHeight(sourceRef);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        unsigned char *sourceData = (unsigned char *) calloc(sourceHeight * sourceWidth * 4, sizeof(unsigned char));
        NSUInteger bytesPerPixel = 4;
        NSUInteger sourceBytesPerRow = bytesPerPixel * sourceWidth;
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(sourceData, sourceWidth, sourceHeight,
                bitsPerComponent, sourceBytesPerRow, colorSpace,
                kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
        CGContextDrawImage(context, CGRectMake(0, 0, sourceWidth, sourceHeight), sourceRef);
        CGContextRelease(context);

        // We now have the source data.  Construct a pixel array
        NSUInteger destWidth = (NSUInteger) destSize.width;
        NSUInteger destHeight = (NSUInteger) destSize.height;
        NSUInteger destBytesPerRow = bytesPerPixel * destWidth;
        unsigned char *destData = (unsigned char *) calloc(destHeight * destWidth * 4, sizeof(unsigned char));

        // Now create vImage structures for the two pixel arrays.
        // Thanks: https://github.com/dhoerl/PhotoScrollerNetwork
        vImage_Buffer src = {
                .data = sourceData,
                .height = sourceHeight,
                .width = sourceWidth,
                .rowBytes = sourceBytesPerRow
        };

        vImage_Buffer dest = {
                .data = destData,
                .height = destHeight,
                .width = destWidth,
                .rowBytes = destBytesPerRow
        };

        // Carry out the scaling.
        vImage_Error err = vImageScale_ARGB8888(
                &src,
                &dest,
                NULL,
                kvImageHighQualityResampling);

        // The source bytes are no longer needed.
        free(sourceData);

        // Convert the destination bytes to a UIImage.
        CGContextRef destContext = CGBitmapContextCreate(destData, destWidth, destHeight,
                bitsPerComponent, destBytesPerRow, colorSpace,
                kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big);
        CGImageRef destRef = CGBitmapContextCreateImage(destContext);

        // Store the result.
        destImage = [UIImage imageWithCGImage:destRef];

        // Free up the remaining memory.
        CGImageRelease(destRef);

        CGColorSpaceRelease(colorSpace);
        CGContextRelease(destContext);

        // The destination bytes are no longer needed.
        free(destData);

        if (err != kvImageNoError) {
            NSString *errorReason = [NSString stringWithFormat:@"vImageScale returned error code %zd", err];
            NSDictionary *errorInfo = @{@"sourceImage" : sourceImage,
                    @"destSize" : [NSValue valueWithCGSize:destSize]};

            NSException *exception = [NSException exceptionWithName:@"HighQualityImageScalingFailureException" reason:errorReason userInfo:errorInfo];

            @throw exception;
        }
    }
    return destImage;
}

- (UIImage *)resetImageSizeFromOImage {
    float w = self.size.width;
    float h = self.size.height;

    if (w != h) {
        if (w > h) { // 宽大于高
            CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake((w - h) / 2, 0, h, h));
            UIImage *pImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            return pImage;
        }
        else if (h > w) { //高大于宽
            CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, CGRectMake(0, (h - w) / 2, w, w));
            UIImage *pImage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            return pImage;
        }
    }
    return self;
}

- (UIImage *)transformToSize:(CGSize)newSize {
    // 创建一个bitmap的context
    UIGraphicsBeginImageContext(newSize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *TransformedImg = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return TransformedImg;
}

+ (UIImage *)imageWithColor:(UIColor *)color andFrame:(CGRect)frame {

    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, frame);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (UIImage *)scaleToSize:(CGSize)size {
    CGSize selfSize = self.size;
    CGSize reSize = size;
    CGFloat rw = reSize.width / selfSize.width;
    CGFloat rh = reSize.height / selfSize.height;

    CGFloat rate = MAX(rw, rh);

    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * rate, self.size.height * rate));
    [self drawInRect:CGRectMake(0, 0, self.size.width * rate, self.size.height * rate)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGRect cutRect = CGRectMake((scaledImage.size.width - reSize.width) / 2, (scaledImage.size.height - reSize.height) / 2, reSize.width, reSize.height);
    CGImageRef imageRef = scaledImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, cutRect);

    UIGraphicsBeginImageContext(reSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, cutRect, subImageRef);
    UIImage *cutImage = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    UIGraphicsEndImageContext();

    return cutImage;
}

+ (UIImage *)gradientImageFromColors:(NSArray *)colors gradientType:(GradientType)gradientType size:(CGSize)size {
    NSMutableArray *ar = [NSMutableArray array];
    for (UIColor *c in colors) {
        [ar addObject:(id) c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([colors.lastObject CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        case 3:
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    //    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)screenShot {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds)), YES, 0);
    [[UIApplication sharedApplication].keyWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

+ (UIImage *)screenShotSimple {
    UIImage *viewImage = [UIImage screenShot];
    return [viewImage scaleToSize:CGSizeMake(viewImage.size.width / 2, viewImage.size.height / 2)];
}

- (UIImage *)gaussianWithRadius:(CGFloat)radius {
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:@((double) radius) forKey:kCIInputRadiusKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect rect = inputImage.extent;
    rect.origin.x += radius / 2;
    rect.origin.y += radius / 2;
    rect.size.width -= radius;
    rect.size.height -= radius;
    CGImageRef cgImage = [context createCGImage:result fromRect:rect];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return image;
}
@end
