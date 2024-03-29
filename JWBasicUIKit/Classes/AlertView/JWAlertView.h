//
//  JWAlertView.h
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户传入的回调，处理消息框关闭事件
typedef void (^JWAlertViewOnDismiss)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface JWAlertView : NSObject

/*
 * 展示一个无按钮消息框，自动延时关闭，并执行回调
 *
 * @prama delay: 秒计的延时，0或负时表示默认延时2s
 * @prama onDismiss: 回调block，可以为nil
 */
+ (void)jw_showWithTitle:(NSString *)title
                  message:(NSString *)message
                    delay:(float)delayInSeconds
                onDismiss:(void(^)(void))onDismiss;

/*
 * 展示一个消息框，只有“确定”按钮，并执行回调
 *
 * @prama onDismiss: 回调block，可以为nil
 */
+ (void)jw_showWithTitle:(NSString *)title
                  message:(NSString *)message
                onDismiss:(void(^)(void))onDismiss;

/*
 * 展示一个消息框，关闭时执行回调
 *
 * @prama ...: 变长参数，0~N个字符串加一个结束符（nil或block），block类型为UIAlertViewOnDismiss
 */
+ (void)jw_showWithTitle:(NSString *)title
                  message:(NSString *)message
      buttonsAndOnDismiss:(NSString *)cancelButtonTitle, ...;

@end

NS_ASSUME_NONNULL_END
