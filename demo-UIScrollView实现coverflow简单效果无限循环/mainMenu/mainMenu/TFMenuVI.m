//
//  TFMenuVI.m
//  VoiceLink
//
//  Created by Hyacinth on 14-9-23.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFMenuVI.h"


@implementation TFMenuVI


@synthesize mainBT = _mainBT;
@synthesize imageStr = _imageStr;
@synthesize index = _index;

-(void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect sb = self.bounds;
        CGPoint sc = CGPointMake(sb.size.width /2.0, sb.size.height /2.0);
        
        _mainBT = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        _mainBT.layer.cornerRadius = 100;
        _mainBT.layer.masksToBounds = YES;
        [self addSubview:_mainBT];
        
        //        _mainBT.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0
        //                                                  green:arc4random()%255/255.0
        //                                                   blue:arc4random()%255/255.0
        //                                                  alpha:1];
        _mainBT.center = sc;
        //        self.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0
        //                                               green:arc4random()%255/255.0
        //                                                blue:arc4random()%255/255.0
        //                                               alpha:1];
    }
    return self;
}

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = [imageStr copy];
    UIImage *iamge = [UIImage imageNamed:self.imageStr];
    [_mainBT setImage:iamge forState:UIControlStateNormal];
}

-(void)setOfSet:(CGPoint)ofSet
{
    CGPoint point  = ofSet;
    CGRect sf = self.frame;
    CGPoint sc = self.center;
    
    float juli = sc.x - point.x;
    
    
    float scale = 0.5;
    if (juli >160 && juli <320) {
        scale = 1- (juli - 160)/160;
    }else if (juli<=160 &&juli>0){
        scale = 1-(160-juli)/160;
    }else{
        //        scale =1;
    }
    
    [self setViewDisplayWithLevel:scale max:1.0 min:0.7];
}

-(void)tfkMainViewScaleMethod:(NSNotification *)notification
{
    
    CGPoint point  = CGPointFromString([NSString stringWithFormat:@"%@",notification.object]);
    CGRect sf = self.frame;
    CGPoint sc = self.center;
    
    float juli = sc.x - point.x;
    
    
    float scale = 0.5;
    if (juli >160 && juli <320) {
        scale = 1- (juli - 160)/160;
        
    }else if (juli<=160 &&juli>0){
        scale = 1-(160-juli)/160;
    }else{
        //        scale =1;
    }
    
    [self setViewDisplayWithLevel:scale max:1.0 min:0.7];
}

-(void)setViewDisplayWithLevel:(float)level max:(float)max min:(float)min
{
    level = level < min?min:level;
    level = level > max?max:level;
    
    _mainBT.alpha = level;
    //重置
    _mainBT.transform = CGAffineTransformIdentity;
    _mainBT.transform = CGAffineTransformMakeScale(level, level);
}



@end
