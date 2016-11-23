//
//  ViewController.m
//  demo-转场动画
//
//  Created by 融数 on 16/11/16.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "ViewController.h"
#import "TFEasyCoder.h"
@interface ViewController ()

@property (nonatomic,strong)UIImageView *demoView1;
@property (nonatomic,strong)UIImageView *demoView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kdeclare_weakself
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    NSArray *titles = @[@"单视图转场",@"双视图转场",@"CATransition转场"];
    for (unsigned int i = 0; i < titles.count; i++) {
        
        [UIButton easyCoder:^(UIButton *ins) {
            [weakSelf.view addSubview:ins];
            ins.backgroundColor = [UIColor brownColor];
            ins.tag = i;
            ins.frame = CGRectMake(10, 50 + 80 * i, 100, 60);
            ins.titleLabel.adjustsFontSizeToFitWidth = YES;
            [ins setTitle:titles[i] forState:UIControlStateNormal];
            [ins addTarget:self action:@selector(animationBegin:) forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    
    [UIImageView easyCoder:^(UIImageView *ins) {
        weakSelf.demoView1 = ins;
        
        [weakSelf.view addSubview:ins];
        ins.frame = CGRectMake(0, 0, 100, 100);
        ins.center = CGPointMake(weakSelf.view.center.x + 120, weakSelf.view.center.y - 120);
        ins.backgroundColor = [UIColor brownColor];
        ins.userInteractionEnabled = YES;
        ins.image = [UIImage imageNamed:@"dog.gif"];
        
     
    }];

    
    
    [UIImageView easyCoder:^(UIImageView *ins) {
        weakSelf.demoView2 = ins;
        
        [weakSelf.view addSubview:ins];
        ins.frame = CGRectMake(0, 0, 100, 100);
        ins.center = CGPointMake(weakSelf.view.center.x + 120, weakSelf.view.center.y + 120);
        ins.backgroundColor = [UIColor greenColor];
        ins.userInteractionEnabled = YES;
        ins.image = [UIImage imageNamed:@"dog.gif"];
    }];
 
    
}


-(void)animationBegin:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:[self animationSingleView:YES]; break;
        case 1:[self animationSingleView:NO]; break;
        case 2:[self chang3]; break;
        default:break;
    }
}

/**
 *  转场动画在执行过程中不可以被停止，
 *  转场动画在执行过程中不可以用户交互
 *  转场动画在执行过程中不可以控制动画执行进度
 */
/**
 *  基于UIView的单视图转场动画
 */
static NSUInteger change1_0Index = 0;
static NSUInteger change1_1Index = 0;
static NSUInteger change1_2Index = 0;

-(void)animationSingleView:(BOOL)sigle
{

    
    /**
     *  第一部分
     */
    NSArray *array0 = @[
                        @(UIViewAnimationOptionTransitionNone),
                        @(UIViewAnimationOptionTransitionFlipFromLeft),//从左水平翻转
                        @(UIViewAnimationOptionTransitionFlipFromRight),//从右水平翻转
                        @(UIViewAnimationOptionTransitionCurlUp),//翻书上掀
                        @(UIViewAnimationOptionTransitionCurlDown),//翻书下盖
                        @(UIViewAnimationOptionTransitionCrossDissolve),//融合
                        @(UIViewAnimationOptionTransitionFlipFromTop),//从上垂直翻转
                        @(UIViewAnimationOptionTransitionFlipFromBottom),//从下垂直翻转
                        ];
    
    /**
     *  第二部分
     */
    NSArray *array1 = @[
                        @(UIViewAnimationOptionCurveEaseInOut),////开始慢，加速到中间，然后减慢到结束
                        @(UIViewAnimationOptionCurveEaseIn),//开始慢，加速到结束
                        @(UIViewAnimationOptionCurveEaseOut),//开始快，减速到结束
                        @(UIViewAnimationOptionCurveLinear),//线性运动
                        ];
    
    /**
     *  第三部分
     */
    NSArray *array2 = @[
                        @(UIViewAnimationOptionLayoutSubviews),//默认，跟父类作为一个整体
                        @(UIViewAnimationOptionAllowUserInteraction),//设置了这个，主线程可以接收点击事件
                        @(UIViewAnimationOptionBeginFromCurrentState),//从当前状态开始动画，父层动画运动期间，开始子层动画。
                        @(UIViewAnimationOptionRepeat),//重复执行动画，从开始到结束， 结束后直接跳到开始态
                        @(UIViewAnimationOptionAutoreverse),//反向执行动画，结束后会再从结束态->开始态
                        @(UIViewAnimationOptionOverrideInheritedDuration),//忽略继承自父层持续时间，使用自己持续时间（如果存在）
                        @(UIViewAnimationOptionOverrideInheritedCurve),//忽略继承自父层的线性效果，使用自己的线性效果（如果存在）
                        @(UIViewAnimationOptionAllowAnimatedContent),//允许同一个view的多个动画同时进行
                        @(UIViewAnimationOptionShowHideTransitionViews),//视图切换时直接隐藏旧视图、显示新视图，而不是将旧视图从父视图移除（仅仅适用于转场动画）
                        @(UIViewAnimationOptionOverrideInheritedOptions),//不继承父动画设置或动画类型。
                        ];
    
//    CASpringAnimation
//    CASpringAnimation
    
    
    if (sigle) {
        
        [UIView transitionWithView:self.demoView1
                          duration:1
                           options:
         ((NSNumber *)array0[change1_0Index]).integerValue|
         ((NSNumber *)array1[change1_1Index]).integerValue|
         ((NSNumber *)array2[change1_2Index]).integerValue
                        animations:^{
                            
                            
                            
                            /**
                             *  单视图的转场动画需要在动画块中设置视图转场前的内容和视图转场后的内容
                             */
                            if (self.demoView1.tag == 0) {
                                self.demoView1.image = [UIImage imageNamed:@"1466346770878893.gif"];
                                self.demoView1.tag = 1;
                            }else{
                                self.demoView1.image = [UIImage imageNamed:@"dog.gif"];
                                self.demoView1.tag = 0;
                            }
                            
                            
                            
                            
                        } completion:nil];
        NSLog(@"动画:%s:%@:%@:%@",__func__,@(change1_0Index),@(change1_1Index),@(change1_2Index));
        

    }else{
    
        /**
         *  双视图的转场动画
         *  注意：双视图的转场动画实际上是操作视图移除和添加到父视图的一个过程，from视图必须要有父视图，to视图必须不能有父视图，否则会出问题
         *  比如动画不准等
         */
        
        UIImageView *fromView = nil;
        UIImageView *toView = nil;
        
        if (self.demoView1.tag == 0) {
            fromView = self.demoView1;
            toView = self.demoView2;
            self.demoView1.tag = 1;
        }else{
            fromView = self.demoView2;
            toView = self.demoView1;
            self.demoView1.tag = 0;
        }
        
        [UIView transitionFromView:fromView
                            toView:toView duration:1.0
                           options:
         ((NSNumber *)array0[change1_0Index]).integerValue|
         ((NSNumber *)array1[change1_1Index]).integerValue|
         ((NSNumber *)array2[change1_2Index]).integerValue
                        completion:^(BOOL finished) {
                            
                        }];
        
        
    }
        change1_0Index += 1;
    if (change1_0Index > array0.count - 1) {
        change1_0Index = 0;
        change1_1Index += 1;
    }
    if (change1_1Index > array1.count - 1) {
        change1_1Index = 0;
        change1_2Index += 1;
    }
    if (change1_2Index > array2.count - 1) {
        change1_2Index = 0;
        
        change1_0Index = 0;
        change1_2Index = 0;
        
    }
}



/**
 *  基于CATransition的视图转场动画
 */
static NSUInteger change3_0Index = 0;
static NSUInteger change3_1Index = 0;
-(void)chang3{
    
    /**
     *创建转场动画：注意：CATransaction和CATransition 不一样
     */
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.25;
    
    NSArray *type_array = @[
                        //系统提供的动画
                       kCATransitionFade,
                       kCATransitionMoveIn,
                       kCATransitionPush,
                       kCATransitionReveal,
                       
                       //以下是私有api,只能字符串访问
                       @"cube",//立方体翻转效果
                       @"oglFlip",//翻转效果
                       @"suckEffect",//收缩效果,动画方向不可控
                       @"rippleEffect",//水滴波纹效果,动画方向不可控
                       @"pageCurl",//向上翻页效果
                       @"pageUnCurl",//向下翻页效果
                       @"cameralIrisHollowOpen",//摄像头打开效果,动画方向不可控
                       @"cameraIrisHollowClose",//摄像头关闭效果,动画方向不可控
                       ];
    //转场类型
    transition.type = type_array[change3_0Index];

    NSArray *subtype_array = @[
                            kCATransitionFromRight,
                            kCATransitionFromLeft,
                            kCATransitionFromTop,
                            kCATransitionFromBottom
                            ];
    //转场方向
    transition.subtype = subtype_array[change3_1Index];

    /**
     *  设置转场动画的开始和结束百分比
     */
    transition.startProgress = 0.0;
    transition.endProgress = 1.0;
    
    
    if (self.demoView1.tag == 0) {
        self.demoView1.tag = 1;
        
        
        self.demoView1.image = [UIImage imageNamed:@"1466346770878893.gif"];
        self.demoView2.image = [UIImage imageNamed:@"1466346770878893.gif"];
    }else{
        self.demoView1.tag = 0;
        
        self.demoView1.image = [UIImage imageNamed:@"dog.gif"];
        self.demoView2.image = [UIImage imageNamed:@"dog.gif"];
    }
    [self.demoView1.layer addAnimation:transition forKey:nil];
    [self.demoView2.layer addAnimation:transition forKey:nil];

    NSLog(@"动画:%s:%@:%@",__func__,@(change3_0Index),@(change3_1Index));
    
    change3_1Index += 1;
    if (change3_1Index > subtype_array.count - 1) {
        change3_1Index = 0;
        change3_0Index += 1;
    }
    if (change3_0Index > type_array.count - 1) {
        change3_0Index = 0;
    }
    
}
@end
