//
//  SelfRotationLayout.m
//  collection3D
//
//  Created by zhutaofeng on 15/6/23.
//  Copyright (c) 2015年 cheyinwang. All rights reserved.
//

#import "SelfRotationLayout.h"

#define radiusLength 100.0
#define centerX self.view.center.x
#define centerY self.view.center.y


#define degressToRadians(x) (x / 180.0 * M_PI)
#define radiansToDegrees(x) (180.0 * x / M_PI)

@interface SelfRotationLayout ()
{
    CGSize _ccontentSize;
}

@end


@implementation SelfRotationLayout

-(CGSize)collectionViewContentSize
{
    float width = self.collectionView.frame.size.width *([self.collectionView numberOfItemsInSection:0]);
    float height= self.collectionView.frame.size.height;
    CGSize  size = CGSizeMake(width, height);
    _ccontentSize = size;
    return size;
    
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


#pragma mark - UICollectionViewLayout
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //3D代码
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = CGSizeMake(160, 240);
    attributes.center = CGPointMake(self.collectionView.center.x + self.collectionView.contentOffset.x, self.collectionView.center.y);
    
  
    

    NSInteger itemCount =  [self.collectionView numberOfItemsInSection:0];
    CGFloat contentSizeWidth = _ccontentSize.width;
    CGFloat indexForRow = attributes.indexPath.item;
    CGFloat contentOffset = self.collectionView.contentOffset.x;
    NSLog(@"------width:%f -- :%f --:%f",contentSizeWidth  , indexForRow,contentOffset);

    
    
    
    CGFloat angle = (contentSizeWidth / itemCount * indexForRow + contentOffset) / contentSizeWidth * - 360;
    
    attributes.transform3D = [self getCATransform3DWithRadians:degressToRadians(angle) radius:radiusLength];
    return attributes;
}


//根据弧度计算动画
-(CATransform3D)getCATransform3DWithRadians:(CGFloat)radians radius:(CGFloat)radius
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500;
    //根据它的弧度计算它再3d坐标系中的位置（这个动画中只用到了x轴和z轴的计算没有用到y轴）
    //    transform = CATransform3DTranslate(transform, 0.0, radiusLength * sin(radians), 0.0/*z轴偏移量,其他轴也可以设置偏移量*/);
    transform = CATransform3DTranslate(transform, radius * sin(radians), 0.0f, radius * cos(radians) - 0/*z轴偏移量,其他轴也可以设置偏移量*/);
    return transform;
}



-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    if ([arr count] >0) {
        return arr;
    }
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger i=0 ; i < [self.collectionView numberOfItemsInSection:0 ]; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}


//这个方法返回滚动结束后collectionView要滚动结束的点
//collectionView每次拖动结束时调用的方法
//proposedContentOffset 滚动结束是collectionView最终的ContentOffset
//velocity 拖动结束时的滚动速度
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    NSInteger nearIndex = 0;
    CGFloat anchor = MAXFLOAT;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (int i=0; i < itemCount; i++) {
        CGFloat length = ABS(ABS(proposedContentOffset.x) - (i * _ccontentSize.width / itemCount));//每一个item距离目标停止点的绝对距离
        if (length < anchor) {
            anchor = length;
            nearIndex = i;
        }
    }
    return CGPointMake(nearIndex * _ccontentSize.width / itemCount, self.collectionView.contentOffset.y);
}


@end
