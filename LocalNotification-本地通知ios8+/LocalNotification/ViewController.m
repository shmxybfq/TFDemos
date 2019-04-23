//
//  ViewController.m
//  LocalNotification
//
//  Created by zhutaofeng on 2019/4/23.
//  Copyright © 2019 zhutaofeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UILocalNotification *notifi = [[UILocalNotification alloc]init];
    notifi.soundName = UILocalNotificationDefaultSoundName;
    notifi.alertBody = @"哈喽~通知！";
    notifi.fireDate  = [NSDate dateWithTimeIntervalSinceNow:10];
    notifi.userInfo  = @{@"notifi_id":@"666"};
    [[UIApplication sharedApplication] scheduleLocalNotification:notifi];
    
    //获取和取消本地通知
    NSArray *ns = [[UIApplication sharedApplication]scheduledLocalNotifications];
    if (ns && ns.count > 0) {
        for (UILocalNotification *localNotifi in ns) {
            if ([[localNotifi.userInfo objectForKey:@"notifi_id"] isEqualToString:@"666"]) {
                //[[UIApplication sharedApplication]cancelAllLocalNotifications];
                //[[UIApplication sharedApplication] cancelLocalNotification:localNotifi];
            }
        }
    }
}

@end
