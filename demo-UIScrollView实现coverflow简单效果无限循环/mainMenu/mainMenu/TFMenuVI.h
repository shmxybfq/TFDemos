//
//  TFMenuVI.h
//  VoiceLink
//
//  Created by Hyacinth on 14-9-23.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#define tfkMainViewScale @"tfkMainViewScale"

@interface TFMenuVI : UIView

@property (nonatomic,assign)NSInteger index;
@property (nonatomic,  copy)NSString *name;
@property (nonatomic,  copy)NSString *imageStr;
@property (nonatomic,retain)UIButton *mainBT;

@property (nonatomic,assign)CGPoint ofSet;

@end
