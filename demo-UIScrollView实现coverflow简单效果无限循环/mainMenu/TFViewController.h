//
//  TFViewController.h
//  mainMenu
//
//  Created by Hyacinth on 14-10-20.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TFMenuVI.h"
#import "TFCirculationSV.h"

@interface TFViewController : UIViewController<TFCirculationSVDelegate>
@property (nonatomic,retain)TFCirculationSV *circulationSV;
@property (nonatomic,retain)NSMutableArray *menusArr;
@end
