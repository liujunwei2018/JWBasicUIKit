//
//  UILabel+XXCJ_Label.h
//  XinXiCaiJiPingTai
//
//  Created by 刘君威 on 2019/1/9.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (Normal)

+ (instancetype)labelWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;
+ (instancetype)labelWithTitle:(NSString *)title titleColor:(UIColor *)titleColor fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
