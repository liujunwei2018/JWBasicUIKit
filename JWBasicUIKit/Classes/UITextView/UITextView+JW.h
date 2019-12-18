//
//  UITextView+JW.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (JW)

@property (nonatomic, readonly) UITextView *placeholderTextView;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

@end

NS_ASSUME_NONNULL_END
