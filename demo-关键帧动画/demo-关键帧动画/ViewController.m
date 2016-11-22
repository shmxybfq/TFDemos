//
//  ViewController.m
//  demo-关键帧动画
//
//  Created by 融数 on 16/11/21.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "ViewController.h"
#import "TFEasyCoder.h"
@interface ViewController ()

@property (nonatomic,strong)UIButton *demoView;


//CAAnimation{
//    
//    timingFunction{
//        kCAMediaTimingFunctionLinear 匀速
//        kCAMediaTimingFunctionEaseIn 慢进快出
//        kCAMediaTimingFunctionEaseOut 快进慢出
//        kCAMediaTimingFunctionEaseInEaseOut 慢进慢出 中间加速
//        kCAMediaTimingFunctionDefault 默认
//    }
//    beginTime:动画开始的时间 默认为0
//    duration:动画的持续时间 默认为0 持续时间 受速度的影响 实际的动画完成时间 = 持续时间/速度
//    speed:动画播放的速度 默认为1 速度设置成0 可以暂停动画 speed 2秒  duration 60秒 动画真正播放完成的时间 30秒
//    timeOffset:动画播放时间的偏移量
//    repeatCount:动画的循环次数  默认是0 只播放一次
//    repeatDuration:动画循环的持续时间  只能设置其中的一个属性 repeatCount/repeatDuration
//    autoreverses 是否以动画的形式 返回到播放之前的状态
//    fillMode{
//        kCAFillModeBackwards 立即进入动画的初始状态并等待动画开始
//        kCAFillModeBoth动画加入后开始之前layer处于动画初始状态动画结束后layer保持动画最后的状态
//        kCAFillModeRemoved 默认值 动画结束后 layer会恢复到之前的状态
//    }
//}

//CAPropertyAnimation{
//    keyPath
//    additive（该属性指定该属性动画是否以当前动画效果为基础。）
//    cumulative设置动画为累加效果（此属性默认为NO。）
//    valueFunction
//}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    kdeclare_weakself;
    NSArray *titles = @[@"指定点平移",@"路径平移",@"贝塞尔平移",@"自晃动",@"弹力仿真",@"测试"];
    for (unsigned int i = 0; i < titles.count; i++) {
        
        [UIButton easyCoder:^(UIButton *ins) {
            [weakSelf.view addSubview:ins];
            ins.backgroundColor = [UIColor brownColor];
            ins.tag = i;
            ins.frame = CGRectMake(10, 50 + 80 * i, 100, 60);
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
        case 0:[self toPointAnimation:nil];break;
        case 1:[self moveAnimation:nil];break;
        case 2:[self bezierAnimation:nil];break;
        case 3:[self shakeAnimation:nil];break;
        case 4:[self bounceAnimation:nil];break;
        case 5:[self animation];break;
        default:
            break;
    }
    
}


-(void)animation{
    
    //CAKeyframeAnimation
    
    /**
     *  实例化一个CA 动画对象,获取这个对象使用的key值为 你要操作的动画的方式，position表示位置，这个值是固定的，不可以随便写
     *  CALayer 没有rotation属性，所以它只可以通过transform 来创建
     */
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    /**
     * 设置动画时间，单次动画时间
     */
    [animation setDuration:5.0];
    /**
     * 设置重复次数
     */
    [animation setRepeatCount:1];
    
    /**
     *setRemovedOnCompletion 设置动画完成后是否将图层移除掉，默认是移除
     *setFillMode 当前设置的是向前填充，意味着动画完成后填充效果为最新的效果，此属性有效的前提是 setRemovedOnCompletion=NO
     *注意：
     *1.动画只是改变人的视觉，它并不会改变视图的初始位置等信息，也就是说无论动画怎么东，都不会改变view的原始大小，只是看起来像是大小改变了而已
     *2.因为没有改变视图的根本大小，所以视图所接收事件的位置还是原来的大小，可以不是显示的大小
     */
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    /**
     *设置时间函数CAMediaTimingFunction
     *kCAMediaTimingFunctionLinear 匀速
     *kCAMediaTimingFunctionEaseIn 开始速度慢，后来速度快
     *kCAMediaTimingFunctionEaseOut 开始速度快 后来速度慢
     *kCAMediaTimingFunctionEaseInEaseOut = kCAMediaTimingFunctionDefault 中间速度快，两头速度慢
     */
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    
    /**
     * 设置起始值
     */
    [animation setFromValue:@0.3];
    //[animation setFromValue:[UIColor redColor]];
    
    /**
     * 设置目标值
     */
    //[animation setByValue:@(0.5)];
    [animation setToValue:@90];
    //[animation setToValue:[UIColor redColor]];
    
    
    
    
    
    /**
     * 将动画添加到layer 添加到图层开始执行动画，
     * 注意：key值的设置与否会影响动画的效果
     * 如果不设置key值每次执行都会创建一个动画，然后创建的动画会叠加在图层上
     * 如果设置key值，系统执行这个动画时会先检查这个动画有没有被创建，如果没有的话就创建一个，如果有的话就重新从头开始执行这个动画
     * 你可以通过key值获取或者删除一个动画
     */
    [self.demoView.layer addAnimation:animation forKey:@"vvvvvvv"];
    
}


#pragma mark -- CAKeyframeAnimation - 指定点平移动画
-(void)toPointAnimation:(NSSet<UITouch *> *)touches{
    
    
    CGPoint point1 = CGPointMake(self.view.center.x, 100);
    CGPoint point2 = CGPointMake(self.view.center.x + 100, 200);
    CGPoint point3 = CGPointMake(self.view.center.x, 300);
    
    /**
     *  初始化动画对象
     */
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    /**
     *  设置关键帧的值
     */
    NSValue *p1 = [NSValue valueWithCGPoint:point1];
    NSValue *p2 = [NSValue valueWithCGPoint:point2];
    NSValue *p3 = [NSValue valueWithCGPoint:point3];
    [animation setValues:@[p1,p2,p3]];
    
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:3];
    animation.timeOffset = 1.5;
    animation.autoreverses = YES;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    /**
     *setRemovedOnCompletion 设置动画完成后是否将图层移除掉，默认是移除
     *setFillMode 当前设置的是向前填充，意味着动画完成后填充效果为最新的效果，此属性有效的前提是 setRemovedOnCompletion=NO
     *注意：
     *1.动画只是改变人的视觉，它并不会改变视图的初始位置等信息，也就是说无论动画怎么东，都不会改变view的原始大小，只是看起来像是大小改变了而已
     *2.因为没有改变视图的根本大小，所以视图所接收事件的位置还是原来的大小，可以不是显示的大小
     */
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeBoth];
    
    [self.demoView.layer addAnimation:animation forKey:nil];
}
#pragma mark -- CAKeyframeAnimation - 路径平移动画
-(void)moveAnimation:(NSSet<UITouch *> *)touches{
    
    /**
     *  初始化动画对象
     */
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    /**
     *  设置路径，按圆运动
     */
    CGMutablePathRef path = CGPathCreateMutable();//CG是C语言的框架，需要直接写语法
    CGPathAddEllipseInRect(path, NULL, CGRectMake(0, 0, 320, 320));
    [animation setPath:path];//把路径给动画
    CGPathRelease(path);//释放路径
    
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:3];
    
    /**
     *setRemovedOnCompletion 设置动画完成后是否将图层移除掉，默认是移除
     *setFillMode 当前设置的是向前填充，意味着动画完成后填充效果为最新的效果，此属性有效的前提是 setRemovedOnCompletion=NO
     *注意：
     *1.动画只是改变人的视觉，它并不会改变视图的初始位置等信息，也就是说无论动画怎么东，都不会改变view的原始大小，只是看起来像是大小改变了而已
     *2.因为没有改变视图的根本大小，所以视图所接收事件的位置还是原来的大小，可以不是显示的大小
     */
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    [self.demoView.layer addAnimation:animation forKey:nil];
    
}
#pragma mark -- CAKeyframeAnimation - 贝塞尔平移动画
-(void)bezierAnimation:(NSSet<UITouch *> *)touches{
    
    UITouch *touch = [touches anyObject];
    CGPoint  point = [touch locationInView:self.view];
    /**
     *  初始化动画对象
     */
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    /**
     *  设置路径，贝塞尔路径
     */
    //贝塞尔是OC语言的框架，需要直接写语法
    /**
     *  贝塞尔曲线的不同效果-01 矩形
     */
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 320)];
    
    /**
     *  贝塞尔曲线的不同效果-02 一个参照点-》抛物线
     */
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:self.demoView.center];
    [path2 addQuadCurveToPoint:CGPointMake(320 , 568) controlPoint:point];
    
    /**
     *  贝塞尔曲线的不同效果-03 一个参照点-》s形曲线
     */
    UIBezierPath *path3 = [UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointZero];
    [path3 addCurveToPoint:self.demoView.center controlPoint1:CGPointMake(320, 0) controlPoint2:CGPointMake(0, 568)];
    
    UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:self.view.center
                                                         radius:150
                                                     startAngle:- M_PI * 0.5
                                                       endAngle:M_PI * 2
                                                      clockwise:YES];
    

    [animation setPath:path4.CGPath];//animation需要的类型是CGPathRef，UIBezierPath是ui的  需要转化成CGPathRef
    
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:3];
    animation.rotationMode = kCAAnimationRotateAuto;
    /**
     *setRemovedOnCompletion 设置动画完成后是否将图层移除掉，默认是移除
     *setFillMode 当前设置的是向前填充，意味着动画完成后填充效果为最新的效果，此属性有效的前提是 setRemovedOnCompletion=NO
     *注意：
     *1.动画只是改变人的视觉，它并不会改变视图的初始位置等信息，也就是说无论动画怎么东，都不会改变view的原始大小，只是看起来像是大小改变了而已
     *2.因为没有改变视图的根本大小，所以视图所接收事件的位置还是原来的大小，可以不是显示的大小
     */
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    [self.demoView.layer addAnimation:animation forKey:nil];
}
#pragma mark -- CAKeyframeAnimation - 摇晃动画
-(void)shakeAnimation:(NSSet<UITouch *> *)touches{
    
    /**
     *  初始化动画对象
     */
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    /**
     *  设置路径，贝塞尔路径
     */
    CGFloat angle = M_PI_4 * 0.5;
    NSArray *values = @[@(angle),@(-angle),@(angle)];
    [animation setValues:values];
    [animation setRepeatCount:10];

    //CAAnimationGroup
    //CATransition
    
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:0.25];
    [self.demoView.layer addAnimation:animation forKey:nil];
}

#pragma mark -- CAKeyframeAnimation - 弹力仿真动画
-(void)bounceAnimation:(NSSet<UITouch *> *)touches{
    
    UITouch *touch = [touches anyObject];
    CGPoint  point = [touch locationInView:self.view];
    
    /**
     *  初始化动画对象
     */
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    /**
     *  弹的路径，目标应该在目标点来回弹动
     */
    
    CGFloat xlength = point.x - self.demoView.center.x;
    CGFloat ylength = point.y - self.demoView.center.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    
    //移动到目标点
    CGPathMoveToPoint(path, NULL, self.demoView.center.x, self.demoView.center.y);
    //将目标点的坐标添加到路径中
    CGPathAddLineToPoint(path, NULL, point.x, point.y);
    
    //设置弹力因子
    CGFloat offsetDivider = 4.0f;
    
    
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
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:0.3];
    
    /**
     *setRemovedOnCompletion 设置动画完成后是否将图层移除掉，默认是移除
     *setFillMode 当前设置的是向前填充，意味着动画完成后填充效果为最新的效果，此属性有效的前提是 setRemovedOnCompletion=NO
     *注意：
     *1.动画只是改变人的视觉，它并不会改变视图的初始位置等信息，也就是说无论动画怎么东，都不会改变view的原始大小，只是看起来像是大小改变了而已
     *2.因为没有改变视图的根本大小，所以视图所接收事件的位置还是原来的大小，可以不是显示的大小
     */
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    [self.demoView.layer addAnimation:animation forKey:nil];
}



- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"animation-start ======start:%@",NSStringFromCGRect(self.demoView.frame));
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"animation-start ======end:%@",NSStringFromCGRect(self.demoView.frame));
}


@end
