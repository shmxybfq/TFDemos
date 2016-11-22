//
//  TFOperation.m
//  demo-NSOperation子类在NSOperationQueue中不释放
//
//  Created by 融数 on 16/11/18.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "TFOperation.h"

@implementation TFOperation


- (void)main
{
//    NSLog(@"%@ start",self.name);
//    sleep(1);
//    NSLog(@"%@ end",self.name);
    
    
    NSLog(@"%@ start",self.opname);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        //do something really important
        sleep(1);
        NSLog(@"%@ end",self.opname);
    });
}




-(void)dealloc{
    NSLog(@">>>>>>>>>>>>>>>deallo:%@",self.name);
}

@end
