//
//  TFAudioStreamerPlayer.h
//  VoiceLink
//
//  Created by Hyacinth on 14-10-11.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//  需要导入的框架:CFNetwork.framework/AudioToolbox.framework/MediaPlayer.framework
//  后台播放需要设置plist:
//  plist添加一项Required background modes (array)
//  Required background modes的itme0 (string)设置为
//  (App plays audio or streams audio/video using AirPlay)
//
//  后台播放还需要设置appdelegate



#import <Foundation/Foundation.h>
#import "AudioStreamer.h"

//播放进度变化(只有正在播放的时候才会发送)
#define tfkTFAudioStreamerPlayerProgressTimer @"tfkTFAudioStreamerPlayerProgressTimer"


@interface TFAudioStreamerPlayer : UIView
{
    
    NSTimer *_progressTimer;//进度定时器，正在播放状态时每秒发一次
}

//流播放器
@property (nonatomic,retain)AudioStreamer *streamer;
//当前播放地址
@property (nonatomic,  copy)NSString *urlStr;
//当前音乐title
@property (nonatomic,  copy)NSString *title;
//艺术家
@property (nonatomic,  copy)NSString *artist;
//专辑图
@property (nonatomic,retain)UIImage  *artistImage;


@property (nonatomic,retain)NSMutableArray *songMDs;
@property (nonatomic,assign)NSInteger curIndex;
@property (nonatomic,  copy)NSString *songsAlbumName;

+(id)getInstance;


#pragma mark -------- zz- 播放流通过url
-(void)playWithUrlStr:(NSString *)urlStr;
#pragma mark -------- zz- 销毁流
-(void)destroyStreamer;
#pragma mark ---------- zz- 播放
- (void)play;
#pragma mark ---------- zz- 暂停
- (void)pause;
#pragma mark ---------- zz- 停止
- (void)stop;
#pragma mark ---------- zz- 设置进度
- (void)setProgress:(float)progress;


@end
