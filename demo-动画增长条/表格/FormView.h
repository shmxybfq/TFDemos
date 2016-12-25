//
//  FormView.h
//  表格
//
//  Created by ztf on 15/12/2.
//  Copyright © 2015年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FormView;


@protocol FormViewDataSource <NSObject>

@required
-(NSInteger)FormView:(FormView *)formView numberOfRowsInSection:(NSInteger)section;
-(NSString *)FormView:(FormView *)formView LeftText:(NSIndexPath *)indexPath;
-(CGFloat)FormView:(FormView *)formView RightViewPercent:(NSIndexPath *)indexPath;
-(CGFloat)FormView:(FormView *)formView RightViewAnimationDurition:(NSIndexPath *)indexPath;
-(CGFloat)FormView:(FormView *)formView CellHeight:(NSIndexPath *)indexPath;
-(CGFloat)FormView:(FormView *)formView BottomMargin:(NSIndexPath *)indexPath;
-(CGFloat)FormView:(FormView *)formView TopMargin:(NSIndexPath *)indexPath;

@end

@interface FormView : UIScrollView

@property (nonatomic,assign)id<FormViewDataSource>dataSource;

-(void)reloadData;
@end
