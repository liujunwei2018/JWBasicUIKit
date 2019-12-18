//
//  jwAlertAction.m
//  jwBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import "JWAlertAction.h"
#import "Masonry.h"
#import "UIColor+JW.h"
#import "UIFont+JW.h"
#import "UIImage+JW.h"
#import "UIImageView+WebCache.h"

typedef void (^cancel)(void);
typedef void (^choose)(void);
typedef void (^chooseMore)(int index);

static CGFloat const SHEETHEIGHT = 43.f;

#define kSCREENWIDTH (float)([UIScreen mainScreen].bounds.size.width)
#define kSCREENHEIGHT (float)([UIScreen mainScreen].bounds.size.height)

@interface JWAlertAction ()

/**
 白色背景
 */
@property (nonatomic, strong) UIView *contentView;

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 弹框内容
 */
@property (nonatomic, strong) UILabel *messageLabel;

/**
 确定按钮
 */
@property (nonatomic, strong) UIButton *defultButton;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 有取消按钮时，分隔取消按钮与确定按钮的竖线
 */
@property (nonatomic, strong) UIView *centerLineView;

/**
 内容与按钮的分界线
 */
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSLayoutConstraint *contentViewVConstraint; // 竖直方向约束
@property (nonatomic, strong) NSLayoutConstraint *contentViewHConstraint; // 水平方向约束
@property (nonatomic, strong) NSLayoutConstraint *messageLabelTop; // 内容控件顶部约束

/**
 alert样式
 */
@property (nonatomic, assign) JWAlertActionStyle alertActionStyle;

@property (nonatomic, assign) CGFloat textLabelOneLineHeight;


@property (nonatomic, copy) choose confirmParam;
@property (nonatomic, copy) cancel cancleParam;
@property (nonatomic, copy) chooseMore optionParam;

@end

@implementation JWAlertAction

- (instancetype)init {
    if (self = [super init]) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self drawAlertView];
        
    }
    return self;
}

- (void)alertActionStyle:(JWAlertActionStyle)alertActionStyle message:(NSString *)message defultTitle:(NSString *)defultTitle defultHandler:(void (^)(void))defultHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler {
    
    _alertActionStyle = alertActionStyle;
    
    if (_alertActionStyle == JWAlertActionStyleCancel) {
        [self addCancelButton];
    } else {
        _alertActionStyle = JWAlertActionStyleDefult; // 防止误传jwAlertActionStyleMore样式
    }
    
    [self setupPublicViewsConstraints];
    [_messageLabel layoutIfNeeded];

    // 文字大于1行时居左显示，等于一行时居中显示
    _messageLabel.text = @"啊哈哈呀啊哈哈";
    CGSize size = [_messageLabel sizeThatFits:(CGSizeMake(_messageLabel.frame.size.width, CGFLOAT_MIN))];
    _textLabelOneLineHeight = size.height;
    
    _messageLabel.text = message;
    size = [_messageLabel sizeThatFits:(CGSizeMake(_messageLabel.frame.size.width, CGFLOAT_MIN))];
    if (size.height > _textLabelOneLineHeight) {
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    [_defultButton setTitle:defultTitle forState:(UIControlStateNormal)];
    _confirmParam = defultHandler;
    
    [_cancelButton setTitle:cancelTitle forState:(UIControlStateNormal)];
    _cancleParam = cancelHandler;
    
    [self show];
}

- (void)alertActionStyle:(JWAlertActionStyle)alertActionStyle title:(NSString *)title message:(NSString *)message defultTitle:(NSString *)defultTitle defultHandler:(void (^)(void))defultHandler cancelTitle:(NSString *)cancelTitle cancelHandler:(void (^)(void))cancelHandler {
    
    _alertActionStyle = alertActionStyle;
    
    [self drawAlertViewContainsTitleLabel];
    
    _titleLabel.text = title;
    
    [self alertActionStyle:alertActionStyle message:message defultTitle:defultTitle defultHandler:defultHandler cancelTitle:cancelTitle cancelHandler:cancelHandler];
    
}

- (void)alertActionStyle:(JWAlertActionStyle)alertActionStyle message:(NSString *)message btnTitleArr:(NSArray *)btnTitleArr btnTextColor:(UIColor *)btnTextColor handler:(void (^)(int index))handler  {
    _alertActionStyle = alertActionStyle;
    _defultButton = nil;
    
    CGFloat top = 24;
    if (_titleLabel) {
        top = 15;
    }
    
    for (int i = 0; i < btnTitleArr.count; i++) {
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chooseBtn setBackgroundImage:[UIImage jw_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
        [chooseBtn setBackgroundImage:[UIImage jw_imageWithColor:[UIColor jw_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
        chooseBtn.titleLabel.font = [UIFont jw_normalFontOfSize:16];
        chooseBtn.tag = 1590 + i;
        [chooseBtn setTitle:btnTitleArr[i] forState:(UIControlStateNormal)];
        [chooseBtn setTitleColor:btnTextColor forState:(UIControlStateNormal)];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_contentView addSubview:chooseBtn];
        
        [chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(_messageLabel.mas_bottom).offset(SHEETHEIGHT * i + top);
            make.height.equalTo(@(SHEETHEIGHT));
        }];
        
        if (i == btnTitleArr.count - 1) {
            [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(chooseBtn.mas_bottom);
            }];
        }
    }
    
    for (int i = 0; i < btnTitleArr.count; i++) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.tag = 789456+i;
        lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
        [_contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset(0);
            make.top.equalTo(_messageLabel.mas_bottom).offset(SHEETHEIGHT * i + top);
            make.height.equalTo(@(0.5));
        }];
    }
    
    [self setupPublicViewsConstraints];
    [_messageLabel layoutIfNeeded];
    
    //文字大于1行时居左显示，等于一行时居中显示
    _messageLabel.text = @"啊哈哈呀啊哈哈";
    CGSize size = [_messageLabel sizeThatFits:(CGSizeMake(_messageLabel.frame.size.width, CGFLOAT_MIN))];
    _textLabelOneLineHeight = size.height;
    
    _messageLabel.text = message;
    size = [_messageLabel sizeThatFits:(CGSizeMake(_messageLabel.frame.size.width, CGFLOAT_MIN))];
    if (size.height > _textLabelOneLineHeight) {
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    _optionParam = handler;
    
    [self show];
}

- (void)alertActionStyle:(JWAlertActionStyle)alertActionStyle title:(NSString *)title message:(NSString *)message btnTitleArr:(NSArray *)btnTitleArr btnTextColor:(UIColor *)btnTextColor handler:(void (^)(int index))handler  {
    
    _alertActionStyle = alertActionStyle;
    
    [self drawAlertViewContainsTitleLabel];
    
    _titleLabel.text = title;
    
    [self alertActionStyle:alertActionStyle message:message btnTitleArr:btnTitleArr btnTextColor:btnTextColor handler:handler];
    
}


- (void)updateConstraints {
    
    [super updateConstraints];
}

- (void)setupPublicViewsConstraints {
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(kSCREENWIDTH - 80));
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_bottom).offset(0);
    }];

    if (_alertActionStyle != JWAlertActionStyleMore) {
        
        [self setupContentViewOfSubViewsConstraints];
        
    } else {
        
        [self setupContentViewOfArrayConstraints];
        
    }
}

// defult和cancel样式子控件布局
- (void)setupContentViewOfSubViewsConstraints {
    
    if (_titleLabel) {
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(40);
            make.right.offset(-40);
            make.top.offset(16);
        }];

        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_titleLabel.mas_centerX);
            make.top.equalTo(_titleLabel.mas_bottom).offset(15);
            make.width.equalTo(_titleLabel.mas_width);
            make.bottom.offset(-64);
        }];
        
    } else {
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(40);
                make.right.offset(-40);
                make.top.offset(24);
                make.bottom.offset(-64);

        }];       
    }
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-43));
        make.left.offset(40);
        make.right.offset(-40);
        make.centerX.offset(0);
        make.height.equalTo(@(0.5));
    }];
  
    if (_alertActionStyle == JWAlertActionStyleDefult) {
        
        [_defultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(40);
            make.right.offset(-40);
            make.height.equalTo(@(43));
            make.bottom.offset(0);
        }];
        
    } else {
        
        [_defultButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_contentView).multipliedBy(0.5);
            make.right.offset(0);
            make.bottom.offset(0);
            make.height.equalTo(@(43));
        }];

        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_defultButton.mas_width);
            make.height.equalTo(_defultButton.mas_height);
            make.left.offset(0);
            make.bottom.offset(0);
            make.height.equalTo(@(43));
        }];
        
        [_centerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.bottom.offset(0);
            make.width.equalTo(@(0.5));
            make.height.equalTo(_defultButton.mas_height);
        }];
    }
    
}
// more样式子控件布局
- (void)setupContentViewOfArrayConstraints {
    
    if (_titleLabel) {
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(40);
            make.right.offset(-40);
            make.centerX.offset(0);
            make.top.offset(16);
        }];
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_titleLabel.mas_width);
            make.centerX.offset(0);
            make.top.equalTo(_titleLabel.mas_bottom).offset(15);
        }];
    } else {
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.offset(40);
               make.right.offset(-40);
               make.centerX.offset(0);
               make.top.offset(24);
           }];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.layer.cornerRadius = 6;
}


- (void)defultButtonClick {
    [self dismiss];
    if (_confirmParam) {
        _confirmParam();
    }
}

- (void)cancelButtonClick {
    [self dismiss];
    if (_cancleParam) {
        _cancleParam();
    }
}

- (void)chooseBtnClick:(UIButton *)button {
    [self dismiss];
    if (_optionParam) {
        int index = (int)button.tag - 1590;
        _optionParam(index);
    }
}

- (void)drawAlertViewContainsTitleLabel {
        
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor jw_colorForKey:@"3d3d3d"];
    _titleLabel.font = [UIFont jw_normalFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 0;
    [_contentView addSubview:_titleLabel];
    
    _messageLabel.font = [UIFont jw_normalFontOfSize:14];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)addCancelButton {
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitleColor:[UIColor jw_colorForKey:@"999999"] forState:(UIControlStateNormal)];
    _cancelButton.titleLabel.font = [UIFont jw_normalFontOfSize:16];
    [_cancelButton setBackgroundImage:[UIImage jw_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
    [_cancelButton setBackgroundImage:[UIImage jw_imageWithColor:[UIColor jw_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
    _cancelButton.clipsToBounds = YES;
    [_contentView addSubview:_cancelButton];
    [_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
    _centerLineView = [[UIView alloc] init];
    _centerLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
    [_contentView addSubview:_centerLineView];
}

- (void)drawAlertView {
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.clipsToBounds = YES;
    [self addSubview:_contentView];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = [UIColor jw_colorForKey:@"3d3d3d"];
    _messageLabel.font = [UIFont jw_normalFontOfSize:15];
    _messageLabel.textAlignment = NSTextAlignmentLeft;
    _messageLabel.numberOfLines = 0;
    [_contentView addSubview:_messageLabel];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.08];
    [_contentView addSubview:_lineView];
    
    _defultButton = [[UIButton alloc] init];
    [_defultButton setTitleColor:[UIColor jw_colorForKey:@"3884ff"] forState:(UIControlStateNormal)];
    _defultButton.titleLabel.font = [UIFont jw_normalFontOfSize:16];
    [_defultButton setBackgroundImage:[UIImage jw_imageWithColor:[UIColor whiteColor]] forState:(UIControlStateNormal)];
    [_defultButton setBackgroundImage:[UIImage jw_imageWithColor:[UIColor jw_colorForKey:@"eeeeee"]] forState:(UIControlStateHighlighted)];
    _defultButton.clipsToBounds = YES;
    [_contentView addSubview:_defultButton];
    [_defultButton addTarget:self action:@selector(defultButtonClick) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (void)show {
    
    __weak JWAlertAction *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-(kSCREENHEIGHT / 2 + weakSelf.contentView.bounds.size.height / 2));
        }];
        [weakSelf setNeedsUpdateConstraints];
        [weakSelf updateConstraintsIfNeeded];
        
        weakSelf.contentView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        CATransform3D myTransform = CATransform3DMakeScale(0.3, 0.3, 0.3);
        myTransform.m34 = 0.01;
        myTransform = CATransform3DRotate(myTransform, -M_PI / 180 *30, 1, 0, 0);
        weakSelf.contentView.layer.transform = myTransform;
        
        [UIView animateWithDuration:0.35f animations:^{
            [weakSelf layoutIfNeeded];
            CATransform3D myTransform = CATransform3DIdentity;
            myTransform.m34 = 0;
            //沿（0，1，0）这个向量旋转30度。
            myTransform = CATransform3DRotate(myTransform, M_PI/180 , 1, 0, 0);
            weakSelf.contentView.layer.transform = myTransform;

        } completion:^(BOOL finished) {
            
            
        }];
    });
    
}

- (void)dismiss {
    
    __weak JWAlertAction *weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.2f animations:^{
            
            weakSelf.contentView.transform = CGAffineTransformMakeTranslation(kSCREENWIDTH, 0);

        } completion:^(BOOL finished) {
            
            [weakSelf removeFromSuperview];
            
        }];
    });
}



- (void)setTitleTextFont:(UIFont *)titleTextFont {
    if (titleTextFont && _titleLabel) {
        _titleLabel.font = titleTextFont;
    }
}

- (void)setTitleTextColor:(UIColor *)titleTextColor {
    if (titleTextColor && _titleLabel) {
        _titleLabel.textColor = titleTextColor;
    }
}

- (void)setMessageTextFont:(UIFont *)messageTextFont {
    if (messageTextFont && _messageLabel) {
        _messageLabel.font = messageTextFont;
    }
}

- (void)setMessageTextColor:(UIColor *)messageTextColor {
    if (messageTextColor && _messageLabel) {
        _messageLabel.textColor = messageTextColor;
    }
}

- (void)setDefultBtnTextFont:(UIFont *)defultBtnTextFont {
    if (defultBtnTextFont && _defultButton) {
        _defultButton.titleLabel.font = defultBtnTextFont;
    }
}

- (void)setDefultBtnTextColor:(UIColor *)defultBtnTextColor {
    if (defultBtnTextColor && _defultButton) {
        [_defultButton setTitleColor:defultBtnTextColor forState:(UIControlStateNormal)];
    }
}

- (void)setCancelBtnTextFont:(UIFont *)cancelBtnTextFont {
    if (cancelBtnTextFont && _cancelButton) {
        _cancelButton.titleLabel.font = cancelBtnTextFont;
    }
}

- (void)setCancelBtnTextColor:(UIColor *)cancelBtnTextColor {
    if (cancelBtnTextColor && _cancelButton) {
        [_cancelButton setTitleColor:cancelBtnTextColor forState:(UIControlStateNormal)];
    }
}

- (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment {
    _titleLabel.textAlignment = titleTextAlignment;
}

- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment {
    _messageLabel.textAlignment = messageTextAlignment;
}


@end
