//
//  FormCell.h
//  表格
//
//  Created by ztf on 15/12/2.
//  Copyright © 2015年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Completion)(BOOL finished);

@interface FormCell : UIView

@property (nonatomic,strong)UILabel *leftLB;
@property (nonatomic,assign)CGRect   animationRect;

-(void)startAnimationToPercent:(CGFloat)toPercent durition:(NSTimeInterval)durition completion:(Completion)completion;


@end
