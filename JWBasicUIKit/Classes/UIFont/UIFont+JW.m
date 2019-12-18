//
//  UIFont+JW_Font.m
//  JWBaseUIKit_Example
//
//  Created by 刘君威 on 2019/12/11.
//  Copyright © 2019 liujunwei2018. All rights reserved.
//

#import "UIFont+JW.h"
#import <CoreText/CTFontManager.h>

@implementation UIFont (JW)

+ (UIFont *)jw_thinFontOfSize:(CGFloat)fontSize
{
    UIFont * font = [UIFont fontWithName:@"HelveticaNeue-Light" size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)jw_normalFontOfSize:(CGFloat)fontSize
{
    return [UIFont systemFontOfSize:fontSize];
}

+ (UIFont *)jw_boldFontOfSize:(CGFloat)fontSize
{
    return [UIFont boldSystemFontOfSize:fontSize];
}

+ (UIFont *)jw_PingFangSCMediumOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)jw_PingFangSCRegularOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)jw_PingFangSCLightOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)jw_PingFangSCSemiboldOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
    if (!font) {
        font = [UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (UIFont *)jw_DINMittelschriftOfSize:(CGFloat)fontSize
{
    UIFont *font = [UIFont fontWithName:@"DINMittelschrift" size:fontSize];
    if (font) {
        return font;
    }else {
        [[self class] dynamicallyLoadFontNamed:@"DINMittelschrift.otf"];
        return [UIFont fontWithName:@"DINMittelschrift" size:fontSize];
    }
    return [UIFont systemFontOfSize:fontSize];
}


+ (void)dynamicallyLoadFontNamed:(NSString *)name
{
    NSString *fontfileName = name;
    
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    NSString *bundlePath = [NSString stringWithFormat:@"%@/%@",mainBundlePath,@"UIFont.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    NSString *resourcePath = [NSString stringWithFormat:@"%@/%@",bundle.bundlePath,fontfileName];
    
    NSURL *url = [NSURL fileURLWithPath:resourcePath];
    
    NSData *fontData = [NSData dataWithContentsOfURL:url];
    if (fontData) {
        CFErrorRef error;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
        CGFontRef font = CGFontCreateWithDataProvider(provider);
        if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            NSLog(@"Failed to load font: %@", errorDescription);
            CFRelease(errorDescription);
        }
        CFRelease(font);
        CFRelease(provider);
    }
}

@end
