//
//  UIScrollView+JW.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (JW)

@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) CGFloat contentOffsetY;

@property (nonatomic, assign) CGFloat contentInsetTop;
@property (nonatomic, assign) CGFloat contentInsetLeft;
@property (nonatomic, assign) CGFloat contentInsetBottom;
@property (nonatomic, assign) CGFloat contentInsetRight;

@property (nonatomic, assign) CGFloat scrollIndicatorInsetTop;
@property (nonatomic, assign) CGFloat scrollIndicatorInsetLeft;
@property (nonatomic, assign) CGFloat scrollIndicatorInsetBottom;
@property (nonatomic, assign) CGFloat scrollIndicatorInsetRight;

@property (nonatomic, assign) CGFloat contentSizeWidth;
@property (nonatomic, assign) CGFloat contentSizeHeight;

- (void)jw_stopScrolling;

- (BOOL)jw_isScrollToBottom;
- (BOOL)jw_isScrollToBottomWithDeviation:(CGFloat)deviation;

@end

NS_ASSUME_NONNULL_END
