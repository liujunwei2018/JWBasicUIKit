//
//  jwActionSheet.m
//  jwBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import "JWActionSheet.h"
#import "Masonry.h"
#import "UIImage+JW.h"
#import "UIColor+JW.h"
#import "UIFont+JW.h"

#define kJWActionSheetSafeBottomHeight \
({ \
    CGFloat bottom = 0.f; \
    if(@available(iOS 11.0, *)) { \
        bottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom; \
    } \
    (bottom); \
})
#define kSCREENWIDTH (float)([UIScreen mainScreen].bounds.size.width)
#define kSCREENHEIGHT (float)([UIScreen mainScreen].bounds.size.height)
#define SHEETBOTTOM (8.5f+kJWActionSheetSafeBottomHeight)

static CGFloat const SHEETHEIGHT = 57.f;

typedef void (^cancel)(void);
typedef void (^choose)(int index);


@interface JWActionSheet ()

@property (nonatomic, strong) UIView *actionSheetView;
@property (nonatomic, strong) UIView *defaultActionSheetView;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat count;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, copy) choose confirmParam;
@property (nonatomic, copy) cancel cancleParam;
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) NSArray *titleArr;

@end

@implementation JWActionSheet

- (instancetype)init {
    
    if (self = [super init]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self drawSubViews];
        
        [self setNeedsUpdateConstraints];
        
    }
    return self;
}

- (instancetype)initCancelActionWithTitle:(NSString *)title handler:(void (^)(void))handler {
    if (self = [super init]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        [self drawSubViews];
        
        [self setNeedsUpdateConstraints];
        
        [self addCancelWithTitle:title handler:handler];
        
    }
    return self;
}

- (void)addActionWithTitleArr:(NSArray *)titleArr handler:(void (^)(int index))handler {
    
    _titleArr = titleArr;
    
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *chooseBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [chooseBtn setBackgroundImage:[UIImage jw_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        [chooseBtn setBackgroundImage:[UIImage jw_imageWithColor:[UIColor jw_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
        chooseBtn.titleLabel.font = [UIFont jw_normalFontOfSize:16];
        chooseBtn.tag = 1590 + i;
        [chooseBtn setTitle:titleArr[i] forState:(UIControlStateNormal)];
        [chooseBtn setTitleColor:[UIColor jw_colorForKey:@"333333"] forState:(UIControlStateNormal)];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_defaultActionSheetView addSubview:chooseBtn];
        
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(SHEETHEIGHT * i);
            make.height.equalTo(@(SHEETHEIGHT));
        }];
    }
    
    for (int i = 0; i < titleArr.count - 1; i++) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.tag = 789456+i;
        lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        [_defaultActionSheetView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.offset(SHEETHEIGHT * (i + 1));
            make.height.equalTo(@(0.5));
        }];
    }
    _count = titleArr.count;
    if (_top == 0) {
        _top = (kSCREENHEIGHT - SHEETHEIGHT * _count  - SHEETBOTTOM);
    } else {
        _top = (_top - SHEETHEIGHT * _count - 7);
    }
    
    _confirmParam = handler;
    
    [self show];
}


- (void)addCancelWithTitle:(NSString *)title handler:(void (^)(void))handler {
    _top = kSCREENHEIGHT - SHEETHEIGHT - SHEETBOTTOM;
    
    UIButton *cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [cancelBtn setBackgroundImage:[UIImage jw_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
    [cancelBtn setBackgroundImage:[UIImage jw_imageWithColor:[UIColor jw_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
    cancelBtn.clipsToBounds = YES;
    cancelBtn.titleLabel.font = [UIFont jw_normalFontOfSize:16];
    [cancelBtn setTitle:title forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:[UIColor jw_colorForKey:@"ff9f69"] forState:(UIControlStateNormal)];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [_actionSheetView addSubview:cancelBtn];
    _cancleParam = handler;
    _cancelBtn = cancelBtn;
}

- (void)show {
    __weak JWActionSheet *weakSelf = self;
    double delayInSeconds = 0.1f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf setNeedsUpdateConstraints];
        [weakSelf updateConstraintsIfNeeded];
        [UIView animateWithDuration:0.2f animations:^{
            [weakSelf layoutIfNeeded];
        }];
    });
}

- (void)dismiss {
    [self removeFromSuperview];
}

- (void)cancelBtnClick {
    [self dismiss];
    if (_cancleParam) {
        _cancleParam();
    }
}

- (void)chooseBtnClick:(UIButton *)button {
    [self dismiss];
    if (_confirmParam) {
        _confirmParam((int)button.tag - 1590);
    }
}

- (void)updateConstraints {
    if (!self.didSetupConstraints) {
        if (_cancelBtn) {
            [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(SHEETHEIGHT));
                make.left.offset(10);
                make.right.offset(-10);
                make.bottom.offset(-SHEETBOTTOM);
            }];
        }
        if (_titleArr.count) {
            
            for (int i = 0; i < _titleArr.count; i++) {
                
                UIButton *chooseBtn = [_defaultActionSheetView viewWithTag:1590 + i];
                [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.offset(0);
                    make.top.offset(SHEETHEIGHT * i);
                    make.height.equalTo(@(SHEETHEIGHT));
                }];
                
                if (i > 0) {
                    UIView *lineView = [_defaultActionSheetView viewWithTag:789456+i];
                    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.offset(0);
                        make.top.offset(SHEETHEIGHT * (i + 1));
                        make.height.equalTo(@(0.5));
                    }];
                }
                
            }
        }
        [_defaultActionSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.right.offset(-10);
            make.top.offset(0);
            make.height.equalTo(@(SHEETHEIGHT * _count));
        }];
            
      
        
        CGFloat actionSheetViewHeight = (kSCREENHEIGHT - _top);
        [_actionSheetView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.height.equalTo(@(actionSheetViewHeight));
            make.bottom.equalTo(self.mas_bottom).offset(actionSheetViewHeight);
         }];

        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        
        self.didSetupConstraints = YES;
        
    } else {
        [_actionSheetView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(0);
        }];
    }
    
    [super updateConstraints];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_defaultActionSheetView) {
        _defaultActionSheetView.layer.cornerRadius = 8;
    }
    if (_cancelBtn) {
        _cancelBtn.layer.cornerRadius = 8;
    }
}

- (void)drawSubViews {
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
    
    _actionSheetView = [[UIView alloc] init];
    _actionSheetView.backgroundColor = [UIColor clearColor];
    [self addSubview:_actionSheetView];
    
    _defaultActionSheetView = [[UIView alloc] init];
    _defaultActionSheetView.backgroundColor = [UIColor whiteColor];
    _defaultActionSheetView.clipsToBounds = YES;
    [_actionSheetView addSubview:_defaultActionSheetView];
}

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor {
    [_cancelBtn setTitleColor:cancelButtonTextColor forState:UIControlStateNormal];
}

@end
