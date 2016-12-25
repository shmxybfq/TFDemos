//
//  DiantaiFlowlayout.m
//  DrivoS_src
//
//  Created by zhutaofeng on 15/6/24.
//  Copyright (c) 2015年 cheyinwang. All rights reserved.
//

#import "DiantaiFlowlayout.h"
#define ItemSizeWidth 200 * (508 / 1080.0)
#define ItemSizeHeight 200 *1.5 * (508 / 1080.0)
#define MinimumLineSpacing (- ItemSizeWidth * (1.0 / 30.0))

@interface DiantaiFlowlayout ()
{

    DiantaiFlowlayoutWillStopAtIndexPathCallBack _stopAtIndexPathCallBack;

}

@end

@implementation DiantaiFlowlayout

-(instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}




//准备布局
//每次重新布局前都会调用这个方法
-(void)prepareLayout
{
    [super prepareLayout];
    //滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //每一个cell的大小
    self.itemSize = CGSizeMake(ItemSizeWidth, ItemSizeHeight);
    //sectionInset每一个section之间里面的内容距离section两边之间的距离
    //也就是现在刚启动时第一个cell离最左边的距离，和最后一个cell离最右边的距离
    CGFloat topBottomMargin = (self.collectionView.frame.size.height  - ItemSizeHeight)* 0.5;
    CGFloat leftRightMargin = 0;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(topBottomMargin,  leftRightMargin, topBottomMargin, leftRightMargin);
    self.sectionInset = insets;
    
    //每一行之间的最小间距
    //对于当前来说是每个cell之间的距离，因为这个collectionView只有一行而且是横向滚动的
    self.minimumLineSpacing = MinimumLineSpacing;
}

//返回 每次collectionView边界改变是否重新布局
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//这个方法返回滚动结束后collectionView要滚动结束的点
//collectionView每次拖动结束时调用的方法
//proposedContentOffset 滚动结束是collectionView最终的ContentOffset
//velocity 拖动结束时的滚动速度
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    
    //滚动结束时collectionView要显示的矩形范围
    CGRect proposedRect ;
    proposedRect.origin = proposedContentOffset;
    proposedRect.size = self.collectionView.frame.size;
    
    //列出滚动结束时collectionView要显示的矩形范围下所有cell的布局属性
    NSArray *attris = [super layoutAttributesForElementsInRect:proposedRect];
    
    //列出滚动结束时collectionView要显示范围的中点线
    CGFloat proposedCenterX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    //标记当前cell离拖动结束时距离终点线的最近距离
    CGFloat juli = MAXFLOAT;
    NSIndexPath *indePath = nil;
    //找出滚动结束后距离中点线最近的cell的距离
    for (UICollectionViewLayoutAttributes *atribute in attris) {
        if (ABS(atribute.center.x - proposedCenterX) < ABS(juli)) {
            juli = atribute.center.x - proposedCenterX;
            indePath = atribute.indexPath;
        }
    }

    if (_stopAtIndexPathCallBack) {
        _stopAtIndexPathCallBack(indePath);
    }
    
    //返回滚动结束后collectionView要滚动结束的点
    //这个点是cell自动滚动到collectionView中间的点
    return CGPointMake(proposedContentOffset.x + juli, proposedContentOffset.y);
}


-(void)getStopIndexPath:(DiantaiFlowlayoutWillStopAtIndexPathCallBack)callBack
{
    _stopAtIndexPathCallBack = callBack;
}

//这个方法返回当前区域下所有cell的布局属性，
//这个方法和shouldInvalidateLayoutForBoundsChange是对应的,如果shouldInvalidateLayoutForBoundsChange返回yes
//则系统就会调用此方法重新布局，如果返回no则每有新一屏cell出现才会调用一次此方法
//所有cell的布局均依赖于此方法，所以如果要对cell布局做更改必须实时改变此方法所控制cell的属性
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //当前显示的矩形区域
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.frame.size;
    
    //列出当前显示的矩形区域下所有cell的布局属性
    NSArray *atrrs = [super layoutAttributesForElementsInRect:rect];
    
    //当前显示的矩形区域下的中点线x
    CGFloat visibleCenterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    //遍历得到的所有cell的属性
    for (UICollectionViewLayoutAttributes *atribute in atrrs) {
        //如果当前cell不在当前视野范围内，那就不需要做多余的计算了，直接跳过就好了
        if (!CGRectIntersectsRect(visibleRect, atribute.frame)) {
            continue;
        }
        //计算cell和当前显示的矩形区域下的中点线x之间距离的绝对值和 collectionView之间的比值
        //(因为现在要根据cell距离中间的距离计算cell需要缩放的大小)
        CGFloat bizhi =  ABS(atribute.center.x - visibleCenterX) / self.collectionView.frame.size.width;
        //这里的1.0是原始的缩放大小，0.5表示宽度的二分之一 ,"bizhi" 是一个永远小与0.5的数
        CGFloat scale =  1.0 + (0.35 - bizhi);
        scale = scale < 1.0 ? 1.0 : scale;
        //根据距离的计算设置cell缩放的大小
        
        if (atribute.indexPath.row == 0) {
        NSLog(@"scale==========:%@:%@",@(scale),@(atribute.indexPath.row));
        }

        
        atribute.alpha = 1 - (1.35 - scale);
        atribute.transform3D = CATransform3DMakeScale(scale, scale, 1);
    }
    
    NSArray *sortedAtrrs =  [atrrs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        UICollectionViewLayoutAttributes *atribute1 = obj1;
        UICollectionViewLayoutAttributes *atribute2 = obj2;
        NSNumber *length1 =  @(ABS(atribute1.center.x - visibleCenterX));
        NSNumber *length2 =  @(ABS(atribute2.center.x - visibleCenterX));
        return [length1 compare:length2];
    }];
    
    for (UICollectionViewLayoutAttributes *atribute in sortedAtrrs) {
        UICollectionViewCell *cell =  [self.collectionView cellForItemAtIndexPath:atribute.indexPath];
        [self.collectionView sendSubviewToBack:cell];
//        NSLog(@"-----------------000000000000:%@",@(ABS(atribute.center.x - visibleCenterX)));

        
    }
    
    return atrrs;
}



@end
