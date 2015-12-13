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
//    [[UINavigationBar appearance] setBarTintColor:[self mainTintColor]];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
//    [[UINavigationBar appearance] setTranslucent:NO];
    [[UINavigationBar appearance] setTintColor:[self mainTintColor]];
    [[UIToolbar appearance] setTintColor:[self mainTintColor]];
    [[UIButton appearance] setTintColor:[self mainTintColor]];
    [[UISegmentedControl appearance] setTintColor:[self mainTintColor]];
    [[UISwitch appearance] setOnTintColor:[self mainTintColor]];
}

+ (UIColor *)mainTintColor {
//    UIColor *color = [UIColor colorWithRed:26/255.0f green:156/255.0f blue:27/255.0f alpha:1.0f];
    UIColor *color = [UIColor flatMintColorDark];
    return color;
}

+ (UIColor *)questionTitleLabelTextColor {
    //UIColor * color = [UIColor colorWithRed:26/255.0f green:146/255.0f blue:26/255.0f alpha:1.0f];
    UIColor *color = [UIColor colorWithWhite:0.13 alpha:1.0];
    return color;
}

+ (UIColor *)buttonColor {
//    UIColor * color = [UIColor colorWithRed:76/255.0f green:137/255.0f blue:45/255.0f alpha:1.0f];
    UIColor *color = [UIColor flatMintColorDark];
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

+ (CGFloat)pageMenuHeight {
    return 36.0;
}

+ (UIColor *)pageShadowColor {
    return [UIColor darkGrayColor];
}

+ (CGSize)pageShadowOffset {
    return CGSizeMake(0, 0.1);
}

+ (CGFloat)pageShadowOpacity {
    return 1;
}

+ (CGFloat)pageShadowRadius {
    return 0.5;
}

@end
