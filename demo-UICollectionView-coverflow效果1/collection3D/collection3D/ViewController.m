//
//  ViewController.m
//  collection3D
//
//  Created by zhutaofeng on 15/6/23.
//  Copyright (c) 2015年 cheyinwang. All rights reserved.
//

#import "ViewController.h"
#import "SelfRotationLayout.h"
#define radiusLength 100.0
#define centerX self.view.center.x
#define centerY self.view.center.y


#define degressToRadians(x) (x / 180.0 * M_PI)
#define radiansToDegrees(x) (180.0 * x / M_PI)

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{

    UIImageView *_imageVI;
}
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)SelfRotationLayout *rotationLayout;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _dataSource = [[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        [_dataSource addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    float w = CGRectGetWidth(self.view.bounds);
    float h = CGRectGetHeight(self.view.bounds);
    float x = 0;
    float y = 0;
    CGRect r = CGRectMake(x, y, w, h);
    _rotationLayout = [[SelfRotationLayout alloc]init];
    _collectionView  = [[UICollectionView alloc]initWithFrame:r collectionViewLayout:_rotationLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.decelerationRate = 0.99;
    _collectionView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.5];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"RootCollectionViewCell"];
    [self.view addSubview:_collectionView];
    [_collectionView reloadData];
    _collectionView.clipsToBounds = NO;
    

}






- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RootCollectionViewCell"
                                                                             forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc]init];
        cell.restorationIdentifier = @"RootCollectionViewCell";
    }
    cell.backgroundColor = [UIColor colorWithRed:indexPath.item / 10.0
                                           green:indexPath.item / 10.0
                                            blue:indexPath.item / 10.0 alpha:1];

    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
