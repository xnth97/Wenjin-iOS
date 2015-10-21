//
//  SearchCell.h
//  Wenjin
//
//  Created by Qin Yubo on 15/10/20.
//  Copyright © 2015年 TWT Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchDetail.h"

@interface SearchCell : NSObject

@property (nonatomic) NSInteger uid;
@property (nonatomic) NSInteger score;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *url;
@property (nonatomic) NSInteger searchId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) SearchDetail *detail;

@end
