//
//  TFViewController.m
//  TFIpodPlayer
//
//  Created by Hyacinth on 14/10/29.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFViewController.h"

@interface TFViewController ()
{
    UILabel *_title;
    UILabel *_artist;
    UILabel *_duration;
}
@end

@implementation TFViewController



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
    if (event.type == UIEventTypeRemoteControl) {
        
        
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:{
                NSLog(@"------------锁屏：切换播放");
                TFIpodMusicPlayer * player = [TFIpodMusicPlayer getInstance];
                [player play];
            }break;
            case UIEventSubtypeRemoteControlPause:{
                NSLog(@"------------锁屏：切换暂停按钮");
                TFIpodMusicPlayer * player = [TFIpodMusicPlayer getInstance];
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
    self.view.backgroundColor = [UIColor grayColor];
    
    _title = [self creatLabelWithFrame:CGRectMake(0, 100, 320, 30)];
    [self.view addSubview:_title];
    _artist = [self creatLabelWithFrame:CGRectMake(0, 130, 320, 30)];
    [self.view addSubview:_artist];
    _duration = [self creatLabelWithFrame:CGRectMake(0, 160, 320, 30)];
    [self.view addSubview:_duration];
    
    
    
    MPMediaQuery *listQuery = [MPMediaQuery playlistsQuery];
    NSArray *items = [listQuery items];
    if (items.count!=0) {
        TFIpodMusicPlayer * player = [TFIpodMusicPlayer getInstance];
        if (player.mediaItemList.count == 0) {
            [player setPlayerType:IPodMusicPlayer SongList:items];
        }
        
        
        MPMediaItem *item = [items objectAtIndex:0];
        NSString *title =[item valueForProperty:MPMediaItemPropertyTitle];
        NSString *artist =[item valueForProperty:MPMediaItemPropertyArtist];
        NSString *duration = [NSString stringWithFormat:@"%@",[item valueForKey:MPMediaItemPropertyPlaybackDuration]];

        [player playWithName:title];

        _title.text =title;
        _artist.text =artist;
        _duration.text =duration;
        
        
        [self registReceivingRemoteControlEvents:YES];
        //设置锁屏显示的歌名和图片
        [self setLockScreenMusicInfo:@{@"title":title,
                                       @"artist":artist,
                                       @"image":[UIImage imageNamed:@"sygy-9401359568.jpg"]}];
        
    }else{
        _title.text =@"音乐为空";
        _artist.text =@"";
        _duration.text =@"";
    
    }
    
    
    
    

    
}

-(UILabel *)creatLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.backgroundColor = [UIColor yellowColor];
    return label;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
