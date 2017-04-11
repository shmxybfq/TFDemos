//
//  CircleLayer.h
//  demo-复杂动画效果
//
//  Created by 融数 on 16/11/24.
//  Copyright © 2016年 融数. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CircleLayer : CAShapeLayer


UIKIT_EXTERN const CGFloat AnimationTime;

//缩放动画
-(CGFloat)scaleAnimation:(BOOL)toBig;
//挤压动画
-(CGFloat)extrusionAnimation;


@end
