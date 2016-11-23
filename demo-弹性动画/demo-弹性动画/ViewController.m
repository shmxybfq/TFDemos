//
//  ViewController.m
//  demo-弹性动画
//
//  Created by 融数 on 16/11/23.
//  Copyright © 2016年 融数. All rights reserved.
//

#import "ViewController.h"
#import "TFEasyCoder.h"
#import "UIView+ShakeAnimation.h"
@interface ViewController ()

@property (nonatomic,strong)UIImageView *demoView1;
@property (nonatomic,strong)UIImageView *demoView2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    kdeclare_weakself
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    
    NSArray *titles = @[@"Spring弹性动画",@"自定义弹性动画"];
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
        
    }];
    [UIImageView easyCoder:^(UIImageView *ins) {
        weakSelf.demoView2 = ins;
        
        [weakSelf.view addSubview:ins];
        ins.frame = CGRectMake(10, 300, 100, 100);
        ins.backgroundColor = [UIColor brownColor];
        ins.userInteractionEnabled = YES;
        
    }];
    
}

CATransform3D{
    rotation旋转
    transform.rotation.x
    transform.rotation.y
    transform.rotation.z

    scale缩放
    transform.scale.x
    transform.scale.y
    transform.scale.z

    translation平移
    transform.translation.x
    transform.translation.y
    transform.translation.z
}

CGPoint{
    position
    position.x
    position.y
}

CGRect{
    bounds
    bounds.size
    bounds.size.width
    bounds.size.height

    bounds.origin
    bounds.origin.x
    bounds.origin.y
}

property{
    opacity
    backgroundColor
    cornerRadius
    borderWidth
    contents
    
    Shadow{
        shadowColor
        shadowOffset
        shadowOpacity
        shadowRadius
    }
}


-(void)animationBegin:(UIButton *)btn{
    
    switch (btn.tag) {
        case 0:{
            CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
            
            spring.damping = 5;
            spring.stiffness = 100;
            spring.mass = 1;
            spring.initialVelocity = 0;
            spring.duration = spring.settlingDuration;
            spring.fromValue = @(self.demoView1.center.y);
            spring.toValue = @(self.demoView1.center.y + (btn.selected?+200:-200));
            spring.fillMode = kCAFillModeForwards;
            [self.demoView1.layer addAnimation:spring forKey:nil];
        }break;
        case 1:{
            CGRect framef;
            CGRect framet;
            if (btn.selected) {
                framef= CGRectMake(10, 300, 100, 100);
                framet= CGRectMake(10, 300, 300, 100);
                
            }else{
                
                framef= CGRectMake(10, 300, 300, 100);
                framet= CGRectMake(10, 300, 100, 100);
                
            }
            

[self.demoView2 startAnimationFromFrame:CGRectMake(10, 300, 100, 100)
                                toFrame:CGRectMake(10, 300, 300, 100)
                               duration:0.5
                             shakeTimes:5
                         stretchPercent:0.3
                             completion:^(BOOL finished) {
                                 NSLog(@"======over======:%@",self.demoView1);
                             }];
        }break;
        default:break;
    }
    
    btn.selected = !btn.selected;
    
    
}

@end
