//
//  TriangleLayer.m
//  demo-复杂动画效果
//
//  Created by 融数 on 16/11/24.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "TriangleLayer.h"
#import "CircleLayer.h"

@interface TriangleLayer ()

@property (nonatomic,strong)UIBezierPath *normalPath;
@property (nonatomic,strong)UIBezierPath *leftPath;
@property (nonatomic,strong)UIBezierPath *rightPath;
@property (nonatomic,strong)UIBezierPath *topPath;



@end


@implementation TriangleLayer

-(instancetype)init{
    if (self = [super init]) {
        self.fillColor = [UIColor redColor].CGColor;
        self.strokeColor = [UIColor redColor].CGColor;
        self.lineCap = kCALineCapRound;//线头圆
        self.lineJoin = kCALineJoinRound;//拐角圆
        self.lineWidth = 5;
        self.path = self.normalPath.CGPath;
    }
    return self;
}

-(CGFloat)growAnimation{

    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation1.fromValue = (__bridge id)self.normalPath.CGPath;
    animation1.toValue = (__bridge id)self.leftPath.CGPath;
    animation1.beginTime = 0.0;
    animation1.duration = AnimationTime;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation2.fromValue = (__bridge id)self.leftPath.CGPath;
    animation2.toValue = (__bridge id)self.rightPath.CGPath;
    animation2.beginTime = animation1.beginTime + animation1.duration;
    animation2.duration = AnimationTime;
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation3.fromValue = (__bridge id)self.rightPath.CGPath;
    animation3.toValue = (__bridge id)self.topPath.CGPath;
    animation3.beginTime = animation2.beginTime + animation2.duration;
    animation3.duration = AnimationTime;

    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation1,animation2,animation3];
    group.removedOnCompletion = NO;
    group.duration = AnimationTime * 3;
    group.fillMode = kCAFillModeForwards;
    [self addAnimation:group forKey:nil];
    
    return group.duration;
}


-(UIBezierPath *)normalPath{
    if (_normalPath == nil) {
        _normalPath = [UIBezierPath bezierPath];
        [_normalPath moveToPoint:CGPointMake(50, 10)];
        [_normalPath addLineToPoint:CGPointMake(20, 80)];
        [_normalPath addLineToPoint:CGPointMake(80, 80)];
        [_normalPath closePath];
    }
    return _normalPath;
}

-(UIBezierPath *)leftPath{
    if (_leftPath == nil) {
        _leftPath = [UIBezierPath bezierPath];
        [_leftPath moveToPoint:CGPointMake(50, 10)];
        [_leftPath addLineToPoint:CGPointMake(0, 80)];
        [_leftPath addLineToPoint:CGPointMake(80, 80)];
        [_leftPath closePath];
    }
    return _leftPath;
}

-(UIBezierPath *)rightPath{
    if (_rightPath == nil) {
        _rightPath = [UIBezierPath bezierPath];
        [_rightPath moveToPoint:CGPointMake(50, 10)];
        [_rightPath addLineToPoint:CGPointMake(0, 80)];
        [_rightPath addLineToPoint:CGPointMake(100, 80)];
        [_rightPath closePath];
    }
    return _rightPath;
}

-(UIBezierPath *)topPath{
    if (_topPath == nil) {
        _topPath = [UIBezierPath bezierPath];
        [_topPath moveToPoint:CGPointMake(50, -10)];
        [_topPath addLineToPoint:CGPointMake(0, 80)];
        [_topPath addLineToPoint:CGPointMake(100, 80)];
        [_topPath closePath];
    }
    return _topPath;
}





@end
