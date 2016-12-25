//
//  ShowImageView.m
//  UICollectionView03
//
//  Created by zhutaofeng on 15/4/29.
//  Copyright (c) 2015年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "ShowImageView.h"

@implementation ShowImageView




-(id)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {

    }return self;

}

-(void)awakeFromNib
{
    [self.tap addTarget:self action:@selector(tapClick)];

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

-(void)tapClick
{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = self.oldFrame;
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
    
    NSLog(@"%s",__func__);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
