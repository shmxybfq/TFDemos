//
//  B0_FlowVI.m
//  shop
//
//  Created by 梦想 on 15/12/20.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//

#import "B0_FlowVI.h"
#import "B0_FlowLayout.h"
#import "CollectionViewCell.h"
#import "DiantaiFlowlayout.h"

#define SectionCount 9999
@interface B0_FlowVI()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    FlowVICallBackBlock _callBackBlock;
    CollectionViewCell *_selectedCell;

}
@property (nonatomic,retain)UICollectionViewLayout *flowLayout;
@property (nonatomic,retain)DiantaiFlowlayout *diantaiFlowlayout;
@end

@implementation B0_FlowVI

-(instancetype)initWithFrame:(CGRect)frame callBack:(FlowVICallBackBlock)callBackBlock
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.dataArray = [[NSMutableArray alloc]initWithArray:@[@"u=2692675169,1336708413&fm=21&gp=0.jpg",
                                                                @"u=2692675169,1336708413&fm=21&gp=0.jpg",
                                                                @"u=2692675169,1336708413&fm=21&gp=0.jpg",
                                                                @"u=2692675169,1336708413&fm=21&gp=0.jpg",
                                                                @"u=2692675169,1336708413&fm=21&gp=0.jpg",
                                                                @"u=2692675169,1336708413&fm=21&gp=0.jpg",
                                                                @"u=2692675169,1336708413&fm=21&gp=0.jpg"]];
        

        _callBackBlock = callBackBlock;
        
        
        
        self.flowLayout = [[B0_FlowLayout alloc]init];
        self.diantaiFlowlayout = [[DiantaiFlowlayout alloc]init];
        
        self.collectionView = [[B0_CollectionVI alloc]initWithFrame:self.bounds collectionViewLayout:self.diantaiFlowlayout];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.decelerationRate = 0.1;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil]
              forCellWithReuseIdentifier:cellId];
        
        [self addSubview:self.collectionView];
        
        
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count/2 inSection:SectionCount/2]
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:NO];
    }
    return self;
}

//
//-(void)reloadCollectionData:(__kindof NSArray *)data
//{
//    if (self.dataArray.count) {
//        [self.dataArray removeAllObjects];
//    }
//    
//    if (data == nil || data.count == 0) {
//        [self.collectionView reloadData];
//        return;
//    }
//    
//   
//    [self.dataArray addObjectsFromArray:data];
//    
//    [self.collectionView reloadData];
//    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count/2 inSection:SectionCount/2]
//                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
//                                        animated:NO];
//}
//



-(void)layoutSubviews
{
    [super layoutSubviews];

    self.collectionView.frame = self.bounds;
    
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return SectionCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

static   NSString *const cellId = @"B0_CollectionVI";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                         forIndexPath:indexPath];
    [cell setCellData:self.dataArray[indexPath.row]];
    return cell;
}






@end
