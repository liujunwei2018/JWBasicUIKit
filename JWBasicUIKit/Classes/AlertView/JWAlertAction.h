//
//  JWAlertAction.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JWAlertActionStyle) {
    JWAlertActionStyleDefult = 0, // 只有一个按钮时
    JWAlertActionStyleCancel, // 包含取消按钮(即，两个按钮的情况)
    JWAlertActionStyleMore // 大于等于三个选项
};

NS_ASSUME_NONNULL_BEGIN

@interface JWAlertAction : UIView

/***********  如果对字体的颜色等等有定制需求，需要先设置属性再调用方法  ************/

@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIFont *titleTextFont;

@property (nonatomic, strong) UIColor *messageTextColor;
@property (nonatomic, strong) UIFont *messageTextFont;

@property (nonatomic, strong) UIColor *defultBtnTextColor;
@property (nonatomic, strong) UIFont *defultBtnTextFont;

@property (nonatomic, strong) UIColor *cancelBtnTextColor;
@property (nonatomic, strong) UIFont *cancelBtnTextFont;

@property (nonatomic) NSTextAlignment titleTextAlignment; // 标题默认左对齐
@property (nonatomic) NSTextAlignment messageTextAlignment; // 内容默认左对齐

/***********  如果对字体的颜色等等有定制需求，需要先设置属性再调用方法  ************/


/**
 没有标题的alertView

 @param alertActionStyle 弹窗样式，此方法只支持alertActionStyle为XNBAlertActionStyleDefult或者XNBAlertActionStyleCancel
 @param message 提示内容
 @param defultTitle 确定按钮标题
 @param defultHandler 确定按钮点击方法
 @param cancelTitle 取消按钮标题 （这里取消按钮特指左边按钮）
 @param cancelHandler 取消按钮的点击方法
 */
- (void)alertActionStyle:(JWAlertActionStyle)alertActionStyle message:(NSString *)message defultTitle:(NSString *)defultTitle defultHandler:(void (^)(void))defultHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler;

/**
 有标题的alertView

 @param alertActionStyle alertActionStyle 弹窗样式，此方法只支持alertActionStyle为XNBAlertActionStyleDefult或者XNBAlertActionStyleCancel
 @param title 提示标题
 @param message 提示内容
 @param defultTitle 确定按钮标题
 @param defultHandler 确定按钮点击方法
 @param cancelTitle 取消按钮标题 （这里取消按钮特指左边按钮）
 @param cancelHandler 取消按钮的点击方法
 */
- (void)alertActionStyle:(JWAlertActionStyle)alertActionStyle title:(NSString *)title message:(NSString *)message defultTitle:(NSString *)defultTitle defultHandler:(void (^)(void))defultHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler;


- (void)alertActionStyle:(JWAlertActionStyle)alertActionStyle message:(NSString *)message
             btnTitleArr:(NSArray *)btnTitleArr btnTextColor:(UIColor *)btnTextColor handler:(void (^)(int index))handler;

- (void)alertActionStyle:(JWAlertActionStyle)alertActionStyle title:(NSString *)title message:(NSString *)message
             btnTitleArr:(NSArray *)btnTitleArr btnTextColor:(UIColor *)btnTextColor handler:(void (^)(int index))handler;


@end

NS_ASSUME_NONNULL_END
