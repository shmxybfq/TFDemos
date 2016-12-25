//
//  DiantaiFlowlayout.h
//  DrivoS_src
//
//  Created by zhutaofeng on 15/6/24.
//  Copyright (c) 2015年 cheyinwang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^DiantaiFlowlayoutWillStopAtIndexPathCallBack) (NSIndexPath *indexPath);

@interface DiantaiFlowlayout : UICollectionViewFlowLayout

-(void)getStopIndexPath:(DiantaiFlowlayoutWillStopAtIndexPathCallBack)callBack;

@end
