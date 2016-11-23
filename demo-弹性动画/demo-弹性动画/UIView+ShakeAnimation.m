//
//  UIView+ShakeAnimation.m
//  animationTest
//
//  Created by ztf on 15/12/21.
//  Copyright © 2015年 ztf. All rights reserved.
//

#import "UIView+ShakeAnimation.h"
#import <objc/runtime.h>
typedef void (^RunAnimationBlock)();
@interface UIView ()
@property (nonatomic,  copy)RunAnimationBlock block;
@end

@implementation UIView (ShakeAnimation)

-(void)startAnimationFromFrame:(CGRect)framef
                       toFrame:(CGRect)framet
                      duration:(CGFloat)duration
                    shakeTimes:(NSInteger)times
                stretchPercent:(CGFloat)stretchPercent
                    completion:(void (^)(BOOL finished))completion
{
    self.layer.masksToBounds = YES;
    
    __block CGFloat perTime = duration / times;
    __block CGFloat perx = (framet.origin.x - framef.origin.x) * stretchPercent / times;
    __block CGFloat pery = (framet.origin.y - framef.origin.y) * stretchPercent / times;
    __block CGFloat perw = (framet.size.width - framef.size.width) * stretchPercent / times;
    __block CGFloat perh = (framet.size.height - framef.size.height) * stretchPercent / times;
    
    __block UIView * tmpView = self;
    __block NSInteger tmpTimes = (NSInteger)times;
    __block NSInteger tmpsymbol = -1;

    __weak typeof(self) weakSelf = self;
    self.block = ^{
        
        [UIView animateWithDuration:perTime animations:^{
            
            CGFloat x = framet.origin.x + perx * tmpTimes;
            CGFloat y = framet.origin.y + pery * tmpTimes;
            CGFloat w = framet.size.width + perw * tmpTimes;
            CGFloat h = framet.size.height + perh * tmpTimes;
            CGRect rect = CGRectMake(x, y, w, h);
            
            tmpView.frame = rect;
        }completion:^(BOOL finished) {
            
            tmpTimes = tmpTimes + tmpsymbol;
            tmpTimes = - tmpTimes;
            tmpsymbol = - tmpsymbol;
            if (tmpTimes != 0) {
                weakSelf.block();
            }else{
                [UIView animateWithDuration:perTime animations:^{
                    tmpView.frame = framet;
                }completion:^(BOOL finished) {
                    completion(YES);
                }];
            }
        }];
    };
    
    self.block();
}


static char RunAnimationBlockKey;
-(RunAnimationBlock)block{
    return objc_getAssociatedObject(self, &RunAnimationBlockKey);
}
-(void)setBlock:(RunAnimationBlock)block{
    objc_setAssociatedObject(self, &RunAnimationBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
