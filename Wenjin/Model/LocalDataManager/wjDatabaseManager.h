//
//  wjDatabaseManager.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/4.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface wjDatabaseManager : NSObject

+ (void)saveAnswerDraftWithQuestionID:(NSString *)questionId answerContent:(NSAttributedString *)answerContent attachAccessKey:(NSString *)attachAccessKey anonymous:(NSInteger)isAnonymous finishBlock:(void(^)())block;

+ (void)saveQuestionDraftWithTitle:(NSString *)questionTitle detail:(NSAttributedString *)questionDetail topicsArray:(NSArray *)topicsArr attachAccessKey:(NSString *)attachAccessKey anonymous:(NSInteger)isAnonymous finishBlock:(void(^)())block;

+ (void)loadAllDraftWithType:(NSInteger)type success:(void(^)(NSArray *dataArr))success;

+ (void)removeDraft:(NSObject *)draft type:(NSInteger)type success:(void(^)())success;

+ (void)removeDatabase;

+ (void)removeRealmFile;

@end
