//
//  ViewController.m
//  表格
//
//  Created by ztf on 15/12/2.
//  Copyright © 2015年 ztf. All rights reserved.
//

#import "ViewController.h"
#import "FormCell.h"
#import "FormView.h"


@interface ViewController ()<FormViewDataSource>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FormView *view = [[FormView alloc]initWithFrame:(CGRect){0, 20, (CGSize)self.view.bounds.size}];
    [self.view addSubview:view];
    view.tag = 1024;
    view.dataSource = self;
    

   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [view reloadData];
    });

    
}



-(NSInteger)FormView:(FormView *)formView numberOfRowsInSection:(NSInteger)section
{
    return 25 + arc4random_uniform(25);
}

-(NSString *)FormView:(FormView *)formView LeftText:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%ld",(long)indexPath.row];
}
-(CGFloat)FormView:(FormView *)formView RightViewPercent:(NSIndexPath *)indexPath
{
    return arc4random_uniform(90)/100.0 + 0.1;

}
-(CGFloat)FormView:(FormView *)formView RightViewAnimationDurition:(NSIndexPath *)indexPath
{
    return 0.3 + arc4random_uniform(10)/10.0;
}

-(CGFloat)FormView:(FormView *)formView CellHeight:(NSIndexPath *)indexPath
{
    return 20.0;
}
-(CGFloat)FormView:(FormView *)formView BottomMargin:(NSIndexPath *)indexPath
{
    return 10.0;
}
-(CGFloat)FormView:(FormView *)formView TopMargin:(NSIndexPath *)indexPath
{
    return 0.0;
}




@end
