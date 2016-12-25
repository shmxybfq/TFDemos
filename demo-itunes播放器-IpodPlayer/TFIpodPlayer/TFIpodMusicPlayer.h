//
//  TFIpodMusicPlayer.h
//  TFIpodPlayer
//
//  Created by Hyacinth on 14/10/29.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//
//
//  需要导入的框架:AVFoundation.framework/MediaPlayer.framework
//  后台播放需要设置plist:
//  plist添加一项Required background modes (array)
//  Required background modes的itme0 (string)设置为
//  (App plays audio or streams audio/video using AirPlay)
//
//  退出应用时需关闭ipod播放器 ，具体看appdelegate
//
//
//
//
//
//
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


#define TFIpodMusicPlayerState @"TFIpodMusicPlayerState"
#define tfkTFIpodMusicPlayerProgressTimer @"tfkTFIpodMusicPlayerProgressTimer"


//tf- 播放器类型
typedef NS_ENUM(NSInteger, MusicPlayerType) {
    IPodMusicPlayer = 0,
    ApplicationMusicPlayer ,
};



@interface TFIpodMusicPlayer : UIViewController
{
    //tf- 进度定时器，正在播放时每秒发送进度
    NSTimer *_progressTimer;
}


//tf- 播放器
@property(nonatomic, retain)MPMusicPlayerController *player;
//tf- 音乐条目集合
@property(nonatomic, retain)MPMediaItemCollection   *mediaItemCollection;
//tf- 音乐
@property(nonatomic, retain)MPMediaItem   *mediaItem;
//tf- 所有音乐列表
@property(nonatomic, retain)NSMutableArray   *mediaItemList;
//tf- 播放器类型
@property(nonatomic, assign)MusicPlayerType      playerType;
//tf- 总时间
@property(nonatomic, assign)float totalTime;
//tf- 当前时间
@property(nonatomic, assign)float currentTime;
//tf- 专辑图
@property(nonatomic, retain)UIImage *songImage;
//tf- 歌名
@property(nonatomic, retain)NSString *songTitle;
//tf- 是否正在播放
@property(nonatomic, assign)BOOL  isPlay;


+(id)getInstance;

//初始化
-(void)setPlayerType:(MusicPlayerType)playerType SongList:(NSArray *)list;
//设置播放器类型
- (void)setPlayerType:(MusicPlayerType)playerType;
//刷新列表
- (void)reloadSongList:(NSArray *)list;
//按坐标播放
-(void)playWithIndex:(NSInteger )index;
//按歌名播放
-(void)playWithName:(NSString *)name;
//播放
- (void)play;
//暂停
- (void)pause;
//停止
- (void)stop;
//设置进度
- (void)setProgress:(float)progress;
//上一首
- (void)previousSong;
//下一首
- (void)nextSong;
//清空列表
- (void)clearSongList;




#pragma mark -------- 歌曲专辑图片
-(UIImage *)songImage;
#pragma mark -------- 歌名
-(NSString *)songTitle;
#pragma mark -------- 歌名
-(NSString *)songArtist;





@end
