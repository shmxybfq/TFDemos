//
//  TFAppDelegate.m
//  TFIpodPlayer
//
//  Created by Hyacinth on 14/10/29.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFAppDelegate.h"
#import "TFViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "TFIpodMusicPlayer.h"

@implementation TFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    TFViewController *root = [[TFViewController alloc]init];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:root];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

#pragma mark --------- 后台播放（是直接退出，不是先到后台再从后台关闭程序）
//应用由使用状态直接到退出应用可以调用applicationWillTerminate方法关闭播放器，但是如果先进入后台再退出应用
//就不会调用applicationWillTerminate，所以在应用进入后台时调用这个这个方法关闭播放器
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //清空IconBadgeNumber
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    //本地音乐的程序退出关闭
    UIBackgroundTaskIdentifier bgTask;
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                [[UIApplication sharedApplication] endBackgroundTask:bgTask];
                __block bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){
        //程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
        TFIpodMusicPlayer *LocalPlayler = [TFIpodMusicPlayer getInstance];
        [LocalPlayler stop];
        MPMusicPlayerController *iPodplayer  = [MPMusicPlayerController iPodMusicPlayer];
        [iPodplayer stop];
        MPMusicPlayerController *applicationPlayer  = [MPMusicPlayerController applicationMusicPlayer];
        [applicationPlayer stop];
        
    }];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}




#pragma mark --------- 程序退出关闭播放器（是直接退出，不是先到后台再从后台关闭程序）
- (void)applicationWillTerminate:(UIApplication *)application
{
    TFIpodMusicPlayer *LocalPlayler = [TFIpodMusicPlayer getInstance];
    [LocalPlayler stop];
    MPMusicPlayerController *iPodplayer  = [MPMusicPlayerController iPodMusicPlayer];
    [iPodplayer stop];
    MPMusicPlayerController *applicationPlayer  = [MPMusicPlayerController applicationMusicPlayer];
    [applicationPlayer stop];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
