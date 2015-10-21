//
//  Notification.h
//  Wenjin
//
//  Created by Qin Yubo on 15/10/21.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject

@property (nonatomic) NSInteger relatedId;
@property (nonatomic) NSInteger nid;
@property (nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *alert;
@property (strong, nonatomic) NSString *url;

@end
