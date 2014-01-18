//
//  UIColor+AppColors.m
//  Articulate
//
//  Created by Alex Zimin on 08.10.13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

+ (UIColor*)colorWithHexString:(NSString*)hex andAlpha:(float)alpha
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}


// -------------------------------------------------------------------------------------------------

+ (UIColor *)selectedColorFromColor:(UIColor*)color
{
    float hue = 0;
    float saturation = 0;
    float brightness = 0;
    float newBrightness = 0;
    float alpha = 1.0;
    
    BOOL b = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    newBrightness = (brightness > 0.75) ? brightness * 0.9 - 0.25 : brightness * 1.1 + 0.25;
    newBrightness = (newBrightness > 0.95) ? 0.9 : newBrightness;
    
    return (b) ? [UIColor colorWithHue:hue saturation:saturation brightness:newBrightness alpha:alpha] : [UIColor lightGrayColor];
}

// -------------------------------------------------------------------------------------------------

+ (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:0.5];
}

@end
