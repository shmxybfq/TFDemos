//
//  TFCirculationSV.h
//  VoiceLink
//
//  Created by Hyacinth on 14-9-12.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol TFCirculationSVDelegate <NSObject>

- (void)TFCirculationSVDidScroll:(UIScrollView *)scrollView;
- (void)TFCirculationSVDidChangeIndex:(NSInteger)newIndex view:(UIView *)view;

@end





@interface TFCirculationSV : UIView<UIScrollViewDelegate>

@property (nonatomic,retain)UIImageView *bgViewIV;

@property (nonatomic,assign)id<TFCirculationSVDelegate> delegate;
@property (nonatomic,retain)UIScrollView   *scrollViewSV;
@property (nonatomic,retain)NSMutableArray *scrollSubViews;
@property (nonatomic,retain)NSMutableArray *centerPoints;
@property (nonatomic,assign)NSInteger       curIndex;


-(void)setSubViewsWithArray:(NSArray *)views;
-(void)beginScrollWithTime:(float)time;
-(void)endScroll;


@end
