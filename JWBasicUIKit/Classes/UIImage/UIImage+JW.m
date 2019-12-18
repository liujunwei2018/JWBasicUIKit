//
//  UIImage+JW.m
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import "UIImage+JW.h"
#import <Accelerate/Accelerate.h>
#import "UIImage+GIF.h"

@implementation UIImage (JW)

+ (UIImage *)jw_imageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)jw_imageWithTintColor:(UIColor *)tintColor {
    if (tintColor) {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, self.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
        CGContextClipToMask(context, rect, self.CGImage);
        [tintColor setFill];
        CGContextFillRect(context, rect);
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    return self;
}

+ (UIImage *)jw_imageWithRect:(CGRect)rect
                   startColor:(CGColorRef)startColor
                     endColor:(CGColorRef)endColor
              layoutDirection:(JWImageColorsLayoutDirection)direction {
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = @[(__bridge id)startColor, (__bridge id)endColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, NULL);
    switch (direction) {
        case JWImageColorsLayoutDirectionHorizontal:
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, rect.size.height / 2.0), CGPointMake(rect.size.width, rect.size.height / 2.0), kCGGradientDrawsAfterEndLocation);
            break;
        case JWImageColorsLayoutDirectionVertical:
            CGContextDrawLinearGradient(context, gradient, CGPointMake(rect.size.width / 2.0, 0), CGPointMake(rect.size.width / 2.0, rect.size.height), kCGGradientDrawsAfterEndLocation);
            break;
        case JWImageColorsLayoutDirectionDiagonalTopLeft:
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0), CGPointMake(rect.size.width, rect.size.height), kCGGradientDrawsAfterEndLocation);
            break;
        case JWImageColorsLayoutDirectionDiagonalBottomLeft:
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, rect.size.height), CGPointMake(rect.size.width, 0), kCGGradientDrawsAfterEndLocation);
            break;
        default:
            CGContextDrawLinearGradient(context, gradient, CGPointMake(0, rect.size.height / 2.0), CGPointMake(rect.size.width, rect.size.height / 2.0), kCGGradientDrawsAfterEndLocation);
            break;
    }
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)jw_imageWithGifNamed:(NSString *)gifName {
    NSUInteger scale = (NSUInteger)[UIScreen mainScreen].scale;
    return [UIImage jw_gifName:gifName scale:scale];
}

+ (UIImage *)jw_gifName:(NSString *)name scale:(NSUInteger)scale {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%zdx", name, scale] ofType:@"gif"];
    if (!imagePath) {
        (scale + 1 > 3) ? (scale -= 1) : (scale += 1);
        imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@%zdx", name, scale] ofType:@"gif"];
    }
    
    if (imagePath) {
        // 传入图片名(不包含@Nx)
        NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
        return [UIImage sd_imageWithGIFData:imageData];
    } else {
        imagePath = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
        if (imagePath) {
            // 传入的图片名已包含@Nx or 传入图片只有一张 不分@Nx
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            return [UIImage sd_imageWithGIFData:imageData];
        } else {
            return [UIImage imageNamed:name];
        }
    }
}

+ (NSArray *)jw_gifToImagesWithGifName:(NSString *)gifName {
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:gifName withExtension:@"gif"];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t gifCount = CGImageSourceGetCount(gifSource);
    NSMutableArray *frames = [[NSMutableArray alloc]init];
    
    for (size_t i = 0; i< gifCount; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:imageRef]; [frames addObject:image];
        CGImageRelease(imageRef);
    }
    return frames;
}

- (BOOL) imageHasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}
- (NSString *)imageEncodeData
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha]) {
        imageData = UIImagePNGRepresentation(self);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"%@",
            [imageData base64EncodedStringWithOptions: 0]];
}

+ (UIImage *)boxblurImage:(UIImage *)image sizeNumber:(NSInteger)size blurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * size);
    boxSize = boxSize - (boxSize % 2) + 1;

    CGImageRef img = image.CGImage;

    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;

    void *pixelBuffer;
    // 从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    // 设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);

    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);

    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));

    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");

    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);

    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);

    if (error) {
        NSLog(@"error from convolution %ld", error);
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(image.CGImage));

    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

    // clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);

    free(pixelBuffer);
    CFRelease(inBitmapData);

    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);

    return returnImage;
}

+ (UIImage *)snapshotImageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

+ (UIImage *)snapshotImageWithViewOpenGL:(UIView *)view {
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = view.frame;
    [view drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

//1. 改变图像的尺寸，方便上传服务器
+ (UIImage *)scaleFromImage: (UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
