//
//  wjDatabaseManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/7/4.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "wjDatabaseManager.h"
#import "AnswerDraft.h"
#import "QuestionDraft.h"
#import <Realm/Realm.h>

@implementation wjDatabaseManager

+ (void)saveAnswerDraftWithQuestionID:(NSString *)questionId answerContent:(NSAttributedString *)answerContent attachAccessKey:(NSString *)attachAccessKey anonymous:(NSInteger)isAnonymous finishBlock:(void (^)())block {
    AnswerDraft *draft = [[AnswerDraft alloc] init];
    draft.questionId = questionId;
    draft.answerContent = [NSKeyedArchiver archivedDataWithRootObject:answerContent];
    draft.attachAccessKey = attachAccessKey;
    draft.anonymous = isAnonymous;
    draft.time = [NSDate date];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addObject:draft];
        [realm commitWriteTransaction];
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
    
}

+ (void)saveQuestionDraftWithTitle:(NSString *)questionTitle detail:(NSAttributedString *)questionDetail topicsArray:(NSArray *)topicsArr attachAccessKey:(NSString *)attachAccessKey anonymous:(NSInteger)isAnonymous finishBlock:(void (^)())block {
    QuestionDraft *draft = [[QuestionDraft alloc] init];
    draft.questionTitle = questionTitle;
    draft.questionDetail = [NSKeyedArchiver archivedDataWithRootObject:questionDetail];
    draft.topicArrData = [NSKeyedArchiver archivedDataWithRootObject:topicsArr];
    draft.attachAccessKey = attachAccessKey;
    draft.anonymous = isAnonymous;
    draft.time = [NSDate date];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm addObject:draft];
        [realm commitWriteTransaction];
        dispatch_async(dispatch_get_main_queue(), ^{
            block();
        });
    });
}

+ (void)removeDatabase {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteAllObjects];
        [realm commitWriteTransaction];
    });
}

+ (void)removeRealmFile {
    [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
}

@end
