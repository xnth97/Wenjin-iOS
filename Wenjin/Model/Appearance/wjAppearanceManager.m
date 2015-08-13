//
//  wjAppearanceManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/17.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjAppearanceManager.h"
#import "Chameleon.h"

@implementation wjAppearanceManager

+ (void)setTintColor {
    [[UITabBar appearance] setTintColor:[self mainTintColor]];
    [[UINavigationBar appearance] setBarTintColor:[self mainTintColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTranslucent:NO];
    [[UIToolbar appearance] setTintColor:[self buttonColor]];
    [[UIButton appearance] setTintColor:[self buttonColor]];
}

+ (UIColor *)mainTintColor {
    UIColor *color = [UIColor colorWithRed:26/255.0f green:156/255.0f blue:27/255.0f alpha:1.0f];
//    UIColor *color = [UIColor colorWithRed:26/255.0f green:188/255.0f blue:156/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)questionTitleLabelTextColor {
    //UIColor * color = [UIColor colorWithRed:26/255.0f green:146/255.0f blue:26/255.0f alpha:1.0f];
    UIColor *color = [UIColor colorWithWhite:0.13 alpha:1.0];
    return color;
}

+ (UIColor *)buttonColor {
    UIColor * color = [UIColor colorWithRed:76/255.0f green:137/255.0f blue:45/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)userActionTextColor {
    UIColor * color = [self mainTintColor];
    return color;
}

+ (UIColor *)tagsControlBackgroundColor {
    UIColor * color = [self mainTintColor];
    return color;
}

+ (UIColor *)segmentedSelectedColor {
    UIColor * color = [UIColor colorWithRed:99/255.0f green:205/255.0f blue:42/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)segmentedUnselectedColor {
    UIColor * color = [UIColor colorWithRed:65/255.0f green:126/255.0f blue:33/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)segmentedUnselectedTextColor {
   UIColor * color = [UIColor colorWithRed:89/255.0f green:167/255.0f blue:48/255.0f alpha:1.0f];
    return color;
}


@end
