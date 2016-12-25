//
//  TFPubuliuLayout.h
//  UICollectionView03
//
//  Created by zhutaofeng on 15/4/28.
//  Copyright (c) 2015年 Hyacinth.TaskTinkle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFPubuliuLayout;
@protocol TFPubuliuLayout <NSObject>

@required
-(CGFloat)TFPubuliuLayout:(TFPubuliuLayout *)pubuliuLayout
   itemHeightForIndexPath:(NSIndexPath *)indexPath
                withWidth:(CGFloat )width;

@end

@interface TFPubuliuLayout : UICollectionViewLayout

@property (nonatomic,assign)NSInteger columnCount;//列数量
@property (nonatomic,assign)CGFloat columnMargin;//列间距
@property (nonatomic,assign)CGFloat rowMargin;//行间距
@property (nonatomic,assign)UIEdgeInsets sectionEdgeInsets;//collectionView上左下右边距


@property (nonatomic,assign)id<TFPubuliuLayout>delegate;

@end
