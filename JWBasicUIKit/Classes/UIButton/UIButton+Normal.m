//
//  UIButton+Normal.m
//  ToolsTest
//
//  Created by Luo on 2018/11/12.
//  Copyright © 2018年 Luo. All rights reserved.
//

#import "UIButton+Normal.h"

@implementation UIButton (Normal)

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize backgroundColor:(UIColor *)backgroundColor {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle: title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    button.backgroundColor = backgroundColor;
    
    return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle: title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    
    return button;
}
@end
