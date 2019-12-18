//
//  JWAutoScrollLabel.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JWAutoScrollDirectionType){
    JWAutoScrollDirectionType_Right,       // 向右滚动
    JWAutoScrollDirectionType_Left,        // 向左滚动
    JWAutoScrollDirectionType_Top,         // 向上滚动
    JWAutoScrollDirectionType_Bottom       // 向下滚动
};

NS_ASSUME_NONNULL_BEGIN

@interface JWAutoScrollLabel : UIView

@property (nonatomic, assign) JWAutoScrollDirectionType direction;
@property (nonatomic, assign) CGFloat scrollSpeed;              // 滚动速度, 默认30
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;// 自动滚动的时间间隔，默认1.5
@property (nonatomic, assign) NSUInteger labelSpacing;          // 滚动的label的间距，默认20

@property (nonatomic, assign) UIViewAnimationOptions animationOptions;

@property (nonatomic, assign, readonly) BOOL scrolling;         // 是否滚动

@property (nonatomic, copy, nullable) NSString *text;
@property (nonatomic, copy, nullable) NSAttributedString *attributedText;
@property (nonatomic, strong, nonnull) UIColor *textColor;
@property (nonatomic, strong, nonnull) UIFont *font;
@property (nonatomic, strong, nullable) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) NSTextAlignment textAlignment;

- (void)setText:(NSString * __nullable)text refreshLabels:(BOOL)refresh;

- (void)setAttributedText:(NSAttributedString * __nullable)theText refreshLabels:(BOOL)refresh;
@end

NS_ASSUME_NONNULL_END
