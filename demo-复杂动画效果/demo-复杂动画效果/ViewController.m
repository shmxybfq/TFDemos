//
//  ViewController.m
//  demo-复杂动画效果
//
//  Created by 融数 on 16/11/24.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "ViewController.h"
#import "AnimationView.h"

@interface ViewController ()

@property (nonatomic,strong)AnimationView *animationView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.animationView.center = self.view.center;
    [self.view addSubview:self.animationView];
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.animationView beginAnimation];
}




@end
