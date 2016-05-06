//
//  AppDelegate.m
//  Wenjin
//
//  Created by 秦昱博 on 15/3/27.
//  Copyright (c) 2015年 TWT Studio. All rights reserved.
//

#import "AppDelegate.h"
#import "wjAPIs.h"
#import "NotificationManager.h"
#import "data.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [FIR handleCrashWithKey:[wjAPIs firKey]];
    
    // WeChat SDK
    [WXApi registerApp:[wjAPIs wechatAppID]];
    
    // JPush
    [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    [APService setupWithOption:launchOptions];
    
    // RongCloud
//    [[RCIM sharedRCIM] initWithAppKey:[wjAPIs rongCloudAppKey]];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"%@", [url scheme]);
    NSLog(@"%@", [url query]);
    
    if ([[url scheme] isEqualToString:@"wenjin"]) {
        NSMutableDictionary *queryDic = [[NSMutableDictionary alloc] init];
        NSArray *urlComponents = [[url query] componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents) {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            NSString *value = [[pairComponents lastObject] stringByRemovingPercentEncoding];
            [queryDic setObject:value forKey:key];
        }
        
        // 构造一个假的 notification 对象从而可以直接调用处理通知的方法
        // 当然这种方法只是偷懒，之后需要重构
        NSMutableDictionary *fakeNotification = [[NSMutableDictionary alloc] init];
        if ([queryDic objectForKey:@"user"] != nil) {
            [fakeNotification setValue:[queryDic objectForKey:@"user"] forKey:@"id"];
            [fakeNotification setValue:@"0" forKey:@"nid"];
            [fakeNotification setValue:@"101" forKey:@"type"];
            [NotificationManager handleNotification:fakeNotification];
        } else if ([queryDic objectForKey:@"question"] != nil) {
            [fakeNotification setValue:[queryDic objectForKey:@"question"] forKey:@"id"];
            [fakeNotification setValue:@"0" forKey:@"nid"];
            [fakeNotification setValue:@"104" forKey:@"type"];
            [NotificationManager handleNotification:fakeNotification];
        } else if ([queryDic objectForKey:@"answer"] != nil) {
            [fakeNotification setValue:[queryDic objectForKey:@"answer"] forKey:@"id"];
            [fakeNotification setValue:@"0" forKey:@"nid"];
            [fakeNotification setValue:@"102" forKey:@"type"];
            [NotificationManager handleNotification:fakeNotification];
        } else if ([queryDic objectForKey:@"article"] != nil) {
            [fakeNotification setValue:[queryDic objectForKey:@"article"] forKey:@"id"];
            [fakeNotification setValue:@"0" forKey:@"nid"];
            [fakeNotification setValue:@"117" forKey:@"type"];
            [NotificationManager handleNotification:fakeNotification];
        } else {
            return NO;
        }
        return YES;
    } else {
        return [WXApi handleOpenURL:url delegate:self];
    }
}

// WeChat SDK Delegate

- (void)onReq:(BaseReq *)req {
    
}

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXReq class]]) {
        
    }
}

// Push

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required
    [APService handleRemoteNotification:userInfo];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [APService handleRemoteNotification:userInfo];
    // Process UserInfo
    // UserInfo 结构如下：
//    {
//        "_j_msgid" = 1454795594;
//        aps =     {
//            alert = "Wayne Yan\U8d5e\U540c\U4e86\U4f60\U5728\U95ee\U9898\U5982\U4f55\U8bc4\U4ef7\U5929\U5916\U5929\U540c\U5b66\U5728\U529e\U516c\U5ba4\U901a\U5bb5\U770b\U6b27\U51a0\U51b3\U8d5b\U7684\U884c\U4e3a\Uff1f\U4e2d\U7684\U56de\U590d";
//            badge = 1;
//            sound = default;
//        };
//        id = 5099;
//        type = 107;
//    }
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState == UIApplicationStateActive) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNotification" object:userInfo];
        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        UIViewController *topVC = appRootVC;
        while (topVC.presentedViewController) {
            topVC = topVC.presentedViewController;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"新消息" message:(userInfo[@"aps"])[@"alert"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *show = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [NotificationManager handleNotification:userInfo];
        }];
        [alert addAction:cancel];
        [alert addAction:show];
        [topVC presentViewController:alert animated:YES completion:nil];
    } else {
        // Inactive or Background
        [NotificationManager handleNotification:userInfo];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    
}

@end
