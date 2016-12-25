//
//  ViewController.m
//  UICollectionView03
//
//  Created by zhutaofeng on 15/4/28.
//  Copyright (c) 2015年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "ViewController.h"

#import "TFCollectionViewCell.h"
#import "TFPubuliuLayout.h"
#import "ShowImageView.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,TFPubuliuLayout>


@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)TFPubuliuLayout *pubuLayout;



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
    UIImage *image = _dataSource[indexPath.item];
    [cell.button setImage:image forState:UIControlStateNormal];
    [cell.button setBackgroundImage:image forState:UIControlStateNormal];
    cell.button.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFCollectionViewCell *cell = (TFCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    NSLog(@"%@",    NSStringFromCGRect(cell.frame));
    
    
    float w = cell.frame.size.width;
    float h = cell.frame.size.height;
    float x = cell.frame.origin.x;
    float y = cell.frame.origin.y - collectionView.contentOffset.y;
    CGRect r = CGRectMake(x, y, w, h);
    
    
    
    
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    
    NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:@"ShowImageView" owner:self options:nil];
    ShowImageView *view = [nibs objectAtIndex:0];
//    ShowImageView *view = [[ShowImageView alloc]initWithFrame:r];
    view.frame = r;
    view.alpha = 1;
    view.oldFrame = r;
    view.imageView.image = [self.dataSource objectAtIndex:indexPath.item];
    [window addSubview:view];
    view.backgroundColor =[UIColor redColor];

    
    
    [UIView animateWithDuration:0.3 animations:^{
        view.alpha = 1;
        view.frame = window.frame;
        

    } completion:nil];
    
}

-(CGFloat)TFPubuliuLayout:(TFPubuliuLayout *)pubuliuLayout
   itemHeightForIndexPath:(NSIndexPath *)indexPath
                withWidth:(CGFloat )width
{
    UIImage *image =  [self.dataSource objectAtIndex:indexPath.item];
    return width * (image.size.height / image.size.width);
}


-(TFPubuliuLayout *)pubuLayout
{
    if (!_pubuLayout) {
        _pubuLayout  = [[TFPubuliuLayout alloc]init];
        _pubuLayout.delegate = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            _pubuLayout.columnCount = 5;
//            _pubuLayout.columnMargin = 30;
//            _pubuLayout.rowMargin = 30;
            _pubuLayout.sectionEdgeInsets = UIEdgeInsetsMake(0, 10, 50, 10);
        });
        
//        @property (nonatomic,assign)NSInteger columnCount;//列数量
//        @property (nonatomic,assign)CGFloat columnMargin;//列间距
//        @property (nonatomic,assign)CGFloat rowMargin;//行间距
//        @property (nonatomic,assign)UIEdgeInsets sectionEdgeInsets;//collectionView上左下右边距

    }
    return _pubuLayout;
}


-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds
                                            collectionViewLayout:self.pubuLayout];
    }
    return _collectionView;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
        for (int i= 0; i <= 31; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            [_dataSource addObject:image];
        }
        for (int i= 0; i <= 31; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]];
            [_dataSource addObject:image];
        }
        for (int i= 0; i <= 31; i++) {
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
