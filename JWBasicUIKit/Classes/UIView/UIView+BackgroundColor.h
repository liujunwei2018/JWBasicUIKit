//
//  UIView+BackgroundColor.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BackgroundColor)

/**
  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
 */
-(void)jw_setGradientBackgroundColorWithStartColor:(UIColor *)color EndColor:(UIColor *)endColor StartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint;

@end

NS_ASSUME_NONNULL_END
