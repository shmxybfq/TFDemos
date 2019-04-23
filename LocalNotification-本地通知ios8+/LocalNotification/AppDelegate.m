//
//  AppDelegate.m
//  LocalNotification
//
//  Created by zhutaofeng on 2019/4/23.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

//https://www.cnblogs.com/jingxin1992/p/6402539.html

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setUserNotificationSettings:application];
    return YES;
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
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)setUserNotificationSettings:(UIApplication *)application{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
            UNAuthorizationOptions options = UNAuthorizationOptionBadge |
            UNAuthorizationOptionAlert |
            UNAuthorizationOptionSound;
            [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    //点击允许
                    //这里可以添加自己的逻辑
                    NSLog(@"******:注册ios10本地通知成功");
                    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                        
                    }];
                }else{
                    NSLog(@"******:注册ios10本地通知失败");
                }
            }];
        }
    } else {
        if (@available(iOS 8.0, *)) {
            UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                    settingsForTypes:UIUserNotificationTypeBadge|
                                                    UIUserNotificationTypeSound|
                                                    UIUserNotificationTypeAlert
                                                    categories:nil];
            [[UIApplication sharedApplication]registerUserNotificationSettings:settings];
            NSLog(@"******:注册ios8本地通知成功");
        } else {
            NSLog(@"******:注册ios8本地通知失败");
        }
    }
}

//ios8以后的代理方法,应用程序在后台和前台时调用
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"******收到本地通知:%@",notification.alertBody);
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@"******收到本地通知:UIApplicationStateActive");
    }else{
        NSLog(@"******收到本地通知:UIApplicationStateActive-else");
    }
}


//ios10以后的代理方法,
//这个方法不知道干啥的
-(void)userNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
    NSLog(@"******收到本地通知ios10:%s",__func__);
}
//应用程序在前台收到通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"******收到本地通知ios10:%s:%@",__func__,notification.request.content.body);
}
//应用程序在后台收到通知
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"******收到本地通知ios10:%s:%@",__func__,response.notification.request.content.body);
    completionHandler();
}

@end
