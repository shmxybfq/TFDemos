//
//  TFPubuliuLayout.m
//  UICollectionView03
//
//  Created by zhutaofeng on 15/4/28.
//  Copyright (c) 2015年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFPubuliuLayout.h"

#define tfStrInt(A) [NSString stringWithFormat:@"%d",A]

@interface TFPubuliuLayout ()
{
}

@property (nonatomic,assign)CGFloat columnWidth;//列宽度
@property (nonatomic,strong)NSMutableDictionary *columnMinYInfo;//每一列最小Y的信息
@property (nonatomic,strong)NSMutableArray *allAttris;//所有cell属性（为提升性能，不用也没事）

@end



@implementation TFPubuliuLayout


//获取每一列和它的最小Y
-(NSMutableDictionary *)columnMinYInfo
{
    if (!_columnMinYInfo) {
        _columnMinYInfo = [[NSMutableDictionary alloc]init];
    }
    return _columnMinYInfo;
}

//所有cell属性（为提升性能，不用也没事）
-(NSMutableArray *)allAttris
{
    if (!_allAttris) {
        _allAttris = [[NSMutableArray alloc]init];
    }
    return _allAttris;
}

//设置列间隔
-(void)setColumnMargin:(CGFloat)columnMargin
{
    _columnMargin = columnMargin;
    [self.collectionView reloadData];
}

//获取列宽
-(CGFloat)columnWidth
{
    _columnWidth = ((self.collectionView.bounds.size.width - self.sectionEdgeInsets.left - self.sectionEdgeInsets.right) - (self.columnCount - 1) *self.columnMargin)/ self.columnCount;
    return _columnWidth;
}

//设置行间隔
-(void)setRowMargin:(CGFloat)rowMargin
{
    _rowMargin = rowMargin;
    [self.collectionView reloadData];
}

//设置collectionView内边距
-(void)setSectionEdgeInsets:(UIEdgeInsets)sectionEdgeInsets
{
    _sectionEdgeInsets = sectionEdgeInsets;
    [self.collectionView reloadData];
}

//设置列数
-(void)setColumnCount:(NSInteger)columnCount
{
    _columnCount = columnCount;
    [self.columnMinYInfo removeAllObjects];
    for (int i= 0; i < _columnCount; i++) {
        [self.columnMinYInfo setObject:@(0) forKey:tfStrInt(i)];
    }
    [self.collectionView reloadData];
}


-(instancetype)init
{
    self = [super init];
    if (self) {
        
        self.columnCount = 3;
        self.columnMargin = 5;
        self.rowMargin = 5;
        self.sectionEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        [self.allAttris removeAllObjects];
        
        NSLog(@"==============%s",__func__);
    }
    return self;
}




//重新布局前的准备（系统调用）
- (void)prepareLayout
{
    //重新算下列宽
    _columnWidth = ((self.collectionView.bounds.size.width - self.sectionEdgeInsets.left - self.sectionEdgeInsets.right) - (self.columnCount - 1) *self.columnMargin)/ self.columnCount;
    
    
    [_allAttris removeAllObjects];
    
    [self.columnMinYInfo removeAllObjects];
    for (int i= 0; i < _columnCount; i++) {
        [self.columnMinYInfo setObject:@(self.sectionEdgeInsets.top) forKey:tfStrInt(i)];
    }
    

    //获取某一个Section下面Item的条数
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i= 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attri = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_allAttris addObject:attri];
    }
    
}


//是否每有布局改动就重新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    NSLog(@"==============%s",__func__);
    return YES;
}


//返回当前rect下所有的cell布局属性
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"==============%s",__func__);

    return _allAttris;
}




//返回每一个cell的当前布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
            NSLog(@"==============%s",__func__);
    //瀑布流布局
    return [self pubuliuIndexPath:indexPath];
    //原型布局
    return [self circleIndexPath:indexPath];
}


-(UICollectionViewLayoutAttributes *)pubuliuIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"==============%s",__func__);
    //获取当前cell的布局属性
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    //根据图片计算cell的尺寸
    CGFloat height  = [self.delegate TFPubuliuLayout:self
                              itemHeightForIndexPath:indexPath
                                           withWidth:_columnWidth];
    attri.size = CGSizeMake(_columnWidth, height);
    
    
    //计算cell 应该放在哪一列？
    __block float minY = MAXFLOAT;
    __block int column = 0;
    [self.columnMinYInfo enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
        CGFloat y =  [[self.columnMinYInfo objectForKey:key]floatValue];
        if (y < minY) {
            column = [key intValue];
            minY = y;
        }
    }];
    
    
    
    float w = attri.size.width;
    float h = attri.size.height;
    float x = self.sectionEdgeInsets.left + (_columnWidth + self.columnMargin) * column;
    float y = minY;
    CGRect r = CGRectMake(x, y, w, h);
    attri.frame = r;
    
    //更新列对应的最小Y的信息
    minY += (h + self.rowMargin);
    [_columnMinYInfo setObject:@(minY) forKey:tfStrInt(column)];
    
    return attri;
}



- (CGSize)collectionViewContentSize
{
        NSLog(@"==============%s",__func__);
    //计算collectionViewContentSize 是所有列中的最大Y值
    __block float maxY = 0;
    [self.columnMinYInfo enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * obj, BOOL *stop) {
        CGFloat y =  [[self.columnMinYInfo objectForKey:key]floatValue];
        if (y > maxY) {
            maxY = y;
        }
    }];
    
    CGFloat totalHeight = maxY + self.sectionEdgeInsets.top + self.sectionEdgeInsets.bottom;
    return CGSizeMake(self.collectionView.bounds.size.width, totalHeight);
}


//原型布局
static float sizeWH = 30;
-(UICollectionViewLayoutAttributes *)circleIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@"==============%s",__func__);
    //计算cell 的位置
    CGPoint vCenter =  self.collectionView.center;
    CGFloat radius = (self.collectionView.bounds.size.width - sizeWH) / 2.0;
    CGFloat dushu = M_PI * 2 / [self.collectionView numberOfItemsInSection:0];
    
    CGFloat x = radius * cos(dushu * indexPath.item);
    CGFloat y = radius * sin(dushu * indexPath.item);
    
    CGPoint itemCenter = CGPointMake(vCenter.x + x, vCenter.y + y);
    
    
    //获取当前indexPath的cell的布局属性（注意不要自己创建UICollectionViewLayoutAttributes系统会根据indexPath自动创建每个cell的布局属性）
    UICollectionViewLayoutAttributes *attri = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attri.size = CGSizeMake(sizeWH, sizeWH);
    attri.center = itemCenter;
    return attri;
    
}

@end
