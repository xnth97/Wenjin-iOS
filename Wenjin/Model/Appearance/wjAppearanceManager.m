//
//  wjAppearanceManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/4/17.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjAppearanceManager.h"

@implementation wjAppearanceManager

+ (void)setTintColor {
    [[UITabBar appearance] setTintColor:[self mainTintColor]];
    [[UINavigationBar appearance] setBarTintColor:[self mainTintColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UIToolbar appearance] setTintColor:[self buttonColor]];
    [[UIButton appearance] setTintColor:[self buttonColor]];
}

+ (UIColor *)mainTintColor {
    UIColor * color = [UIColor colorWithRed:87/255.0f green:158/255.0f blue:50/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)questionTitleLabelTextColor {
    UIColor * color = [UIColor colorWithRed:87/255.0f green:158/255.0f blue:50/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)buttonColor {
    UIColor * color = [UIColor colorWithRed:87/255.0f green:158/255.0f blue:50/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)userActionTextColor {
    UIColor * color = [UIColor colorWithRed:87/255.0f green:158/255.0f blue:50/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)tagsControlBackgroundColor {
    UIColor * color = [UIColor colorWithRed:87/255.0f green:158/255.0f blue:50/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)segmentedSelectedColor {
    UIColor * color = [UIColor colorWithRed:87/255.0f green:196/255.0f blue:62/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)segmentedUnselectedColor {
    UIColor * color = [UIColor colorWithRed:87/255.0f green:150/255.0f blue:53/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)segmentedUnselectedTextColor {
    UIColor * color = [UIColor colorWithRed:87/255.0f green:224/255.0f blue:120/255.0f alpha:1.0f];
    return color;
}

@end
