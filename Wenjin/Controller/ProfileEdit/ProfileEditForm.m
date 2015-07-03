//
//  ProfileEditForm.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ProfileEditForm.h"

@implementation ProfileEditForm

- (NSArray *)fields {
    
    NSString *userID = @"xnth97";
    //NSString *userGender = @"2";
    
    return @[
             
             @{FXFormFieldKey: @"nickname", FXFormFieldTitle: @"昵称", FXFormFieldDefaultValue: userID, FXFormFieldHeader: @"基本信息"},
             @{FXFormFieldKey: @"avatar", FXFormFieldTitle: @"头像", FXFormFieldType: FXFormFieldTypeImage},
             @{FXFormFieldKey: @"gender", FXFormFieldTitle: @"性别"},
             @{FXFormFieldKey: @"birthday", FXFormFieldTitle: @"生日", FXFormFieldType: FXFormFieldTypeDate},
             
             @{FXFormFieldKey: @"signature", FXFormFieldTitle: @"签名", FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"个性"}
             
             ];
}

- (NSDictionary *)genderField {
    return @{FXFormFieldOptions: @[@(genderMale), @(genderFemale), @(genderOther)],
             FXFormFieldValueTransformer: ^(id input) {
                 return @{@(genderMale): @"男",
                          @(genderFemale): @"女",
                          @(genderOther): @"其他"}[input];
             },
             FXFormFieldDefaultValue: @(genderFemale)};
}

@end
