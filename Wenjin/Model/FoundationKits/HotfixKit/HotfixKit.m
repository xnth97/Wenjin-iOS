//
//  HotfixKit.m
//  
//
//  Created by Qin Yubo on 15/9/6.
//
//

#import "HotfixKit.h"
#import "AFNetworking.h"
#import "MsgDisplay.h"
#import "data.h"

#define PATCH_VERSION_KEY @"patchVer"
#define PATCH_NAME @"patch.js"

@implementation HotfixKit

+ (void)hotfixWithRootURL:(NSString *)url newCacheCompletionBlock:(void (^)())block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:url parameters:@{@"ver": [data appVersion]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"update"] boolValue] == NO) {
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *jsPath = [docPath stringByAppendingPathComponent:PATCH_NAME];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:jsPath]) {
                [fileManager removeItemAtPath:jsPath error:nil];
            }
        } else {
            NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *jsPath = [docPath stringByAppendingPathComponent:PATCH_NAME];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:jsPath]) {
                if ([[NSUserDefaults standardUserDefaults] objectForKey:PATCH_VERSION_KEY] != nil) {
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:PATCH_VERSION_KEY] doubleValue] >= [responseObject[@"patchVer"] doubleValue]) {
                        NSLog(@"newest");
                    } else {
                        [fileManager removeItemAtPath:jsPath error:nil];
                        [self updateJSCacheWithSourceURL:responseObject[@"source"] updateTime:responseObject[@"patchVer"] completionBlock:block];
                    }
                } else {
                    [fileManager removeItemAtPath:jsPath error:nil];
                    [self updateJSCacheWithSourceURL:responseObject[@"source"] updateTime:responseObject[@"patchVer"] completionBlock:block];
                }
            } else {
                [self updateJSCacheWithSourceURL:responseObject[@"source"] updateTime:responseObject[@"patchVer"] completionBlock:block];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MsgDisplay showErrorMsg:error.description];
    }];
}

+ (void)updateJSCacheWithSourceURL: (NSString *)url updateTime:(NSString *)time completionBlock:(void(^)())block {
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *jsPath = [docPath stringByAppendingPathComponent:PATCH_NAME];
    NSURL *ns_URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:ns_URL];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream = [NSInputStream inputStreamWithURL:ns_URL];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:jsPath append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:time forKey:PATCH_VERSION_KEY];
        block();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MsgDisplay showErrorMsg:error.description];
    }];
    [operation start];
}

@end
