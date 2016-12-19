//
//  ViewController.m
//  demo-字典模型互转核心代码
//
//  Created by ztf on 16/12/15.
//  Copyright © 2016年 ztf. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+Mutual.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dicToModel];
    [self modelToDic];
}


-(void)dicToModel{
    NSDictionary *dic = @{@"username":@"大头爸爸",@"userage":@"18"};
    Person *person = [Person new];
    [person setDic:dic];
    NSLog(@">>>>>>字典转模型:%@",person.username);
    NSLog(@">>>>>>字典转模型:%@",person.userage);
}


-(void)modelToDic{
    Person *person = [Person new];
    person.username = @"小头儿子";
    person.userage  = @"18";
    NSLog(@">>>>>>模型转字典:%@",person.toDic);
}

@end
