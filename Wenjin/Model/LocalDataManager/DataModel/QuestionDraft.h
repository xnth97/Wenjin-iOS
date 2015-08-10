//
//  QuestionDraft.h
//  Wenjin
//
//  Created by 秦昱博 on 15/7/4.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import <Realm/Realm.h>

@interface QuestionDraft : RLMObject

@property NSString *questionTitle;
@property NSData *questionDetail;
@property NSData *topicArrData;
@property NSString *attachAccessKey;
@property NSInteger anonymous;
@property NSDate *time;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<QuestionDraft>
RLM_ARRAY_TYPE(QuestionDraft)
