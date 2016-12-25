//
//  B0_FlowVI.h
//  shop
//
//  Created by 梦想 on 15/12/20.
//  Copyright © 2015年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B0_CollectionVI.h"

@class B0_FlowVI;
typedef void (^FlowVICallBackBlock) (NSString *brand,B0_FlowVI *flowVI);

@interface B0_FlowVI : UIImageView


@property (nonatomic,retain)B0_CollectionVI *collectionView;
@property (nonatomic,retain)NSMutableArray *dataArray;


-(instancetype)initWithFrame:(CGRect)frame callBack:(FlowVICallBackBlock)callBackBlock;

-(void)reloadCollectionData:(__kindof NSArray *)data;
@end
