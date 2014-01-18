//
//  UIColor+AppColors.h
//  Articulate
//
//  Created by Alex Zimin on 08.10.13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppColors)

+ (UIColor *)colorWithHexString:(NSString*)hex andAlpha:(float)alpha;
+ (UIColor *)randomColor;
+ (UIColor *)selectedColorFromColor:(UIColor*)color;

@end
