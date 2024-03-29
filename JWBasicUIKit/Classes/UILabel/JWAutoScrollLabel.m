//
//  JWAutoScrollLabel.m
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import "JWAutoScrollLabel.h"

static const NSUInteger kLabelCount = 2;
static const CGFloat kDefaultFadeLength = 7.f;
static const NSUInteger kDefaultAutoScrollSpeed = 30;
static const NSUInteger kDefaultLabelBufferSpace = 20;
static const CGFloat kDefaultAutoScrollInterval = 1.5f;

static void each_object(NSArray *objects, void (^block)(UILabel * label)) {
    for (UILabel * label in objects) {
        block(label);
    }
}

#define EACH_LABEL(ATTR, VALUE) each_object(self.labels, ^(UILabel *label) { label.ATTR = VALUE; });

@interface JWAutoScrollLabel () <UIScrollViewDelegate>

@property (nonatomic, strong) NSArray * labels;
@property (nonatomic, strong, readonly) UILabel * scrollLabel;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation JWAutoScrollLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        if (self) {
            self.frame = frame;
            [self initialize];
        }
    }
    return self;
}

#pragma mark - 初始化
- (void)initialize {
    // 创建label数组
    NSMutableSet * labelSet = [[NSMutableSet alloc] init];
    
    for (NSInteger i = 0; i < kLabelCount; i++) {
        UILabel * label = [UILabel new];
        label.backgroundColor = [UIColor clearColor];
        label.autoresizingMask = self.autoresizingMask;
        label.frame = CGRectMake(0, 0, 50, 50);
        [self.scrollView addSubview:label];
        [labelSet addObject:label];
    }
    self.labels = [labelSet.allObjects copy];
    
    // 初始化设置
    _direction = JWAutoScrollDirectionType_Left;
    _scrollSpeed = kDefaultAutoScrollSpeed;
    self.autoScrollInterval = kDefaultAutoScrollInterval;
    self.labelSpacing = kDefaultLabelBufferSpace;
    self.animationOptions = UIViewAnimationOptionCurveLinear;
    self.scrollLabel.textAlignment = self.textAlignment;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self didChangeFram];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    [self didChangeFram];
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        [self scrollLabelIfNeeded];
    }
}

- (void)didChangeFram {
    [self refreshUI];
    [self applyGradientMaskForFadeLength:kDefaultFadeLength enableFade:self.scrolling];
}

- (void)setText:(NSString *)theText {
    [self setText:theText refreshLabels:YES];
}

- (void)setText:(NSString *)theText refreshLabels:(BOOL)refresh {
    // 忽略相同文本的变化
    if ([theText isEqualToString:self.text]) {
        return;
    }
    
    EACH_LABEL(text, theText)
    
    if (refresh) {
        [self refreshUI];
    }
}

- (NSString *)text {
    return self.scrollLabel.text;
}

- (void)setAttributedText:(NSAttributedString *)theText {
    [self setAttributedText:theText refreshLabels:YES];
}

- (void)setAttributedText:(NSAttributedString *)theText refreshLabels:(BOOL)refresh {
    if ([theText.string isEqualToString:self.attributedText.string]) {
        return;
    }
    
    EACH_LABEL(attributedText, theText)
    
    if (refresh) {
        [self refreshUI];
    }
}

- (NSAttributedString *)attributedText {
    return self.scrollLabel.attributedText;
}

- (void)setTextColor:(UIColor *)color {
    EACH_LABEL(textColor, color)
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
}

- (UIColor *)textColor {
    return self.scrollLabel.textColor;
}

- (void)setFont:(UIFont *)font {
    if (self.scrollLabel.font == font) {
        return;
    }
    
    EACH_LABEL(font, font)
    
    [self refreshUI];
    [self invalidateIntrinsicContentSize];
}

- (UIFont *)font {
    return self.scrollLabel.font;
}

- (void)setShadowColor:(UIColor *)color {
    EACH_LABEL(shadowColor, color)
}

- (UIColor *)shadowColor {
    return self.scrollLabel.shadowColor;
}

- (void)setShadowOffset:(CGSize)offset {
    EACH_LABEL(shadowOffset, offset)
}

- (CGSize)shadowOffset {
    return self.scrollLabel.shadowOffset;
}

- (void)setScrollSpeed:(CGFloat)scrollSpeed {
    _scrollSpeed = scrollSpeed;
    [self scrollLabelIfNeeded];
}

- (void)setDirection:(JWAutoScrollDirectionType)direction {
    _direction = direction;
    [self scrollLabelIfNeeded];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)scrollLabel {
    return self.labels.firstObject;
}


- (void)enableShadow {
    _scrolling = YES;
    [self applyGradientMaskForFadeLength:kDefaultFadeLength enableFade:YES];
}

- (void)scrollLabelIfNeeded {
    if (!self.text.length) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.scrollLabel.bounds);
    CGFloat height = CGRectGetHeight(self.scrollLabel.bounds);
    NSTimeInterval duration = 0;
    if (self.direction != JWAutoScrollDirectionType_Right && self.direction != JWAutoScrollDirectionType_Left) {
        if (height <= CGRectGetHeight(self.bounds)) {
            return;
        }
        duration = height / self.scrollSpeed;
    } else {
        if (width <= CGRectGetWidth(self.bounds)) {
            return;
        }
        duration = width / self.scrollSpeed;
    }
    // 取消之前执行的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(scrollLabelIfNeeded) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(enableShadow) object:nil];
    [self.scrollView.layer removeAllAnimations];
    
    switch (self.direction) {
        case JWAutoScrollDirectionType_Left:
            self.scrollView.contentOffset = CGPointZero;
            break;
        case JWAutoScrollDirectionType_Right:
            self.scrollView.contentOffset = CGPointMake(width + self.labelSpacing, 0);
            break;
        case JWAutoScrollDirectionType_Top:
            self.scrollView.contentOffset = CGPointZero;
            break;
        case JWAutoScrollDirectionType_Bottom:
            self.scrollView.contentOffset = CGPointMake(0, height - 10 - CGRectGetHeight(self.bounds));
            break;
    }
    // 在延迟后加上阴影
    [self performSelector:@selector(enableShadow) withObject:nil afterDelay:self.autoScrollInterval];
    
    // 滚动动画
    [UIView animateWithDuration:duration delay:self.autoScrollInterval options:UIViewAnimationOptionRepeat | self.animationOptions animations:^{
        
        switch (self.direction) {
            case JWAutoScrollDirectionType_Left:
                self.scrollView.contentOffset = CGPointMake(width + self.labelSpacing, 0);
                break;
            case JWAutoScrollDirectionType_Right:
                self.scrollView.contentOffset = CGPointZero;
                break;
            case JWAutoScrollDirectionType_Top:
                self.scrollView.contentOffset = CGPointMake(0, CGRectGetHeight(self.scrollLabel.bounds) + self.labelSpacing);
                break;
            case JWAutoScrollDirectionType_Bottom:
                self.scrollView.contentOffset = CGPointZero;
                
                break;
        }
        
    } completion:^(BOOL finished) {
        self->_scrolling = NO;
        // 移除阴影
        [self applyGradientMaskForFadeLength:kDefaultFadeLength enableFade:NO];
        // 完成后循调用
        if (finished) {
            [self performSelector:@selector(scrollLabelIfNeeded)];
        }
    }];
}

#pragma mark - 刷新UI
- (void)refreshUI {
    __block float offset = 0;
    
    each_object(self.labels, ^(UILabel *label) {
        [label sizeToFit];
        
        CGRect frame = label.frame;
        if (self.direction != JWAutoScrollDirectionType_Right && self.direction != JWAutoScrollDirectionType_Left) {
            // 动态获取长度和高度
            NSDictionary * attribute = [NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil];
            CGSize sizeWord = [@"一" boundingRectWithSize:self.bounds.size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
            CGFloat wordWidth = sizeWord.width;
            CGSize sizeStr = [self.text boundingRectWithSize:CGSizeMake(wordWidth, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
            CGFloat wordHeight = sizeStr.height;
            
            frame.origin = CGPointMake((CGRectGetWidth(self.frame) / 2) - (wordWidth / 2), offset);
            frame.size = CGSizeMake(wordWidth, wordHeight);
            label.frame = frame;
            label.numberOfLines = 0;
            offset += CGRectGetHeight(label.bounds) + self.labelSpacing;
            
        } else {
            frame.origin = CGPointMake(offset, 0);
            frame.size.height = CGRectGetHeight(self.bounds);
            label.frame = frame;
            offset += CGRectGetWidth(label.bounds) + self.labelSpacing;
            // 重新定位label在scrollview中的位置
            label.center = CGPointMake(label.center.x, roundf(self.center.y - CGRectGetMinY(self.frame)));
        }
    });
    
    [self.scrollView.layer removeAllAnimations];
    
    // 判断当前scrollLabel是否大于self的宽度，如果是就开始滚动
    if (CGRectGetWidth(self.scrollLabel.bounds) > CGRectGetWidth(self.bounds)) {
        CGSize size = CGSizeMake(CGRectGetWidth(self.scrollLabel.bounds) + CGRectGetWidth(self.bounds) + self.labelSpacing,  CGRectGetHeight(self.bounds));
        self.scrollView.contentSize = size;
        
        EACH_LABEL(hidden, NO);
        
        [self applyGradientMaskForFadeLength:kDefaultFadeLength enableFade:self.scrolling];
        [self scrollLabelIfNeeded];
        
    } else if (CGRectGetHeight(self.scrollLabel.bounds) > CGRectGetHeight(self.bounds)) {// 判断当前scrollLabel是否大于self的高度，如果是就开始滚动
        CGSize size = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.scrollLabel.bounds) + self.labelSpacing);
        self.scrollView.contentSize = size;
        
        EACH_LABEL(hidden, NO);
        
        [self applyGradientMaskForFadeLength:kDefaultFadeLength enableFade:self.scrolling];
        [self scrollLabelIfNeeded];
        
    } else {
        // 隐藏其他label
        EACH_LABEL(hidden, self.scrollLabel != label);
        
        // 调整scrollView和scrollLabel
        self.scrollView.contentSize = self.bounds.size;
        self.scrollLabel.frame = self.bounds;
        self.scrollLabel.hidden = NO;
        self.scrollLabel.textAlignment = self.textAlignment;
        
        [self.scrollView.layer removeAllAnimations];
        
        [self applyGradientMaskForFadeLength:0 enableFade:NO];
    }
}

#pragma mark - 梯度褪色
- (void)applyGradientMaskForFadeLength:(CGFloat)fadeLength enableFade:(BOOL)fade {
    CGFloat labelWidth = CGRectGetWidth(self.scrollLabel.bounds);
    CGFloat labelHeight = CGRectGetHeight(self.scrollLabel.bounds);
    if (self.direction != JWAutoScrollDirectionType_Right && self.direction != JWAutoScrollDirectionType_Left) {
        if (labelHeight <= CGRectGetWidth(self.bounds)) {
            fadeLength = 0;
        }
    } else {
        if (labelWidth <= CGRectGetWidth(self.bounds)) {
            fadeLength = 0;
        }
    }
    
    if (fadeLength) {
        // 重新创建梯度mask和消失长度
        CAGradientLayer * gradientMask = [CAGradientLayer layer];
        
        gradientMask.bounds = self.layer.bounds;
        gradientMask.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        
        gradientMask.shouldRasterize = YES;
        gradientMask.rasterizationScale = [UIScreen mainScreen].scale;
        
        CGFloat fadePoint = 0;
        
        if (self.direction != JWAutoScrollDirectionType_Right && self.direction != JWAutoScrollDirectionType_Left) {
            gradientMask.startPoint = CGPointMake(CGRectGetMidX(self.frame), 0);
            gradientMask.endPoint = CGPointMake(CGRectGetMidX(self.frame), 1);
            fadePoint = fadeLength / CGRectGetHeight(self.bounds);
        } else {
            gradientMask.startPoint = CGPointMake(0, CGRectGetMidY(self.frame));
            gradientMask.endPoint = CGPointMake(1, CGRectGetMidY(self.frame));
            fadePoint = fadeLength / CGRectGetWidth(self.bounds);
        }
        
        // 设置渐变mask颜色和位置
        id transparent = (id)[UIColor clearColor].CGColor;
        id opaque = (id)[UIColor blackColor].CGColor;
        gradientMask.colors = @[transparent, opaque, opaque, transparent];
        
        // 计算褪色
        NSNumber * leftFadePoint = @(fadePoint);
        NSNumber * rightFadePoint = @(1 - fadePoint);
        if (!fade) {
            switch (self.direction) {
                case JWAutoScrollDirectionType_Left:
                    leftFadePoint = @0;
                    break;
                case JWAutoScrollDirectionType_Right:
                    leftFadePoint = @0;
                    rightFadePoint = @1;
                    break;
                case JWAutoScrollDirectionType_Top:
                    leftFadePoint = @0;
                    break;
                case JWAutoScrollDirectionType_Bottom:
                    leftFadePoint = @0;
                    rightFadePoint = @1;
                    break;
                    
            }
        }
        
        // 将计算结果交给mask
        gradientMask.locations = @[@0, leftFadePoint, rightFadePoint, @1];
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.layer.mask = gradientMask;
        [CATransaction commit];
    } else {
        // 删除梯度mask和褪色长度
        self.layer.mask = nil;
    }
}


@end
