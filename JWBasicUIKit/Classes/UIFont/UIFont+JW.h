//
//  UIFont+JW.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (JW)

// 细体
+ (UIFont *)jw_thinFontOfSize:(CGFloat)fontSize;

// 正常
+ (UIFont *)jw_normalFontOfSize:(CGFloat)fontSize;

// 粗体
+ (UIFont *)jw_boldFontOfSize:(CGFloat)fontSize;

// PingFangSC-Medium
+ (UIFont *)jw_PingFangSCMediumOfSize:(CGFloat)fontSize;

// PingFangSC-Regular
+ (UIFont *)jw_PingFangSCRegularOfSize:(CGFloat)fontSize;

+ (UIFont *)jw_PingFangSCSemiboldOfSize:(CGFloat)fontSize;
+ (UIFont *)jw_PingFangSCLightOfSize:(CGFloat)fontSize;
// 数字字体
+ (UIFont *)jw_DINMittelschriftOfSize:(CGFloat)fontSize;

@end

NS_ASSUME_NONNULL_END
