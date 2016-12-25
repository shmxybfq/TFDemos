//
//  CollectionViewCell.m
//  UICollectionView01
//
//  Created by zhutaofeng on 15/4/20.
//  Copyright (c) 2015年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.imageView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.imageView.layer.borderWidth = 2;
//    self.imageView.layer.cornerRadius = 5;
//    self.imageView.layer.masksToBounds = YES;
    self.imageView.alpha = 1.0;

}


-(void)setCellData:(NSString *)data
{
    self.imageView.image = [UIImage imageNamed:data];
}

@end
