//
//  ProfileEditForm.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/3.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "ProfileEditForm.h"
#import "data.h"

@implementation ProfileEditForm

- (NSArray *)fields {
    
    NSDictionary *myInfo = [data shareInstance].myInfo;
    
    return @[
             
             @{FXFormFieldKey: @"nickname", FXFormFieldTitle: @"昵称", FXFormFieldDefaultValue: myInfo[@"nickname"], FXFormFieldHeader: @"基本信息"},
             @{FXFormFieldKey: @"avatar", FXFormFieldTitle: @"头像", FXFormFieldDefaultValue: myInfo[@"avatar"], FXFormFieldType: FXFormFieldTypeImage},
//             @{FXFormFieldKey: @"gender", FXFormFieldTitle: @"性别"},
//             @{FXFormFieldKey: @"birthday", FXFormFieldTitle: @"生日", FXFormFieldType: FXFormFieldTypeDate},
             
             @{FXFormFieldKey: @"signature", FXFormFieldTitle: @"", FXFormFieldDefaultValue: myInfo[@"signature"], FXFormFieldType: FXFormFieldTypeLongText, FXFormFieldHeader: @"个人说明"}
             
             ];
}

//- (NSDictionary *)genderField {
//    return @{FXFormFieldOptions: @[@(genderMale), @(genderFemale), @(genderOther)],
//             FXFormFieldValueTransformer: ^(id input) {
//                 return @{@(genderMale): @"男",
//                          @(genderFemale): @"女",
//                          @(genderOther): @"其他"}[input];
//             },
//             FXFormFieldDefaultValue: @(genderFemale)};
//}

@end
