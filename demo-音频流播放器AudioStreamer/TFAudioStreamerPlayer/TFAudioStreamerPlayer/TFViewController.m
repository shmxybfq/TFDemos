//
//  TFViewController.m
//  TFAudioStreamerPlayer
//
//  Created by Hyacinth on 14/10/29.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFViewController.h"

@interface TFViewController (){

    
    UILabel *_title;
    UILabel *_artist;
    UILabel *_duration;
}
@end

@implementation TFViewController


//注册锁屏控制
-(void)registReceivingRemoteControlEvents:(BOOL)ifReceive
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    if (ifReceive) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
}


#pragma mark --------------锁屏状态点击屏幕播放控制按钮
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSLog(@"------event:%@--type:%d",event,event.subtype);
    if (event.type == UIEventTypeRemoteControl) {
        

        
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:{
                NSLog(@"------------锁屏：切换播放");
                TFAudioStreamerPlayer *player = [TFAudioStreamerPlayer getInstance];
                [player play];
            }break;
            case UIEventSubtypeRemoteControlPause:{
                NSLog(@"------------锁屏：切换暂停按钮");
                TFAudioStreamerPlayer *player = [TFAudioStreamerPlayer getInstance];
                [player pause];
            }break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"------------锁屏：播放上一曲按钮");
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"------------锁屏：播放下一曲按钮");
                break;
            default:
                break;
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    http://music.vcyber.cn:8080/ylxt-music/64K/64K/All Night.mp3
    
    _title = [self creatLabelWithFrame:CGRectMake(0, 100, 320, 30)];
    [self.view addSubview:_title];
    _artist = [self creatLabelWithFrame:CGRectMake(0, 130, 320, 30)];
    [self.view addSubview:_artist];
    _duration = [self creatLabelWithFrame:CGRectMake(0, 160, 320, 30)];
    [self.view addSubview:_duration];
    
    
    TFAudioStreamerPlayer *player = [TFAudioStreamerPlayer getInstance];
    [player playWithUrlStr:@"http://music.vcyber.cn:8080/ylxt-music/64K/64K/A Little More Time.mp3"];
    [self registReceivingRemoteControlEvents:YES];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _title.text =@"http://music.vcyber.cn:8080/ylxt-music/64K/64K/A Little More Time.mp3";
        _artist.text =@"艺术家";
        _duration.text =[NSString stringWithFormat:@"%f",player.streamer.duration];
    });

    
    //设置锁屏显示的歌名和图片
    [self setLockScreenMusicInfo:@{@"title":@"控制",
                                   @"artist":@"艺术家",
                                   @"image":[UIImage imageNamed:@"sygy-9401359568.jpg"]}];
    
    
}


#pragma mark --------------设置锁屏字幕和图片
-(void)setLockScreenMusicInfo:(NSDictionary *)info
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[info objectForKey:@"title"] forKey:MPMediaItemPropertyTitle];
    [dict setObject:[info objectForKey:@"artist"] forKey:MPMediaItemPropertyArtist];
    [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[info objectForKey:@"image"]]
             forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    
}


-(UILabel *)creatLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.backgroundColor = [UIColor yellowColor];
    return label;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
