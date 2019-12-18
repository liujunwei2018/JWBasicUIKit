//
//  UIColor+JW.m
//  XinXiCaiJiPingTai
//
//  Created by 刘君威 on 2019/1/8.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import "UIColor+JW.h"

@implementation UIColor (JW)

+ (instancetype)jwColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
}

+ (instancetype)jwColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor jwColorWithRed:red green:green blue:blue alpha:1];
}

+ (UIColor *)jw_colorForKey:(NSString *)key
{
    return [self jw_colorForKey:key alpha:1.0f];
}

+ (UIColor *)jw_colorForKey:(NSString *)key alpha:(CGFloat)alpha
{
    return [UIColor jw_colourWithHexString:key alpha:alpha];
}

+ (UIImage *)jw_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIColor *)jw_randomColor
{
    CGFloat r = arc4random() % 256 / 255.0;
    CGFloat g = arc4random() % 256 / 255.0;
    CGFloat b = arc4random() % 256 / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

+ (CALayer *)jw_colorForGradientColors:(NSArray *)colors onView:(UIView *)view {
    UIColor *color0 = colors[0];
    UIColor *color1 = colors[1];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = @[(id)color0.CGColor, (id)color1.CGColor];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    [view.layer addSublayer:gradient];
    
    return gradient;
}

#pragma mark - Others
+ (UIColor *)jw_colourWithRGBHex:(UInt32)hex alpha:(CGFloat)alpha
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

+ (UIColor *)jw_colourWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha
{
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) {
        return nil;
    }
    
    return [UIColor jw_colourWithRGBHex:hexNum alpha:alpha];
}

@end
