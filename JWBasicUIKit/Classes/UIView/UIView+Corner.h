//
//  UIView+Corner.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Corner)

// 设置圆角 corners指定哪几个角圆角
- (void)jw_setCornerRadii:(CGSize)cornerRadii forRoundingCorners:(UIRectCorner)corners;

@end

NS_ASSUME_NONNULL_END
