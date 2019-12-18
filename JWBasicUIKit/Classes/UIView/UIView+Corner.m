//
//  UIView+Corner.m
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import "UIView+Corner.h"


@implementation UIView (Corner)

- (void)jw_setCornerRadii:(CGSize)cornerRadii forRoundingCorners:(UIRectCorner)corners {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

@end
