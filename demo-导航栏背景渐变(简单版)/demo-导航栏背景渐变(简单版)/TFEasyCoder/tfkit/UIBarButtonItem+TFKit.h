//
//  UIBarButtonItem+TFKit.h
//  TFEasyCoderDemo
//
//  Created by ztf on 16/12/15.
//  Copyright © 2016年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TFKit)

+ (UIBarButtonItem *)itemWithImage:(NSString *)normalImage
                   higlightedImage:(NSString *)higlightedImage
                            target:(id)target
                            action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemTitle:(NSString *)title
                         withTitleColor:(UIColor *)titleColor
                               withFont:(int)fontSize
                             withTarget:(id)target
                           withSelector:(SEL)selector
                          withAlignMent:(NSTextAlignment)alignment;

@end
