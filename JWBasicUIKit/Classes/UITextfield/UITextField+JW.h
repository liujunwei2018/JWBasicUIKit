//
//  UITextField+JW.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (JW)

// 快速设置placeholder
- (void)jw_setPlaceholder:(NSString *)placeholder
          placeholderFont:(UIFont *)placeholderFont
         placeholderColor:(UIColor *)placeholderColor;

@end

NS_ASSUME_NONNULL_END
