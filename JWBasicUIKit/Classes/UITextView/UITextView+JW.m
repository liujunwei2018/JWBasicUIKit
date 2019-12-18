//
//  UITextView+JW.m
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import "UITextView+JW.h"
#import <objc/runtime.h>

@implementation UITextView (JW)

+ (void)load {
    [[self class] swizzlingMethodWithClass:[self class] originalSelector:NSSelectorFromString(@"dealloc") swizzledSelector:@selector(swizzlingDealloc)];
}

- (void)swizzlingDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (textView) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self swizzlingDealloc];
}

#pragma mark - ObservingKeys

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset",
             @"textContainer.exclusionPaths"];
}


#pragma mark - PlaceholderTextView

- (UITextView *)placeholderTextView {
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextView));
    if (!textView) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" ";
        self.attributedText = originalText;
        
        textView = [[UITextView alloc] init];
        textView.textColor = [UIColor lightGrayColor];
        textView.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(placeholderTextView), textView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        self.needsUpdateFont = YES;
        [self updatePlaceholderTextView];
        self.needsUpdateFont = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderTextView)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
        
        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return textView;
}

#pragma mark - Placeholder

- (NSString *)placeholder {
    return self.placeholderTextView.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderTextView.text = placeholder;
    [self updatePlaceholderTextView];
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderTextView.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderTextView.attributedText = attributedPlaceholder;
    [self updatePlaceholderTextView];
}

#pragma mark PlaceholderColor

- (UIColor *)placeholderColor {
    return self.placeholderTextView.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderTextView.textColor = placeholderColor;
}

#pragma mark - NeedsUpdateFont

- (BOOL)needsUpdateFont {
    return [objc_getAssociatedObject(self, @selector(needsUpdateFont)) boolValue];
}

- (void)setNeedsUpdateFont:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"font"]) {
        self.needsUpdateFont = (change[NSKeyValueChangeNewKey] != nil);
    }
    [self updatePlaceholderTextView];
}


#pragma mark - Update

- (void)updatePlaceholderTextView {
    if (self.text.length) {
        [self.placeholderTextView removeFromSuperview];
    } else {
        [self insertSubview:self.placeholderTextView atIndex:0];
    }
    
    if (self.needsUpdateFont) {
        self.placeholderTextView.font = self.font;
        self.needsUpdateFont = NO;
    }
    
    self.placeholderTextView.textAlignment = self.textAlignment;
    self.placeholderTextView.textContainer.exclusionPaths = self.textContainer.exclusionPaths;
    self.placeholderTextView.textContainerInset = self.textContainerInset;
    self.placeholderTextView.frame = self.bounds;
    self.placeholderTextView.backgroundColor = [UIColor clearColor];
}

#pragma mark - Private Method

+ (void)swizzlingMethodWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzliedMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzliedMethod), method_getTypeEncoding(swizzliedMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(swizzliedMethod, originalMethod);
    }
}

@end
