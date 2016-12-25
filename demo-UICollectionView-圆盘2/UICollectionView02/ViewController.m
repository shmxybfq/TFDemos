//
//  ViewController.m
//  UICollectionView02
//
//  Created by zhutaofeng on 15/4/28.
//  Copyright (c) 2015年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "ViewController.h"

#import "TFCircleLayout.h"
#import "TFCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;



@end

@implementation ViewController


static  NSString *const cellId =@"cellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"TFCollectionViewCell" bundle:nil]
          forCellWithReuseIdentifier:cellId];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor brownColor];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;


}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   TFCollectionViewCell *cell =(TFCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                         forIndexPath:indexPath];
    UIImage *image = _dataSource[arc4random()%_dataSource.count];
    [cell.button setImage:image forState:UIControlStateNormal];
    [cell.button setBackgroundImage:image forState:UIControlStateNormal];
    cell.button.backgroundColor = [UIColor redColor];
    return cell;
}


-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:[[TFCircleLayout alloc]init]];
    }
    return _collectionView;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
        for (int i= 0; i <= 15; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            [_dataSource addObject:image];
        }
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
