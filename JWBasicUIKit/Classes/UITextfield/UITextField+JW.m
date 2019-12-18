//
//  UITextField+JW.m
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import "UITextField+JW.h"

@implementation UITextField (JW)

- (void)jw_setPlaceholder:(NSString *)placeholder
          placeholderFont:(UIFont *)placeholderFont
         placeholderColor:(UIColor *)placeholderColor {
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName :  placeholderColor, NSFontAttributeName : placeholderFont}];
}

@end
