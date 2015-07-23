//
//  ProfileEditForm.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FXForms.h"

@interface ProfileEditForm : NSObject <FXForm>

typedef NS_ENUM(NSInteger, gender) {
    genderMale = 0,
    genderFemale = 1,
    genderOther = 2
};

@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) UIImage *avatar;
@property (copy, nonatomic) NSDate *birthday;
@property (copy, nonatomic) NSString *signature;

@end
