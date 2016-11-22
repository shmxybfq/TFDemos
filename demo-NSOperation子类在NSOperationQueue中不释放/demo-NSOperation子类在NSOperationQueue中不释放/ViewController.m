//
//  ViewController.m
//  demo-NSOperation子类在NSOperationQueue中不释放
//
//  Created by 融数 on 16/11/18.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "ViewController.h"
#import "TFOperation.h"
@interface ViewController ()

@property (nonatomic,strong)NSOperationQueue *queue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.queue = [[NSOperationQueue alloc]init];
    
    self.queue.maxConcurrentOperationCount = 3;
    
    for (unsigned int i = 0; i < 30; i++) {
        TFOperation *op = [[TFOperation  alloc]init];
        op.opname = [NSString stringWithFormat:@"%u",i];
        [self.queue addOperation:op];
    }
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@">>>>>>>>>queue:%@",self.queue.operations);
    });
    
    
}

@end
