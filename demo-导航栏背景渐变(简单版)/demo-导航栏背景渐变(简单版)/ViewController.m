//
//  ViewController.m
//  demo-导航栏背景渐变(简单版)
//
//  Created by ztf on 16/12/15.
//  Copyright © 2016年 ztf. All rights reserved.
//

#import "ViewController.h"
#import "TFEasyCoder.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray     *dataSource;
@property (nonatomic,strong)UIView      *navback;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    UITableView *tableview =[[UITableView alloc]initWithFrame:self.view.bounds];
    tableview.delegate =self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tableview];
    
    self.dataSource = [NSArray arrayWithArray:[UIFont familyNames]];
    [self.tableView reloadData];
    
    
    self.navback = [self.navigationController.navigationBar
                    tf_getSubviewOfClass:NSClassFromString(@"_UINavigationBarBackground")];
    
    NSLog(@">>>>>>>:%@",self.navback);
    
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{return self.dataSource.count;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor orangeColor];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minAlphaOffset = - 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    self.navback.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.alpha = alpha;
}



@end
