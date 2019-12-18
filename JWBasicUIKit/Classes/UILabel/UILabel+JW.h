//
//  UILabel+JW.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JW)

// 返回对应alignment的label
+ (instancetype)jw_labelWithTextAlignment:(NSTextAlignment)alignment;

/**
 快速实例化一个UILabel
 @param font    字体大小
 @param bColor  背景色
 @param tColor  字体颜色
 @param alignment 文本排列
 @param isWarp  是否换行
 @return        UIlabel
 */
+ (instancetype)jw_labelWithFont:(UIFont *)font
                  backGroundColor:(UIColor *)bColor
                        textColor:(UIColor *)tColor
                    textAlignment:(NSTextAlignment)alignment
                           isWarp:(BOOL)isWarp;

+ (void)jw_changeLineSpaceForLabel:(UILabel *)label lineSpace:(float)lineSpace;
+ (void)jw_changeWordSpaceForLabel:(UILabel *)label lineSpace:(float)lineSpace;
+ (void)jw_changeSpaceForLabel:(UILabel *)label lineSpace:(float)lineSpace wordSpace:(float)wordSpace;

@end

NS_ASSUME_NONNULL_END
