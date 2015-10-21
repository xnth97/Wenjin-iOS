//
//  HotfixKit.h
//  
//
//  Created by Qin Yubo on 15/9/6.
//
//

#import <Foundation/Foundation.h>

@interface HotfixKit : NSObject

+ (void)hotfixWithRootURL:(NSString *)url newCacheCompletionBlock:(void(^)())block;

@end
