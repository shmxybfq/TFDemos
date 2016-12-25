//
//  ShowImageView.h
//  UICollectionView03
//
//  Created by zhutaofeng on 15/4/29.
//  Copyright (c) 2015年 Hyacinth.TaskTinkle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageView : UIView

@property (nonatomic,assign)CGRect oldFrame;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tap;

@end
