//
//  UILabel+XXCJ_Label.m
//  XinXiCaiJiPingTai
//
//  Created by 刘君威 on 2019/1/9.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import "UILabel+Normal.h"

@implementation UILabel (Normal)

+ (instancetype)labelWithTitle:(NSString *)title fontSize:(CGFloat)fontSize {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = title;
    
    return label;
}

+ (instancetype)labelWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = titleColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = title;
    
    return label;
}

@end
