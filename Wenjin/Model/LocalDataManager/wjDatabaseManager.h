//
//  wjDatabaseManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/4.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface wjDatabaseManager : NSObject

+ (void)saveAnswerDraftWithQuestionID:(NSString *)questionId answerContent:(NSString *)answerContent attachAccessKey:(NSString *)attachAccessKey anonymous:(NSInteger)isAnonymous finishBlock:(void(^)())block;

+ (void)saveQuestionDraftWithTitle:(NSString *)questionTitle detail:(NSAttributedString *)questionDetail topicsArray:(NSArray *)topicsArr attachAccessKey:(NSString *)attachAccessKey anonymous:(NSInteger)isAnonymous finishBlock:(void(^)())block;

@end
