//
//  UIView+JW.h
//  GongAnFuDeng
//
//  Created by 刘君威 on 2019/4/10.
//  Copyright © 2019 liujunwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic,assign)  CGFloat width;
@property (nonatomic,assign)  CGFloat height;

@property (nonatomic,assign)  CGFloat top;
@property (nonatomic,assign)  CGFloat left;
@property (nonatomic,assign)  CGFloat bottom;
@property (nonatomic,assign)  CGFloat right;

@property (nonatomic,assign)  CGPoint origin;
@property (nonatomic,assign)  CGSize  size;

@property (nonatomic,assign)  CGFloat centerX;
@property (nonatomic,assign)  CGFloat centerY;

@end

NS_ASSUME_NONNULL_END
