//
//  ViewController.m
//  Demo-粒子动画
//
//  Created by ztf on 16/12/5.
//  Copyright © 2016年 ztf. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


//http://www.jianshu.com/p/d3e57f6c2312 CAEmitterLayer(粒子系统)



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    CAEmitterLayer *layer = [self emitterLayer];
    [self.view.layer addSublayer:layer];
    
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    view.backgroundColor = [UIColor redColor];
    view.center = self.view.center;
    [self.view addSubview:view];

}


- (CAEmitterLayer *)emitterLayer
{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    //发射器发射点的位置
    emitterLayer.emitterPosition = self.view.center;
    //发射源的大小,emitterMode= kCAEmitterLayerPoints看不出效果,因为发射源是一个点
    emitterLayer.emitterSize = CGSizeMake(20, 20);
    //每秒粒子生成的数量,默认1,总数 = birthRate * emitterCells.count
    emitterLayer.birthRate = 1;
    //粒子运动的速度,默认1.0
    emitterLayer.velocity = 0.5;
    //粒子的缩放比例,默认1.0
    emitterLayer.scale = 1.0;
    //粒子的存活时间系数,为1时和粒子cell本身的时间相同,默认是1
    emitterLayer.lifetime = 1;
    //有待详解
    //emitterLayer.spin = 1.0;
    //有待详解
    //emitterLayer.seed = 50;
    //有待详解
    //emitterLayer.emitterZPosition = 0.5;
    //有待详解
    //emitterLayer.preservesDepth = YES;
    
    //渲染模式
    //kCAEmitterLayerOldestFirst//这种模式下,声明久的粒子会被渲染在最上层
    //kCAEmitterLayerOldestLast//这种模式下,年轻的粒子会被渲染在最上层
    //kCAEmitterLayerBackToFront//这种模式下,粒子的渲染按照Z轴的前后顺序进行
    //kCAEmitterLayerAdditive//叠加
    //kCAEmitterLayerUnordered//这种模式下,粒子层次是无序出现的,多个发射源将混合
    emitterLayer.renderMode = kCAEmitterLayerAdditive;
   
    
    //发射源形状,默认:kCAEmitterLayerPoint
    //kCAEmitterLayerPoint////点的形状，粒子从一个点发出
    //kCAEmitterLayerLine //线的形状，粒子从一条线发出
    //kCAEmitterLayerRectangle //矩形形状，粒子从一个矩形中发出,矩形有四条边
    //kCAEmitterLayerCuboid //立方体形状，会影响Z平面的效果
    //kCAEmitterLayerCircle //圆形，粒子会在圆形范围发射
    //kCAEmitterLayerSphere //3D球
    emitterLayer.emitterShape = kCAEmitterLayerPoint;
    
    //发射源发射点位置,默认:kCAEmitterLayerVolume
    //kCAEmitterLayerPoints////从发射器中发出顶点发出
    //kCAEmitterLayerOutline//从发射器边缘发出
    //kCAEmitterLayerSurface//从发射器表面发出
    //kCAEmitterLayerVolume//从发射器中点发出.容积,即3D图形的体积内
    emitterLayer.emitterMode = kCAEmitterLayerOutline;
    
    //创建粒子cell数组,为什么要创建数组?用一个粒子提高它的产生速度不是一样的吗?原因:创建多个粒子cell的目的是让粒子产生的有多样性
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i<10; i++) {
        //单个粒子
        CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
        //粒子的子粒子,好牛逼的属性
        //stepCell.emitterCells = @[];
        //例子的名字
        stepCell.name = [NSString stringWithFormat:@"good%@_30x30_@2x",@(i)];
        //粒子是否被渲染
        stepCell.enabled = YES;
        //粒子的创建速率,默认:1/s
        stepCell.birthRate = 3;
        //缩放比例
        stepCell.scale = .3;
        //缩放容差 scale +- scaleRange;
        stepCell.scaleRange = 0.15;
        //有待详解,测试的是这个值不能大于1
        //stepCell.scaleSpeed = 0.01;
        //旋转角度
        stepCell.spin = M_PI;
        //旋转容差
        stepCell.spinRange = M_PI / 4.0;
        
        //粒子存活时间,单位秒,它和CAEmitterLayer的lifetime单位是不一样的,CAEmitterLayer的单位是倍数
        stepCell.lifetime = arc4random_uniform(5) + 2;
        //粒子的生存时间容差,配上lifetime的随机数不至于显示效果是一起产生一起消失
        stepCell.lifetimeRange = 2.0;
        //粒子颜色,它是把contents渲染成什么颜色包括透明度,color的优先级要比contents高
        stepCell.color = [UIColor colorWithRed:arc4random_uniform(255)/255.0
                                          green:arc4random_uniform(255)/255.0
                                           blue:arc4random_uniform(255)/255.0
                                          alpha:0.8].CGColor;
        //颜色相关,不具体一个一个试了,都是一个意思
        //stepCell.redRange = 0.3;
        //stepCell.greenRange = 0.3;
        //stepCell.blueRange = 0.3;
        //stepCell.alphaRange = 0.3;
        //stepCell.redSpeed = 0.1;
        //stepCell.greenSpeed = 0.1;
        //stepCell.blueSpeed = 0.1;
        //stepCell.alphaSpeed = 0.1;
 
        //粒子显示的内容,是个CGImageRef的对象
        stepCell.contents = (__bridge id)[[UIImage imageNamed:stepCell.name] CGImage];
        //应该画在contents里的子矩形,默认和粒子一样大
        //stepCell.contentsRect;
        //粒子显示的内容缩放
        //stepCell.contentsScale = 0.5;
        
        //minificationFilter 和 magnificationFilter
        //这两个属性主要是设置layer的contents数据缩放拉伸时的描绘方式,minificationFilter用于缩小,magnificationFilter用于放大
        //kCAFilterLinear//默认值,缩放平滑,但容易产生模糊效果
        //kCAFilterTrilinear//基本和kCAFilterLinear相同
        //kCAFilterNearest//速度快不会产生模糊,但会降低质量并像素化图像
        //stepCell.minificationFilter = kCAFilterLinear;
        //stepCell.magnificationFilter = kCAFilterLinear;
        //减小减大的因子
        stepCell.minificationFilterBias = 1.0;
        
        // 粒子的运动速度,如果设成0,速度会很慢,具体这个是什么算法不知道,总之它是一个float值,看着感觉设就好了
        stepCell.velocity = arc4random_uniform(100) + 100;;
        //粒子速度的容差,也就是velocity +- velocityRange
        //如果 velocityRange太大的话就有可能 velocity - velocityRange为负值,这样发射方向就反了
        stepCell.velocityRange = 100;
        //粒子在xy平面的发射角度,默认值是三点钟方向,它和emissionLatitude的区别是什么?
        stepCell.emissionLongitude = M_PI + M_PI_2;
        //粒子发射角度的容差在,emissionLongitude的基础上扩展成一个弧形可以
        stepCell.emissionRange = M_PI_2 / 4;
        //发射的z轴方向的角度,默认0,M_PI_2会箭头朝屏幕里垂直屏幕发射
        stepCell.emissionLatitude = 0;
        //xyz轴上的加速度,用这三个属性可以做一个礼花弹爆炸的动画
        stepCell.xAcceleration = 1.0;
        stepCell.yAcceleration = 1.0;
        stepCell.zAcceleration = 1.0;
        [array addObject:stepCell];
    }
    
    emitterLayer.emitterCells = array;
    return emitterLayer;
}


@end
