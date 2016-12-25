//
//  TFIpodMusicPlayer.m
//  TFIpodPlayer
//
//  Created by Hyacinth on 14/10/29.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFIpodMusicPlayer.h"


#define tfIfLog YES
#define MPLog(A) NSLog(@"----------%@---------%@",NSStringFromClass([self class]),A)


@interface TFIpodMusicPlayer ()

@end

@implementation TFIpodMusicPlayer



@synthesize player = _player;
@synthesize mediaItemCollection = _mediaItemCollection;
@synthesize playerType = _playerType;


@synthesize isPlay = _isPlay;
@synthesize totalTime = _totalTime;
@synthesize currentTime =_currentTime;
@synthesize songImage = _songImage;
@synthesize mediaItemList = _mediaItemList;


- (void)dealloc
{
    [self stop];
    [self runTimer:NO];
    [self configurationNSNotification:NO];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


static TFIpodMusicPlayer * instance = nil;
+(id)getInstance
{
    if (!instance) {
        instance =[[TFIpodMusicPlayer alloc]init];
    }
    return instance;
}



-(void)configurationNSNotification:(BOOL)add
{
    
    //播放曲目改变时
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
    //播放曲目状态改变时
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
    
    [self.player endGeneratingPlaybackNotifications];
    
    if (add) {
        
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(playingItemChanged:)
                                                     name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                                                   object: self.player];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(playbackStateChanged:)
                                                     name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
                                                   object: self.player];

    }
}


-(id)init
{
	self = [super init];
	if(self){
        
        [self runTimer:YES];
        [self configurationNSNotification:YES];
        
	}
	return self;
}


-(void)runTimer:(BOOL)run
{
    if (_progressTimer !=nil && [_progressTimer isKindOfClass:[NSTimer class]]) {
        if ([_progressTimer isValid]) {
            [_progressTimer invalidate];
        }
    }
    
    if (run) {
        
        _progressTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(progressTimerRun:)
                                                        userInfo:nil
                                                         repeats:YES];
        if ([_progressTimer isValid]) {
            [_progressTimer fire];
        }
    }
}


-(void)progressTimerRun:(NSTimer *)timer
{
    MPMusicPlaybackState state = [_player playbackState];
    if (state == MPMusicPlaybackStatePlaying) {
        NSString *progressStr = [NSString stringWithFormat:@"%f",[self currentTime]/[self totalTime]];
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:tfkTFIpodMusicPlayerProgressTimer
                                                           object:@{@"progress":progressStr}];
    }
    
    
    
    NSLog(@"---------%d",state);
    
}


#pragma mark ----------  进度条拖动通知

-(void)TFSigleSliderVIDidChange:(NSNotification *)notification
{
    if ([_player playbackState]==MPMusicPlaybackStatePlaying||
        [_player playbackState]==MPMusicPlaybackStatePaused) {
        
        NSDictionary *info = (NSDictionary *)notification.object;
        NSString *state = [info objectForKey:@"state"];
        NSString *progress = [info objectForKey:@"progress"];
        
        if ([state isEqualToString:@"touchesEnded"]) {
            [self setProgress:[progress floatValue]];
        }
    }
}

-(void)setPlayerType:(MusicPlayerType)playerType SongList:(NSArray *)list
{
    _mediaItemList = [[NSMutableArray alloc]init];
    self.playerType = playerType;
    [self reloadSongList:list];
    
}



#pragma mark -------- 设置播放器类型 （get方法）
-(void)setPlayerType:(MusicPlayerType)playerType
{
    _playerType = playerType;
    if (_playerType == ApplicationMusicPlayer) {
        self.player = [MPMusicPlayerController applicationMusicPlayer];
        
        //开启通知，不开启无法接收播放器通知
        [self.player beginGeneratingPlaybackNotifications];
        MPLog(@"设置播放器类型ApplicationMusicPlayer");
        
    }
    if (_playerType == IPodMusicPlayer) {
        self.player = [MPMusicPlayerController iPodMusicPlayer];
        //开启通知，不开启无法接收播放器通知
        [self.player beginGeneratingPlaybackNotifications];
        MPLog(@"设置播放器类型IPodMusicPlayer");
    }
}


#pragma mark -------- 重设播放列表 （get方法）
-(void)reloadSongList:(NSArray *)list
{
    MPLog(@"刷新播放器列表");
    if (list==nil || (![list isKindOfClass:[NSArray class]]) || list.count==0) {
        return;
    }
    
    if (list!=nil) {
        [_mediaItemList removeAllObjects];
        [_mediaItemList addObjectsFromArray:list];
    }
    
    
    if (_mediaItemCollection ==nil || (![_mediaItemCollection isKindOfClass:[MPMediaItemCollection class]])) {
        _mediaItemCollection = [[MPMediaItemCollection alloc]initWithItems:_mediaItemList];
        [_player setQueueWithItemCollection:_mediaItemCollection];
        [_player setRepeatMode:MPMusicRepeatModeAll];
        [_player setShuffleMode:MPMusicShuffleModeOff];
        return;
    }
    
#if __has_feature(objc_arc)
    _mediaItemCollection = [[MPMediaItemCollection alloc]initWithItems:list];
    [_player setQueueWithItemCollection:_mediaItemCollection];
    [_player setRepeatMode:MPMusicRepeatModeAll];
    [_player setShuffleMode:MPMusicShuffleModeOff];
#else
    if (_mediaItemCollection !=nil && [_mediaItemCollection isKindOfClass:[MPMediaItemCollection class]]) {
        [_mediaItemCollection release];
    }
    _mediaItemCollection = [[MPMediaItemCollection alloc]initWithItems:_mediaItemList];
    [_player setQueueWithItemCollection:_mediaItemCollection];
    [_player setRepeatMode:MPMusicRepeatModeAll];
    [_player setShuffleMode:MPMusicShuffleModeOff];
#endif
    
}



#pragma mark -------- 按坐标播放
-(void)playWithIndex:(NSInteger )index
{
    if (_player == nil ||(![_player isKindOfClass:[MPMusicPlayerController class]])) {
        self.playerType = _playerType;
        [self reloadSongList:nil];
    }
    
    if (_mediaItemList.count>0 && index>=0 && index<_mediaItemList.count) {
        MPMediaItem *item = [_mediaItemList objectAtIndex:index];
        [self.player setNowPlayingItem:item];
        [self play];
    }
}

#pragma mark -------- 按歌名播放

-(void)playWithName:(NSString *)name
{
    if (_player == nil ||(![_player isKindOfClass:[MPMusicPlayerController class]])) {
        self.playerType = _playerType;
        [self reloadSongList:nil];
    }
    
    for (int i=0; i< _mediaItemList.count; i++) {
        MPMediaItem *item = [_mediaItemList objectAtIndex:i];
        NSString *title = [item valueForProperty:MPMediaItemPropertyTitle];
        if ([title isEqualToString:name] ) {
            [self.player setNowPlayingItem:item];
            [self play];
            break;
        }
    }
}


#pragma mark -------- 播放
- (void)play{
    
    MPLog(@"播放");
    [self.player prepareToPlay];
	[self.player play];
	_isPlay = YES;
    
}

#pragma mark -------- 暂停
- (void)pause{
    MPLog(@"暂停");
	[self.player pause];
    _isPlay = NO;
}

#pragma mark -------- 停止
- (void)stop{
    MPLog(@"停止");
	[self.player stop];
	_isPlay = NO;
}

#pragma mark -------- 设置进度
- (void)setProgress:(float)progress
{
    MPLog(@"设置进度");
    
    progress = progress >1?1:progress;
    progress = progress <0?0:progress;
    
    float totalTime = [self totalTime];
    float toTime = totalTime * progress;
    
    [self.player pause];
    _isPlay = NO;
    self.player.currentPlaybackTime = toTime;
    [self.player prepareToPlay];
    [self.player play];
    
}



#pragma mark -------- 歌曲总时间
-(float)totalTime
{
    if (_player.nowPlayingItem) {
        _totalTime = [[_player.nowPlayingItem valueForKey:MPMediaItemPropertyPlaybackDuration]floatValue];
    }
    return _totalTime;
}

#pragma mark -------- 当前时间
-(float)currentTime
{
    return _player.currentPlaybackTime;
}


#pragma mark -------- 歌曲专辑图片
-(UIImage *)songImage
{
    MPMediaItem *nowItem = [_player nowPlayingItem];
	MPMediaItemArtwork *artwork = [nowItem valueForProperty:MPMediaItemPropertyArtwork];
	if(artwork){
		return [artwork imageWithSize:CGSizeMake(320, 320)];
	}
    return nil;
}

#pragma mark -------- 歌名

-(NSString *)songTitle
{
    MPMediaItem *nowItem = [_player nowPlayingItem];
    return [nowItem valueForProperty:MPMediaItemPropertyTitle];
}

#pragma mark -------- 歌名

-(NSString *)songArtist
{
    MPMediaItem *nowItem = [_player nowPlayingItem];
    return [nowItem valueForProperty:MPMediaItemPropertyArtist];
}



#pragma mark -------- 上一首
- (void)previousSong{
    MPLog(@"上一首");
    
	[self.player skipToPreviousItem];
}

#pragma mark -------- 下一首
- (void)nextSong{
	[self.player skipToNextItem];
    
    
    MPMediaItem *item = [self.player nowPlayingItem];
    MPLog(@"下一首 ");
    NSLog(@"----%@",[item valueForProperty:MPMediaItemPropertyTitle]);
    
    for ( MPMediaItem *item  in [_mediaItemCollection items]) {
        NSLog(@"+++++%@",[item valueForProperty:MPMediaItemPropertyTitle]);
        
    }
}


#pragma mark -------- 清空播放列表
- (void)clearSongList{
    MPLog(@"清空播放器列表");
    
    [_mediaItemList removeAllObjects];
	_mediaItemCollection = nil;
    
	[_player setQueueWithItemCollection:nil];
    [_player setRepeatMode:MPMusicRepeatModeAll];
    [_player setShuffleMode:MPMusicShuffleModeOff];
    
}



#pragma mark -------- 播放曲目改变 通知 的方法
-(void)playingItemChanged:(NSNotification *)notification
{
    MPMediaItem *currentItem = [_player nowPlayingItem];//获得正在播放的项目
    if (currentItem) {
        
    }
    
    NSInteger indexOfNowItem = [_player indexOfNowPlayingItem];
    if (indexOfNowItem){
        
    }
}

#pragma mark -------- 播放状态改变 通知 的方法
-(void)playbackStateChanged:(NSNotification *)notification
{
    NSString *stateStr = @"";
    MPMusicPlaybackState playbackState = [_player playbackState];
	if (playbackState == MPMusicPlaybackStatePlaying) {
        stateStr = @"local-正在播放";
	} else if (playbackState == MPMusicPlaybackStateStopped) {
        //即使停了下来，调用“停止”，确保从一开始的音乐播放器将发挥其队列。
        stateStr = @"local-停止播放";
		[_player stop];
	}else if(playbackState ==MPMusicPlaybackStatePaused){
        stateStr = @"local-暂停播放";
    }else if(playbackState ==MPMusicPlaybackStateInterrupted){
        stateStr = @"local-中断播放";
    }else if(playbackState ==MPMusicPlaybackStateSeekingForward){
        stateStr = @"local-前台播放";
    }else if(playbackState ==MPMusicPlaybackStateSeekingBackward){
        stateStr = @"local-后台播放";
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:TFIpodMusicPlayerState
                                                       object:stateStr];
    MPLog(stateStr);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
