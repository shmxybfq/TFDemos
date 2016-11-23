//
//  UIView+ShakeAnimation.h
//  animationTest
//
//  Created by ztf on 15/12/21.
//  Copyright © 2015年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ShakeAnimation)

-(void)startAnimationFromFrame:(CGRect)framef
                       toFrame:(CGRect)framet
                      duration:(CGFloat)duration
                    shakeTimes:(NSInteger)times
                stretchPercent:(CGFloat)stretchPercent
                    completion:(void (^)(BOOL finished))completion;
@end
