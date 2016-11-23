//
//  ViewController.m
//  demo-关键帧动画
//
//  Created by ztf on 16/11/21.
//  Copyright © 2016年 ztf. All rights reserved.
//

#import "ViewController.h"
#import "TFEasyCoder.h"


@interface ViewController ()

@property (nonatomic,strong)UIButton *demoView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    kdeclare_weakself;
    

    
    
    NSArray *titles = @[
                        @"path椭圆",
                        @"贝塞尔矩形",
                        @"贝塞尔抛物线",
                        @"贝塞尔s曲线",
                        @"贝塞尔圆",
                        @"弹力仿真",
                        @"自晃动",
                        @"指定点平移",
                        ];
    
    for (unsigned int i = 0; i < titles.count; i++) {
        
        [UIButton easyCoder:^(UIButton *ins) {
            [weakSelf.view addSubview:ins];
            ins.backgroundColor = [UIColor brownColor];
            ins.tag = i;
            ins.frame = CGRectMake(10, 50 + 35 * i, 100, 30);
            ins.titleLabel.adjustsFontSizeToFitWidth = YES;
            [ins setTitle:titles[i] forState:UIControlStateNormal];
            [ins addTarget:self action:@selector(animationBegin:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    
    
    
    [UIButton easyCoder:^(UIButton *ins) {
        
        ins.frame = CGRectMake(0, 0, 100, 100);
        ins.backgroundColor = [UIColor redColor];
        ins.center = CGPointMake(weakSelf.view.center.x, 10);
        [ins setTitle:@"我" forState:UIControlStateNormal];
        [ins addTarget:weakSelf
                action:@selector(demoViewClick)
      forControlEvents:UIControlEventTouchUpInside];
        
        weakSelf.demoView = ins;
        [weakSelf.view addSubview:weakSelf.demoView];
    }];
    
    
    
}

-(void)demoViewClick{
    NSLog(@"点到我了!");
}

-(void)animationBegin:(UIButton *)bt
{
    
    switch (bt.tag) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            [self path:bt.tag];break;
        case 6:
        case 7:
            [self values:bt.tag];break;

        default:
            break;
    }
    
}





-(void)path:(NSInteger)tag{
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    switch (tag) {
        case 0:{
            //椭圆
            CGMutablePathRef path = CGPathCreateMutable();//创建可变路径
            CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 320, 500));
            [animation setPath:path];
            CGPathRelease(path);
            animation.rotationMode = kCAAnimationRotateAuto;
            
        }break;
        case 1:{
            //贝塞尔,矩形
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 320)];
            //animation需要的类型是CGPathRef，UIBezierPath是ui的,需要转化成CGPathRef
            [animation setPath:path.CGPath];
            
            
        }break;
        case 2:{
            //贝塞尔,抛物线
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:self.demoView.center];
            [path addQuadCurveToPoint:CGPointMake(0, 568)
                         controlPoint:CGPointMake(400, 100)];
            [animation setPath:path.CGPath];

        }break;
        case 3:{
            //贝塞尔,s形曲线
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointZero];
            [path addCurveToPoint:self.demoView.center
                    controlPoint1:CGPointMake(320, 100)
                    controlPoint2:CGPointMake(  0, 400)];
            ;
            [animation setPath:path.CGPath];

            
        }break;
        case 4:{
            //贝塞尔,圆形
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.view.center
                                                                 radius:150
                                                             startAngle:- M_PI * 0.5
                                                               endAngle:M_PI * 2
                                                              clockwise:YES];
            [animation setPath:path.CGPath];

            
        }break;
        case 5:{
            CGPoint point = CGPointMake(self.view.center.x, 400);
            CGFloat xlength = point.x - self.demoView.center.x;
            CGFloat ylength = point.y - self.demoView.center.y;
            
            CGMutablePathRef path = CGPathCreateMutable();
            //移动到目标点
            CGPathMoveToPoint(path, NULL, self.demoView.center.x, self.demoView.center.y);
            //将目标点的坐标添加到路径中
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
            //设置弹力因子,
            CGFloat offsetDivider = 5.0f;
            BOOL stopBounciong = NO;
            while (stopBounciong == NO) {
                CGPathAddLineToPoint(path, NULL, point.x + xlength / offsetDivider, point.y + ylength / offsetDivider);
                CGPathAddLineToPoint(path, NULL, point.x, point.y);
                offsetDivider += 6.0;
                //当视图的当前位置距离目标点足够小我们就退出循环
                if ((ABS(xlength / offsetDivider) < 10.0f) && (ABS(ylength / offsetDivider) < 10.0f)) {
                    break;
                }
            }
            [animation setPath:path];
            
        }break;
        default:break;
    }
    
    [animation setDuration:0.5];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeBoth];
    [self.demoView.layer addAnimation:animation forKey:nil];
}


-(void)values:(NSInteger)tag{

    CAKeyframeAnimation *animation = nil;
    switch (tag) {
        case 6:{
            animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
            
            CGFloat angle = M_PI_4 * 0.5;
            NSArray *values = @[@(angle),@(-angle),@(angle)];
            [animation setValues:values];
            [animation setRepeatCount:3];
            [animation setDuration:0.5];
        }break;
        case 7:{

           
            animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            NSValue *p1 = [NSValue valueWithCGPoint:self.demoView.center];
            NSValue *p2 = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x + 100, 200)];
            NSValue *p3 = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, 300)];
            //设置关键帧的值
            [animation setValues:@[p1,p2,p3]];
            [animation setDuration:0.5];
        }break;
        default:break;
    }

    UIGraphicsBeginImageContext(self.view.frame.size);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeBoth];
    [self.demoView.layer addAnimation:animation forKey:nil];
}


- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"animation-start ======start:%@",NSStringFromCGRect(self.demoView.frame));
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"animation-start ======end:%@",NSStringFromCGRect(self.demoView.frame));
}


@end
