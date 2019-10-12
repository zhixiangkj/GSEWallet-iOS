//
//  AppDelegate.m
//  wallet
//
//  Created by user on 21/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GSEWallet-Swift.h"
#import "GSE_WalletTxns.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    GSE_Wallet *wallet = [GSE_Wallet shared];
    
    [wallet setUserId:@"0"];
    [wallet setChainId: ChainIdHomestead];
    [wallet getClientid];
    
    application.applicationIconBadgeNumber = 0;
    GAI *gai = [GAI sharedInstance];
    [gai trackerWithTrackingId:@"UA-127134829-1"];
    
    // Optional: automatically report uncaught exceptions.
    gai.trackUncaughtExceptions = YES;
    
    // Optional: set Logger to VERBOSE for debug information.
    // Remove before app release.
    //gai.logger.logLevel = kGAILogLevelVerbose;
    // 初始化ges支付功能
    [GSE_Pay shared];
    return self;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"DeviceToken: %@",deviceToken);
    
    GSE_Wallet *wallet = [GSE_Wallet shared];
    Address *address = [wallet getCurrentWalletAddress];
    NSDictionary * dic = @{@"address":address.checksumAddress.lowercaseString,
                           @"token": deviceToken.hex,
                           @"device":[UIDevice deviceInfo],
                           @"clientid":[wallet getClientid]};
    DictionaryPromise *promise = [[wallet getProvider] syncAPNs:dic];
    [promise onCompletion:^(DictionaryPromise *promise) {
        NSLog(@"%@",promise.result);
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"DeviceTokenError: %@",error);
    
    GSE_Wallet *wallet = [GSE_Wallet shared];
    Address *address = [wallet getCurrentWalletAddress];
    NSDictionary * dic = @{@"address":address.checksumAddress.lowercaseString,
                           @"token": @"",
                           @"device":[UIDevice deviceInfo],
                           @"clientid":[wallet getClientid]};
    DictionaryPromise *promise = [[wallet getProvider] syncAPNs:dic];
    [promise onCompletion:^(DictionaryPromise *promise) {
        NSLog(@"%@",promise.result);
    }];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"%@",notification.userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"%@",userInfo);
    
    NSDictionary *aps = userInfo[@"aps"];
    if (!aps || ![aps isKindOfClass:[NSDictionary class]]) {
        completionHandler(UIBackgroundFetchResultNewData);
        return;
    }
    
    NSDictionary *push_content = aps[@"push-content"];
    if (!push_content || ![push_content isKindOfClass:[NSDictionary class]]) {
        completionHandler(UIBackgroundFetchResultNewData);
        return;
    }
    
    NSString *topic = push_content[@"topic"];
    NSLog(@"%@",topic);
    
    if ([topic isEqualToString:@"gse_getTokens"]) {
        NSDictionary * payload = push_content[@"payload"];
        if (![payload isKindOfClass:[NSDictionary class]]) {
            completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        NSString *addressString = payload[@"address"];
        
        Address *address = [[GSE_Wallet shared] getCurrentWalletAddress];
        NSLog(@"%@,%@",address,address.checksumAddress.lowercaseString);
        if (![addressString isEqualToString:address.checksumAddress.lowercaseString]) {
            completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        [[ViewController shared] reloadData:^{
            completionHandler(UIBackgroundFetchResultNewData);
        }];
    }else if ([topic isEqualToString:@"gse_getTxns"]){
        NSDictionary * payload = push_content[@"payload"];
        if (![payload isKindOfClass:[NSDictionary class]]) {
            completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        NSString *addressString = payload[@"address"];
        Address *address = [[GSE_Wallet shared] getCurrentWalletAddress];
        if (![addressString isEqualToString:address.checksumAddress.lowercaseString]) {
            completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        UIViewController *vc = [ViewController shared];
        vc = vc.navigationController.topViewController;
        if (![vc isKindOfClass:[GSE_WalletTxns class]]) {
            completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        GSE_WalletTxns *txn = (id)vc;
        NSString *contractAddressString = payload[@"contractAddress"];
        if (contractAddressString) {
            NSString *contract = txn.contract.checksumAddress.lowercaseString;
            if (![contractAddressString isEqualToString:contract]) {
                completionHandler(UIBackgroundFetchResultNewData);
                return;
            }
            [txn reloadData:^{
                completionHandler(UIBackgroundFetchResultNewData);
            }];
        }else{
            if (txn.contract) {
                completionHandler(UIBackgroundFetchResultNewData);
                return;
            }
            [txn reloadData:^{
                completionHandler(UIBackgroundFetchResultNewData);
            }];
        }
    }else if ([topic isEqualToString:@"gse_localNotification"]){
        NSDictionary * payload = push_content[@"payload"];
        if (![payload isKindOfClass:[NSDictionary class]]) {
            completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        NSString *message = payload[@"message"];
        if (!message || ![message isKindOfClass:[NSString class]] || !message.length) {
            completionHandler(UIBackgroundFetchResultNewData);
            return;
        }
        [self fireLocalNotification:message withUserInfo:userInfo];
        completionHandler(UIBackgroundFetchResultNewData);
    }else{
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)fireLocalNotification:(NSString *)message withUserInfo:(NSDictionary *)infoDict{
    
    NSLog(@"%s, local notification notify",__FUNCTION__);
    
    if (!message || ![message isKindOfClass:[NSString class]] || !message.length) {
        return;
    }
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDate *now = [NSDate date];
    notification.fireDate = now;
    notification.repeatInterval = 0;
    notification.timeZone=[NSTimeZone defaultTimeZone];
    /*
    // notification.applicationIconBadgeNumber = [[db_ssdb hGetString:k_user forKey:k_unread] integerValue];
    // if ([Settings_Notification switchForKey:k_new_message_sound]) {
    // notification.soundName= @"push.wav";
    // }else{
    // notification.soundName= @"black.wav";
    // }*/
    notification.soundName = UILocalNotificationDefaultSoundName;
    //NSLog(@"%@",notification.soundName); // UILocalNotificationDefaultSoundName;
    notification.alertBody = message;//提示信息 弹出提示框
    //notification.alertAction = @"";//提示框按钮
    //notification.hasAction = NO; //是否显示额外的按钮，为no时alertAction消失
    // NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
    notification.userInfo = infoDict; //添加额外的信息
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
