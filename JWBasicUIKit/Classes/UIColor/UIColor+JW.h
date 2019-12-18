//
//  UIColor+JW.h
//  XinXiCaiJiPingTai
//
//  Created by 刘君威 on 2019/1/8.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JW)

+ (instancetype)jwColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

+ (instancetype)jwColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

+ (UIColor *)jw_colorForKey:(NSString *)key;
+ (UIColor *)jw_colorForKey:(NSString *)key alpha:(CGFloat)alpha;
+ (UIImage *)jw_imageWithColor:(UIColor *)color;
+ (UIColor *)jw_randomColor;

+ (CALayer *)jw_colorForGradientColors:(NSArray *)colors onView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
