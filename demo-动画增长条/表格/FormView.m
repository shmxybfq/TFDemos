//
//  FormView.m
//  表格
//
//  Created by ztf on 15/12/2.
//  Copyright © 2015年 ztf. All rights reserved.
//

#import "FormView.h"

#import "FormCell.h"



@implementation FormView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)reloadData
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (![self.dataSource respondsToSelector:@selector(FormView:numberOfRowsInSection:)]) {
        return;
    }
    
    CGFloat cellX = 0;
    CGFloat cellY = 0;
    CGFloat cellW = self.bounds.size.width;
    CGFloat cellH = 0;
    
    NSInteger rows = [self.dataSource FormView:self numberOfRowsInSection:0];
    for (NSInteger i = 0; i< rows; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];

        if ([self.dataSource respondsToSelector:@selector(FormView:TopMargin:)]) {
            cellY += [self.dataSource FormView:self TopMargin:indexPath];
        }
        if ([self.dataSource respondsToSelector:@selector(FormView:CellHeight:)]) {
            cellH = [self.dataSource FormView:self CellHeight:indexPath];
        }
        
        FormCell *cell = [[FormCell alloc]initWithFrame:CGRectMake(cellX, cellY, cellW, cellH)];
        [self addSubview:cell];
        
        if ([self.dataSource respondsToSelector:@selector(FormView:LeftText:)]) {
            cell.leftLB.text = [self.dataSource  FormView:self LeftText:indexPath];
        }
        
        cellY += cellH;
        
        if ([self.dataSource respondsToSelector:@selector(FormView:BottomMargin:)]) {
            cellY += [self.dataSource FormView:self BottomMargin:indexPath];
        }
        
       
        
        CGFloat percent = 0;
        if ([self.dataSource respondsToSelector:@selector(FormView:RightViewPercent:)]) {
            percent = [self.dataSource FormView:self RightViewPercent:indexPath];
        }
        CGFloat durition = 0;
        if ([self.dataSource respondsToSelector:@selector(FormView:RightViewAnimationDurition:)]) {
            durition = [self.dataSource FormView:self RightViewAnimationDurition:indexPath];
        }
        
        [cell startAnimationToPercent:percent durition:durition completion:nil];

  

    }
    
    self.contentSize = CGSizeMake(self.bounds.size.width, cellY);

}



@end
