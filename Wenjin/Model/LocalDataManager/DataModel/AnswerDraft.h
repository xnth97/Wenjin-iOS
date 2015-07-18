//
//  AnswerDraft.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/4.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Realm/Realm.h>

@interface AnswerDraft : RLMObject

@property NSString *questionId;
@property NSData *answerContent;
@property NSString *attachAccessKey;
@property NSInteger anonymous;
@property NSDate *time;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<AnswerDraft>
RLM_ARRAY_TYPE(AnswerDraft)
