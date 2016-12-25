//
//  ViewController.m
//  coverflow
//
//  Created by ztf on 16/1/28.
//  Copyright © 2016年 ztf. All rights reserved.
//

#import "ViewController.h"
#import "B0_FlowVI.h"


#define SB [[UIScreen mainScreen]bounds]
@interface ViewController ()
@property (nonatomic,strong)B0_FlowVI *flowView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //下面的滚动视图
    _flowView = [[B0_FlowVI alloc]initWithFrame:CGRectMake(0, 100, SB.size.width, 200) callBack:^(NSString *brand, B0_FlowVI *flowVI) {
        
   
    }];
    [self.view addSubview:_flowView];
    _flowView.backgroundColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor grayColor];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
