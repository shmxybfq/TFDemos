//
//  TFAudioStreamerPlayer.m
//  VoiceLink
//
//  Created by Hyacinth on 14-10-11.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFAudioStreamerPlayer.h"


#import "AudioStreamer.h"
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>



//dlog 调试 -- 输出 对应的 - 文件 - 行数 - 值  // 也挺好用的，我一般是用的这个
//#ifdef DEBUG
//#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define DLog(...)
//#endif

#define ASLog(A) NSLog(@"----------%@---------%@",NSStringFromClass([self class]),A)

#define tfIfLog YES

static inline BOOL IsEmpty(id thing) {
    return thing == nil || [thing isEqual:[NSNull null]]
    || ([thing respondsToSelector:@selector(length)]
        && [(NSData *)thing length] == 0)
    || ([thing respondsToSelector:@selector(count)]
        && [(NSArray *)thing count] == 0);
}

@implementation TFAudioStreamerPlayer


@synthesize streamer = _streamer;
@synthesize songsAlbumName =_songsAlbumName;
@synthesize songMDs = _songMDs;
@synthesize curIndex = _curIndex;



-(void)dealloc
{
    [self configurationNSNotification:NO];
    [self runTimer:NO];
    [self destroyStreamer];
//    [super dealloc];
}


static TFAudioStreamerPlayer * instance = nil;
+(id)getInstance
{
    if (!instance) {
        instance =[[TFAudioStreamerPlayer alloc]init];
    }
    return instance;
}

-(id)init
{
	self = [super init];
	if(self){
        [self configurationNSNotification:YES];
        [self runTimer:YES];
        _songMDs = [[NSMutableArray alloc]init];
        self.songsAlbumName = @"";
        
 
	}
	return self;
}
-(void)configurationNSNotification:(BOOL)add
{

}




#pragma mark -------- zz- 播放器(TFAudioStreamerPlayer)整个生命周期的timer
-(void)runTimer:(BOOL)run
{
    if (_progressTimer !=nil && [_progressTimer isKindOfClass:[NSTimer class]]) {
        if ([_progressTimer isValid]) {
            [_progressTimer invalidate];
            _progressTimer = nil;
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




#pragma mark -------- zz- timer运行
-(void)progressTimerRun:(NSTimer *)timer
{
    if ([self checkStreamer]) {
        if ([_streamer isPlaying]) {
            
            NSString *progressStr = [NSString stringWithFormat:@"%f",_streamer.progress/_streamer.duration];
            [[NSNotificationCenter defaultCenter]postNotificationName:tfkTFAudioStreamerPlayerProgressTimer
                                                               object:@{@"progress":progressStr}];
        }
    }
}



#pragma mark -------- zz- 销毁流
- (void)destroyStreamer
{
	if ([self checkStreamer]){
		[[NSNotificationCenter defaultCenter]removeObserver:self
                                                       name:ASStatusChangedNotification
                                                     object:_streamer];

		[_streamer stop];
		_streamer = nil;
	}
}



#pragma mark -------- zz- 播放流通过url
-(void)playWithUrlStr:(NSString *)urlStr
{
    if ([self checkStreamer]) {
        [self destroyStreamer];
    }
    if (urlStr == nil || (![urlStr isKindOfClass:[NSString class]]) ||urlStr == NULL || [urlStr isKindOfClass:[NSConstantString class]] ||IsEmpty(urlStr)) {
        
        UIAlertView *alert =  [[UIAlertView alloc]initWithTitle:@"播放失败"
                                  message:@"没有找到音乐文件"
                                 delegate:nil cancelButtonTitle:@"确定"
                        otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    self.urlStr = urlStr;
    
    //url转码
    NSString *streamerUrlStr =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)self.urlStr,NULL,NULL,kCFStringEncodingUTF8));
    
	NSURL *url = [NSURL URLWithString:streamerUrlStr];
	_streamer = [[AudioStreamer alloc] initWithURL:url];
    [_streamer start];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(playbackStateChanged:)
                                                name:ASStatusChangedNotification
                                              object:_streamer];
    
    ASLog(urlStr);

}



#pragma mark ---------- zz- 流播放状态改变通知
- (void)playbackStateChanged:(NSNotification *)aNotification
{

    NSString *stateStr =@"";
	if ([_streamer isWaiting]){//正在等待播放
        stateStr = @"cloud-等待播放";
	}else if ([_streamer isPlaying]){//正在播放
        stateStr = @"cloud-正在播放";
	}else if ([_streamer isIdle]){//正在闲置
        stateStr = @"cloud-闲置播放";
	}else if ([_streamer isPaused]){//正在暂停
        stateStr = @"cloud-暂停播放";
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:tfkMusicPlayerState object:stateStr];

    ASLog(stateStr);


    
}



#pragma mark ---------- zz- 播放
- (void)play
{
    if ([self checkStreamer]) {
        [_streamer start];
    }
}
#pragma mark ---------- zz- 暂停
- (void)pause
{
    if ([self checkStreamer]) {
        [_streamer pause];
    }
}
#pragma mark ---------- zz- 停止
- (void)stop
{
    if ([self checkStreamer]) {
        [_streamer pause];
        [self destroyStreamer];
    }
}

#pragma mark ---------- zz- 上一首
-(void)preSong
{
    if (_songMDs.count==0) {
        return;
    }
    
    NSInteger temIndex = self.curIndex;
    temIndex = (temIndex-1)<0?(_songMDs.count -1):(temIndex-1);
//    TFAudioStreamerPlayerMD *md = [_songMDs objectAtIndex:temIndex];
//    self.title = md.name;
//    self.artist = md.singer;
//    [self playWithUrlStr:md.path];
}


#pragma mark ---------- zz- 下一首
-(void)nextSong
{
    if (_songMDs.count==0) {
        return;
    }
    
    NSInteger temIndex = self.curIndex;
    temIndex = (temIndex+1)>=_songMDs.count?0:(temIndex+1);
//    TFAudioStreamerPlayerMD *md = [_songMDs objectAtIndex:temIndex];
//    self.title = md.name;
//    self.artist = md.singer;
//    [self playWithUrlStr:md.path];
}



#pragma mark ---------- zz- 设置进度
- (void)setProgress:(float)progress
{
    if ([self checkStreamer]) {
        [_streamer seekToTime:progress * _streamer.duration];
    }
}




-(BOOL)checkStreamer
{
    if (_streamer !=nil && [_streamer isKindOfClass:[AudioStreamer class]]) {
        return YES;
    }
    return NO;
}

-(NSInteger)curIndex
{
//    _curIndex = 0;
//    for (int i=0; i<_songMDs.count; i++) {
//        TFAudioStreamerPlayerMD *md = [_songMDs objectAtIndex:i];
//        if ([self.title isEqualToString:md.name] ||[self.urlStr isEqualToString:md.path]) {
//            _curIndex = i;
//            break;
//        }
//    }
    return _curIndex;
}



@end
