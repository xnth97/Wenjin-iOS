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

@implementation wjDatabaseManager

+ (void)loadAllDraftWithType:(NSInteger)type success:(void (^)(NSArray *))success {
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"draft.db"]];
    if ([db open]) {
        if (type == 0) {
            // Question
            NSString *create = @"create table Question(time, title, detail, topic, attachAccessKey, anonymous)";
            [db executeStatements:create];
            FMResultSet *set = [db executeQuery:@"select * from Question"];
            NSMutableArray *dataArr = [[NSMutableArray alloc] init];
            while ([set next]) {
                QuestionDraft *tmp = [[QuestionDraft alloc] init];
                tmp.time = [NSDate dateWithTimeIntervalSince1970:[set intForColumn:@"time"]];
                tmp.questionTitle = [set stringForColumn:@"title"];
                tmp.questionDetail = [set dataForColumn:@"detail"];
                tmp.topicArrData = [set dataForColumn:@"topic"];
                tmp.attachAccessKey = [set stringForColumn:@"attachAccessKey"];
                tmp.anonymous = [set intForColumn:@"anonymous"];
                [dataArr addObject:tmp];
            }
            success(dataArr);
        } else {
            // Answer
            [db executeStatements:@"create table Answer(time, questionId, content, attachAccessKey, anonymous)"];
            FMResultSet *set = [db executeQuery:@"select * from Answer"];
            NSMutableArray *dataArr = [[NSMutableArray alloc] init];
            while ([set next]) {
                AnswerDraft *tmp = [[AnswerDraft alloc] init];
                tmp.time = [NSDate dateWithTimeIntervalSince1970:[set intForColumn:@"time"]];
                tmp.questionId = [set stringForColumn:@"questionId"];
                tmp.answerContent = [set dataForColumn:@"content"];
                tmp.attachAccessKey = [set stringForColumn:@"attachAccessKey"];
                tmp.anonymous = [set intForColumn:@"anonymous"];
                [dataArr addObject:tmp];
            }
            success(dataArr);
        }
    }
    [db close];
}

+ (void)saveAnswerDraftWithQuestionID:(NSString *)questionId answerContent:(NSAttributedString *)answerContent attachAccessKey:(NSString *)attachAccessKey anonymous:(NSInteger)isAnonymous finishBlock:(void (^)())block {
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"draft.db"]];
    if ([db open]) {
        NSString *create = @"create table Answer(time, questionId, content, attachAccessKey, anonymous)";
        [db executeStatements:create];
        BOOL result = [db executeUpdate:@"insert into Answer values(?, ?, ?, ?, ?)", [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]], questionId, [NSKeyedArchiver archivedDataWithRootObject:answerContent], attachAccessKey, [NSNumber numberWithInteger:isAnonymous]];
        if (result) {
            block();
        }
        [db close];
    }
}

+ (void)saveQuestionDraftWithTitle:(NSString *)questionTitle detail:(NSAttributedString *)questionDetail topicsArray:(NSArray *)topicsArr attachAccessKey:(NSString *)attachAccessKey anonymous:(NSInteger)isAnonymous finishBlock:(void (^)())block {
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"draft.db"]];
    if ([db open]) {
        NSString *create = @"create table Question(time, title, detail, topic, attachAccessKey, anonymous)";
        [db executeStatements:create];
        BOOL result = [db executeUpdate:@"insert into Question(time, title, detail, topic, attachAccessKey, anonymous) values(?, ?, ?, ?, ?, ?)", [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]], questionTitle, [NSKeyedArchiver archivedDataWithRootObject:questionDetail], [NSKeyedArchiver archivedDataWithRootObject:topicsArr], attachAccessKey, [NSNumber numberWithInteger:isAnonymous]];
        if (result) {
            block();
        }
        [db close];
    }
}



+ (void)removeDraft:(NSObject *)draft type:(NSInteger)type success:(void (^)())success {
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"draft.db"]];
    if ([db open]) {
        BOOL result;
        if (type == 0) {
            // Question
            NSNumber *timeStamp = [NSNumber numberWithInteger: [((QuestionDraft *)draft).time timeIntervalSince1970]];
            result = [db executeUpdate:@"delete from Question where time=?", timeStamp];
        } else {
            NSNumber *timeStamp = [NSNumber numberWithInteger: [((QuestionDraft *)draft).time timeIntervalSince1970]];
            result = [db executeUpdate:@"delete from Answer where time=?", timeStamp];
        }
        if (result) {
            success();
        }
        [db close];
    }
}

+ (void)removeDatabase {
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"draft.db"]]) {
        [fm removeItemAtPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"draft.db"] error:nil];
    }
}

+ (void)removeRealmFile {
    
}

@end
