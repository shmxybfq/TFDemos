//
//  ViewController.m
//  demo-动画组
//
//  Created by 融数 on 16/11/23.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "ViewController.h"
#import "TFEasyCoder.h"
@interface ViewController ()

@property (nonatomic,strong)UIView *demoView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    kdeclare_weakself;
    NSArray *titles = @[@"动画组演示"];
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
    
    
    
    [UIImageView easyCoder:^(UIImageView *ins) {
        weakSelf.demoView = ins;
        
        [weakSelf.view addSubview:ins];
        ins.frame = CGRectMake(0, 0, 100, 100);
        ins.center = CGPointMake(weakSelf.view.center.x + 120, weakSelf.view.center.y - 120);
        ins.backgroundColor = [UIColor brownColor];
        ins.userInteractionEnabled = YES;
        ins.image = [UIImage imageNamed:@"dog.gif"];
        
        
    }];
}


-(void)animationBegin:(UIButton *)bt{
    [self groupAnimation:nil];


}


#pragma mark -- CAKeyframeAnimation - 指定点平移动画
-(void)groupAnimation:(NSSet<UITouch *> *)touches{
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    
    /**
     *  移动动画
     */
    CAKeyframeAnimation *position = [self moveAnimation:touches];
    /**
     *  摇晃动画
     */
    CAKeyframeAnimation *shake = [self shakeAnimation:touches];
    /**
     *  透明度动画
     */
    CABasicAnimation *alpha = [self alphaAnimation:touches];
    
    /**
     *  设置动画组的时间,这个时间表示动画组的总时间，它的子动画的时间和这个时间没有关系
     */
    [group setDuration:3.0];
    [group setAnimations:@[position,shake,alpha]];
    
    
    [self.demoView.layer addAnimation:group forKey:nil];
}

#pragma mark -- CAKeyframeAnimation - 路径平移动画
-(CAKeyframeAnimation *)moveAnimation:(NSSet<UITouch *> *)touches{
    
  
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
    
    return animation;
    
    
    
}

#pragma mark -- CAKeyframeAnimation - 摇晃动画
-(CAKeyframeAnimation *)shakeAnimation:(NSSet<UITouch *> *)touches{

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    /**
     *  设置路径，贝塞尔路径
     */
    CGFloat angle = M_PI_4 * 0.1;
    NSArray *values = @[@(angle),@(-angle),@(angle)];
    [animation setValues:values];
    [animation setRepeatCount:10];
    
    /**
     *  设置动画时间，这是动画总时间，不是每一帧的时间
     */
    [animation setDuration:0.25];
    return animation;
}

#pragma mark -- CABasicAnimation - 淡如淡出动画
-(CABasicAnimation *)alphaAnimation:(NSSet<UITouch *> *)touches{
    

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];

    [animation setDuration:1.0];
    /**
     * 设置重复次数
     */
    [animation setRepeatCount:3];
    /**
     * 设置自动翻转
     * 设置自动翻转以后单次动画时间不变，总动画时间延迟一倍，它会让你前半部分的动画以相反的方式动画过来
     * 比如说你设置执行一次动画，从a到b时间为1秒，设置自动翻转以后动画的执行方式为，先从a到b执行一秒，然后从b到a再执行一下动画结束
     */
    [animation setAutoreverses:YES];
    /**
     * 设置起始值
     */
    [animation setFromValue:@1.0];
    
    [animation setDelegate:self];
    
    /**
     * 设置目标值
     */
    [animation setToValue:@0.1];
    /**
     * 将动画添加到layer 添加到图层开始执行动画，
     * 注意：key值的设置与否会影响动画的效果
     * 如果不设置key值每次执行都会创建一个动画，然后创建的动画会叠加在图层上
     * 如果设置key值，系统执行这个动画时会先检查这个动画有没有被创建，如果没有的话就创建一个，如果有的话就重新从头开始执行这个动画
     * 你可以通过key值获取或者删除一个动画
     */
    return animation;
}

/**
 *  动画开始和动画结束时 self.demoView.center 是一直不变的，说明动画并没有改变视图本身的位置
 */
- (void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"动画开始------：%@",    NSStringFromCGPoint(self.demoView.center));
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"动画结束------：%@",    NSStringFromCGPoint(self.demoView.center));
}


@end
