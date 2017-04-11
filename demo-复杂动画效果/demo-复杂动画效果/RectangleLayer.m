//
//  RectangleLayer.m
//  demo-复杂动画效果
//
//  Created by 融数 on 16/11/24.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "RectangleLayer.h"
#import "CircleLayer.h"
@interface RectangleLayer ()

@property (nonatomic,strong)UIBezierPath *rectPath;


@end

@implementation RectangleLayer


-(instancetype)init{
    if (self = [super init]) {
        self.fillColor = [UIColor clearColor].CGColor;
        self.lineWidth = 5;
        self.path = self.rectPath.CGPath;
    }
    return self;
}

-(CGFloat)rectangleAnimation:(UIColor *)color{
    self.strokeColor = color.CGColor;
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    animation.duration = AnimationTime * 2;
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = NO;
    [self addAnimation:animation forKey:nil];
    return animation.duration;
}

-(UIBezierPath *)rectPath{
    if (_rectPath == nil) {
        _rectPath = [UIBezierPath bezierPath];
        [_rectPath moveToPoint:CGPointMake(-0, 80)];
        [_rectPath addLineToPoint:CGPointMake(0, -20)];
        [_rectPath addLineToPoint:CGPointMake(100, -20)];
        [_rectPath addLineToPoint:CGPointMake(100, 80)];
        [_rectPath closePath];
    }
    return  _rectPath;
}



@end
