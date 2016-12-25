//
//  TFCircleLayout.m
//  UICollectionView02
//
//  Created by zhutaofeng on 15/4/28.
//  Copyright (c) 2015年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFCircleLayout.h"

@implementation TFCircleLayout


-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


//每次重新布局前都会调用
- (void)prepareLayout
{
    
    
    
}


//询问是否每当有布局的frame改变的时候都去重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


//返回当前rect下所有的cell布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{

    NSMutableArray *attris = [NSMutableArray array];
    //获取某一个Section下面Item的条数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i= 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attri = [self layoutAttributesForItemAtIndexPath:indexPath];
        [attris addObject:attri];
    }
    return attris;
}


static float sizeWH = 80;


//返回每一个cell的当前布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //计算cell 的位置
    CGPoint vCenter =  self.collectionView.center;
    CGFloat radius = (self.collectionView.bounds.size.width - sizeWH) / 2.0;
    CGFloat dushu = M_PI * 2 / [self.collectionView numberOfItemsInSection:0];
    
    CGFloat x = radius * cos(dushu * indexPath.item);
    CGFloat y = radius * sin(dushu * indexPath.item);
    
    CGPoint itemCenter = CGPointMake(vCenter.x + x, vCenter.y + y);
    
    
    //获取当前indexPath的cell的布局属性（注意不要自己创建UICollectionViewLayoutAttributes系统会根据indexPath自动创建每个cell的布局属性）
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.size = CGSizeMake(50, 50);
    attri.center = itemCenter;
    return attri;
}


//- (CGSize)collectionViewContentSize{
//
//}




@end
