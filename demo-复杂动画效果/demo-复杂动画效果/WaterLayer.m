//
//  WaterLayer.m
//  demo-复杂动画效果
//
//  Created by 融数 on 16/11/24.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "WaterLayer.h"
#import "TFEasyCoder.h"
#import "CircleLayer.h"
@interface WaterLayer ()

@property (nonatomic,strong)UIBezierPath *path1;
@property (nonatomic,strong)UIBezierPath *path2;
@property (nonatomic,strong)UIBezierPath *path3;
@property (nonatomic,strong)UIBezierPath *path4;
@property (nonatomic,strong)UIBezierPath *path5;
@property (nonatomic,strong)UIBezierPath *path6;
@property (nonatomic,strong)UIBezierPath *path7;

@end



@implementation WaterLayer



-(instancetype)init{
    if (self = [super init]) {
        self.fillColor = [UIColor redColor].CGColor;
        self.strokeColor = [UIColor redColor].CGColor;
        self.path = self.path1.CGPath;
        self.lineWidth = 5;
    }
    return self;
}

-(CGFloat)waterAnimation{
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation1.fromValue = (__bridge id)self.path1.CGPath;
    animation1.toValue = (__bridge id)self.path2.CGPath;
    animation1.duration = AnimationTime;
    animation1.beginTime = 0;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation2.fromValue = (__bridge id)self.path2.CGPath;
    animation2.toValue = (__bridge id)self.path3.CGPath;
    animation2.duration = AnimationTime;
    animation2.beginTime = animation1.beginTime + AnimationTime;
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation3.fromValue = (__bridge id)self.path3.CGPath;
    animation3.toValue = (__bridge id)self.path4.CGPath;
    animation3.duration = AnimationTime;
    animation3.beginTime = animation2.beginTime + AnimationTime;
    
    CABasicAnimation *animation4 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation4.fromValue = (__bridge id)self.path4.CGPath;
    animation4.toValue = (__bridge id)self.path5.CGPath;
    animation4.duration = AnimationTime;
    animation4.beginTime = animation3.beginTime + AnimationTime;
    
    CABasicAnimation *animation5 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation5.fromValue = (__bridge id)self.path5.CGPath;
    animation5.toValue = (__bridge id)self.path6.CGPath;
    animation5.duration = AnimationTime;
    animation5.beginTime = animation4.beginTime + AnimationTime;
 
    CABasicAnimation *animation6 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation6.fromValue = (__bridge id)self.path6.CGPath;
    animation6.toValue = (__bridge id)self.path7.CGPath;
    animation6.duration = AnimationTime;
    animation6.beginTime = animation5.beginTime + AnimationTime;
 
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animation1,
                         animation2,
                         animation3,
                         animation4,
                         animation5,
                         animation6];
    group.removedOnCompletion = NO;
    group.duration = AnimationTime * 6;
    group.fillMode = kCAFillModeForwards;
    [self addAnimation:group forKey:nil];
    
    return group.duration;
}

-(UIBezierPath *)path1{
    
    if (_path1 == nil) {
        _path1 = [UIBezierPath bezierPath];
        [_path1 moveToPoint:CGPointMake(0, 80)];
        [_path1 addLineToPoint:CGPointMake(0, 80)];
        [_path1 addLineToPoint:CGPointMake(100, 80)];
        [_path1 addLineToPoint:CGPointMake(100, 80)];
        [_path1 addLineToPoint:CGPointMake(0, 80)];
        [_path1 closePath];
    }
    return _path1;
}
-(UIBezierPath *)path2{
    
    if (_path2 == nil) {
        _path2 = [UIBezierPath bezierPath];
        [_path2 moveToPoint:CGPointMake(0, 80)];
        [_path2 addLineToPoint:CGPointMake(0, 60)];
        [_path2 addCurveToPoint:CGPointMake(100, 60)
                  controlPoint1:CGPointMake(33, 50)
                  controlPoint2:CGPointMake(66, 70)];
        [_path2 addLineToPoint:CGPointMake(100, 80)];
        [_path2 addLineToPoint:CGPointMake(0, 80)];
        [_path2 closePath];
    }
    return _path2;
}
-(UIBezierPath *)path3{
    
    if (_path3 == nil) {
        _path3 = [UIBezierPath bezierPath];
        [_path3 moveToPoint:CGPointMake(0, 80)];
        [_path3 addLineToPoint:CGPointMake(0, 40)];
        [_path3 addCurveToPoint:CGPointMake(100, 40)
                  controlPoint1:CGPointMake(33, 50)
                  controlPoint2:CGPointMake(66, 40)];
        [_path3 addLineToPoint:CGPointMake(100, 80)];
        [_path3 addLineToPoint:CGPointMake(0, 80)];
        [_path3 closePath];
    }
    return _path3;
}
-(UIBezierPath *)path4{
    
    if (_path4 == nil) {
        _path4 = [UIBezierPath bezierPath];
        [_path4 moveToPoint:CGPointMake(0, 80)];
        [_path4 addLineToPoint:CGPointMake(0, 20)];
        [_path4 addCurveToPoint:CGPointMake(100, 20)
                  controlPoint1:CGPointMake(33, 10)
                  controlPoint2:CGPointMake(66, 30)];
        [_path4 addLineToPoint:CGPointMake(100, 80)];
        [_path4 addLineToPoint:CGPointMake(0, 80)];
        [_path4 closePath];
    }
    return _path4;
}

-(UIBezierPath *)path5{
    
    if (_path5 == nil) {
        _path5 = [UIBezierPath bezierPath];
        [_path5 moveToPoint:CGPointMake(0, 80)];
        [_path5 addLineToPoint:CGPointMake(0, 0)];
        [_path5 addCurveToPoint:CGPointMake(100, 0)
                  controlPoint1:CGPointMake(33, -10)
                  controlPoint2:CGPointMake(66, 10)];
        [_path5 addLineToPoint:CGPointMake(100, 80)];
        [_path5 addLineToPoint:CGPointMake(0, 80)];
        [_path5 closePath];
    }
    return _path5;
}
-(UIBezierPath *)path6{
    
    if (_path6 == nil) {
        _path6 = [UIBezierPath bezierPath];
        [_path6 moveToPoint:CGPointMake(0, 80)];
        [_path6 addLineToPoint:CGPointMake(0, -10)];
        [_path6 addCurveToPoint:CGPointMake(100, -10)
                  controlPoint1:CGPointMake(33, 10)
                  controlPoint2:CGPointMake(66, -10)];
        [_path6 addLineToPoint:CGPointMake(100, 80)];
        [_path6 addLineToPoint:CGPointMake(0, 80)];
        [_path6 closePath];
    }
    return _path6;
}
-(UIBezierPath *)path7{
    
    if (_path7 == nil) {
        _path7 = [UIBezierPath bezierPath];
        [_path7 moveToPoint:CGPointMake(0, 80)];
        [_path7 addLineToPoint:CGPointMake(0, -20)];
        [_path7 addCurveToPoint:CGPointMake(100, -20)
                  controlPoint1:CGPointMake(33, -20)
                  controlPoint2:CGPointMake(66, -20)];
        [_path7 addLineToPoint:CGPointMake(100, 80)];
        [_path7 addLineToPoint:CGPointMake(0, 80)];
        [_path7 closePath];
    }
    return _path7;
}





@end
