//
//  UIImage+JW.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JWImageColorsLayoutDirection) {
    JWImageColorsLayoutDirectionHorizontal,
    JWImageColorsLayoutDirectionVertical,
    JWImageColorsLayoutDirectionDiagonalTopLeft,       //  左上右下对角线
    JWImageColorsLayoutDirectionDiagonalBottomLeft,    //  左下右上对角线
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JW)

// 将UIColor生成UIImage
+ (UIImage *)jw_imageWithColor:(UIColor *)color;

// 修改image的颜色
- (UIImage *)jw_imageWithTintColor:(UIColor *)tintColor;

//base64加密成字符串
- (NSString *)imageEncodeData;

// 渐变色分水平分布和垂直分布
+ (UIImage *)jw_imageWithRect:(CGRect)rect
                   startColor:(CGColorRef)startColor
                     endColor:(CGColorRef)endColor
              layoutDirection:(JWImageColorsLayoutDirection)direction;

/**
 gif转为image
 @param gifName 图片名称
 @return 图片
 */
+ (UIImage *)jw_imageWithGifNamed:(NSString *)gifName;

/**
 gif转image数组
 @param gifName 图片名称
 @return image数组
 */
+ (NSArray<UIImage *> *)jw_gifToImagesWithGifName:(NSString *)gifName;

/**
 模糊图片处理
 @param image 图片
 @param size 根据图片尺寸设置
 @param blur 模糊度
 */
+ (UIImage *)boxblurImage:(UIImage *)image sizeNumber:(NSInteger)size blurNumber:(CGFloat)blur;

/**
 屏幕截图
 @param view 视图
 */
+ (UIImage *)snapshotImageWithView:(UIView *)view;
/**
 屏幕截图
 @param view 视图
 */
+ (UIImage *)snapshotImageWithViewOpenGL:(UIView *)view;

/**
 图片尺寸缩放
 @param image 图片
 @param size 尺寸
 */
+ (UIImage *)scaleFromImage: (UIImage *)image toSize:(CGSize)size;


@end

NS_ASSUME_NONNULL_END
