//
//  UIButton+Normal.h
//  ToolsTest
//
//  Created by Luo on 2018/11/12.
//  Copyright © 2018年 Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Normal)


/**
 创建一个normal的button
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize backgroundColor:(UIColor *)backgroundColor;

/**
 创建一个normal的button
 */
+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize;
@end
