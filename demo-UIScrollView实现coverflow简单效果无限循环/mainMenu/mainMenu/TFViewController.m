//
//  TFViewController.m
//  mainMenu
//
//  Created by Hyacinth on 14-10-20.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFViewController.h"



@interface TFViewController ()

@end

@implementation TFViewController
@synthesize circulationSV =_circulationSV;
@synthesize menusArr =_menusArr;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
   

    NSMutableArray *arr = [NSMutableArray array];
    for ( int i=0;i<9 ; i++) {
        TFMenuVI *menu = [[TFMenuVI alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        [arr addObject:menu];
    }
    
    _circulationSV = [[TFCirculationSV alloc]initWithFrame:self.view.bounds];
    _circulationSV.delegate = self;
    [self.view addSubview:_circulationSV];
    [_circulationSV setSubViewsWithArray:arr];

    
    
}

- (void)TFCirculationSVDidScroll:(UIScrollView *)scrollView
{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:tfkMainViewScale
                                                       object:NSStringFromCGPoint(scrollView.contentOffset)];
    
}
- (void)TFCirculationSVDidChangeIndex:(NSInteger)newIndex view:(UIView *)view
{
    
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
