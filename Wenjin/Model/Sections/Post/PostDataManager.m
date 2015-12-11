//
//  PostDataManager.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/31.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "PostDataManager.h"
#import "AFNetworking.h"
#import "wjAPIs.h"
#import "data.h"

@implementation PostDataManager

+ (void)postQuestionWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@?platform=ios", [wjAPIs postQuestion]] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *pqDic = (NSDictionary *)responseObject;
        if ([pqDic[@"errno"] isEqual: @1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success((pqDic[@"rsm"])[@"question_id"]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(pqDic[@"err"]);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)postAnswerWithParameters:(NSDictionary *)parameters success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@?platform=ios", [wjAPIs postAnswer]] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObj) {
        
        NSDictionary *pqDic = (NSDictionary *)responseObj;
        if ([pqDic[@"errno"] isEqual: @1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success((pqDic[@"rsm"])[@"answer_id"]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(pqDic[@"err"]);
            });
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)postAnswerCommentWithAnswerID:(NSString *)answerId andMessage:(NSString *)message success:(void (^)())success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *getURLString = [NSString stringWithFormat:@"%@?answer_id=%@&platform=ios", [wjAPIs postAnswerComment], answerId];
    NSDictionary *parameters = @{@"message": message};
    [manager POST:getURLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

#pragma warning - NOT COMPLETED ABOUT ERRORS

+ (void)uploadAttachFromAttributedString:(NSAttributedString *)attrStr withAttachType:(NSString *)type {
    __block BOOL attributedTextContainsNSTextAttachment = NO;
    NSMutableArray *attachmentArray = [[NSMutableArray alloc] init];
    NSMutableArray *attachIDArray = [[NSMutableArray alloc] init];
    [attrStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && [value isKindOfClass:[NSTextAttachment class]] && ((NSTextAttachment *)value).image != nil) {
            [attachmentArray addObject:((NSTextAttachment *)value).image];
            attributedTextContainsNSTextAttachment = YES;
        }
    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (attributedTextContainsNSTextAttachment) {
            
            for (int i = 0; i < attachmentArray.count; i ++) {
                NSCondition *condition = [[NSCondition alloc] init];
                
                UIImage *img = (UIImage *)attachmentArray[i];
                NSData *picData = UIImageJPEGRepresentation(img, 0.5);
                [self uploadAttachFile:picData attachType:type success:^(NSString *attachId) {
                    [attachIDArray addObject:attachId];
                    if (attachIDArray.count == attachmentArray.count) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"attachIDCompleted" object:attachIDArray];
                    }
                    
                    [condition lock];
                    [condition signal];
                    [condition unlock];
                } failure:^(NSString *errorStr) {
                    [condition lock];
                    [condition signal];
                    [condition unlock];
                }];
                
                [condition lock];
                [condition wait];
                [condition unlock];
            }
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"attachIDCompleted" object:@[]];
        }
    });
}

+ (NSString *)plainStringConvertedFromAttributedString:(NSAttributedString *)attrStr andAttachIDArray:(NSArray *)attachIDArr {
    NSMutableString *plainString = [NSMutableString stringWithString:attrStr.string];
    __block int i = 0; // 循环计数
    __block NSUInteger base = 0; // 替换下标偏移量
    [attrStr enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attrStr.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && [value isKindOfClass:[NSTextAttachment class]] && ((NSTextAttachment *)value).image != nil) {
            [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:[NSString stringWithFormat:@"[attach]%@[/attach]", [attachIDArr[i] stringValue]]];
            NSString *baseString = @"[attach][/attach]";
            base += [attachIDArr[i] stringValue].length - 1 + baseString.length;
            i ++;
        }
    }];
    return plainString;
}

+ (void)uploadAttachFile:(id)file attachType:(NSString *)type success:(void (^)(NSString *))success failure:(void (^)(NSString *))failure {
    // Type = question, article, answer
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *urlString = [NSString stringWithFormat:@"%@&id=%@&attach_access_key=%@&platform=ios", [wjAPIs uploadAttach], type, [data shareInstance].attachAccessKey];
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:file name:@"qqfile" fileName:@"img.jpg" mimeType:@"image/jpg"];
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success((dicData[@"rsm"])[@"attach_id"]);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)postFeedbackWithTitle:(NSString *)title message:(NSString *)message success:(void (^)())success failure:(void (^)(NSString *))failure {
    NSDictionary *parameters = @{@"title": title,
                                 @"message": message,
                                 @"version": @"ios",
                                 @"system": [data appVersion],
                                 @"source": [data osVersion]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:[NSString stringWithFormat:@"%@?platform=ios", [wjAPIs feedback]] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

+ (void)postArticleCommentWithArticleID:(NSString *)articleId andMessage:(NSString *)message success:(void (^)())success failure:(void (^)(NSString *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSDictionary *parameters = @{@"article_id": articleId,
                                 @"message": message};
    [manager POST:[NSString stringWithFormat:@"%@?platform=ios", [wjAPIs postArticleComment]] parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *dicData = (NSDictionary *)responseObject;
        if ([dicData[@"errno"] isEqual:@1]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success();
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(dicData[@"err"]);
            });
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error.localizedDescription);
        });
    }];
}

@end
