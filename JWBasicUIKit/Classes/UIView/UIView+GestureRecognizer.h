//
//  UIView+GestureRecognizer.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^JWGestureRecognizerActionBlock)(UIGestureRecognizer *gestureRecognizer);

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GestureRecognizer)

// 移除手势
- (void)jw_removeAllGestures;

// single tapped
- (void)jw_whenSingleTapped:(JWGestureRecognizerActionBlock )block;

// double tapped
- (void)jw_whenDoubleTapped:(JWGestureRecognizerActionBlock )block;

// long pressed
- (void)jw_whenLongPressed:(JWGestureRecognizerActionBlock )block;

@end

NS_ASSUME_NONNULL_END
