//
//  FormCell.m
//  表格
//
//  Created by ztf on 15/12/2.
//  Copyright © 2015年 ztf. All rights reserved.
//

#import "FormCell.h"


#ifndef BMUIHexColor
#define BMUIHexColor(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

@interface FormCell()
@property (nonatomic,strong)UIView  *animationView;
@end

@implementation FormCell

-(instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.leftLB = [[UILabel alloc]initWithFrame:CGRectZero];
        self.leftLB.textAlignment = NSTextAlignmentCenter;
        self.leftLB.textColor = [UIColor blackColor];
        self.leftLB.font = [UIFont systemFontOfSize:12.0];
        [self sizeToFit];
        
        [self addSubview:self.leftLB];
        self.leftLB.frame = CGRectMake(0, 0, 50, frame.size.height);
        
        
        self.animationView = [[UIView alloc]initWithFrame:CGRectZero];
        self.animationView.backgroundColor = BMUIHexColor(0xFF4800);
        [self addSubview:self.animationView];
        self.animationView.frame = CGRectMake(CGRectGetMaxX(self.leftLB.frame), 0, 1, frame.size.height);
        
        
        self.animationRect = CGRectMake(0, 0, frame.size.width - self.leftLB.frame.size.width, frame.size.height);
    }
    return self;
}

-(void)startAnimationToPercent:(CGFloat)toPercent durition:(NSTimeInterval)durition completion:(Completion)completion
{
    [UIView animateWithDuration:durition animations:^{
        self.animationView.frame = CGRectMake(CGRectGetMaxX(self.leftLB.frame), 0, self.animationRect.size.width * toPercent, self.animationRect.size.height);
    } completion:completion];
}





@end
