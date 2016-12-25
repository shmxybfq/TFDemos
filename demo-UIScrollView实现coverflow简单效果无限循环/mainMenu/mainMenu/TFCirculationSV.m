//
//  TFCirculationSV.m
//  VoiceLink
//
//  Created by Hyacinth on 14-9-12.
//  Copyright (c) 2014年 Hyacinth.TaskTinkle. All rights reserved.
//

#import "TFCirculationSV.h"


#ifndef tfVB
#define tfVB ([self isKindOfClass:[UIView class]])?(self.bounds):(((UIViewController*)self).view.bounds)
#define tfVBW CGRectGetWidth(tfVB)
#define tfVBH CGRectGetHeight(tfVB)
#define tfVBX CGRectGetMinX(tfVB)
#define tfVBY CGRectGetMinY(tfVB)
#endif

#import "TFMenuVI.h"



#define tfRectX(R)      R.origin.x
#define tfRectY(R)      R.origin.y
#define tfRectW(R)      R.size.width
#define tfRectH(R)      R.size.height


#define tfRectMaxX(R)           tfRectX(R) + tfRectW(R)
#define tfRectMaxY(R)           tfRectY(R) + tfRectH(R)


#define tfRectSize(R)        CGSizeMake(tfRectW(R), tfRectH(R))
#define tfRectOrigin(R)      CGPointMake(tfRectX(R), tfRectY(R))
#define tfRectCenter(R)      CGPointMake(tfRectX(R) + tfRectW(R) /2.0, tfRectY(R) + tfRectH(R)/2.0)


#define tfRectSetWidth(R, W)         CGRectMake(tfRectX(R), tfRectY(R), W, tfRectH(R))
#define tfRectSetHeight(R, H)        CGRectMake(tfRectX(R), tfRectY(R), tfRectW(R), H)
#define tfRectSetX(R, X)             CGRectMake(X, tfRectY(R), tfRectW(R), tfRectH(R))
#define tfRectSetY(R, Y)             CGRectMake(tfRectX(R), Y, tfRectW(R), tfRectH(R))
#define tfRectSetSize(R, S)          CGRectMake(tfRectX(R), tfRectY(R), S.width, S.height)
#define tfRectSetOrigin(R,O)         CGRectMake(O.x, O.y, tfRectW(R), tfRectH(R))
#define tfRectSetCenter(R,P)         CGRectMake(tfRectX(R) - tfRectW(R)/2.0, tfRectY(R) - tfRectH(R), tfRectW(R), tfRectH(R))



@interface TFCirculationSV ()
{
    NSTimer *_timer;
}
@end


@implementation TFCirculationSV

@synthesize bgViewIV = _bgViewIV;
@synthesize scrollViewSV = _scrollViewSV;
@synthesize scrollSubViews =_scrollSubViews;
@synthesize centerPoints = _centerPoints;
@synthesize curIndex = _curIndex;

-(void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGRect sb = self.bounds;
        _bgViewIV = [[UIImageView alloc]initWithFrame:sb];
        [self addSubview:_bgViewIV];
        _bgViewIV.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0f
                                                    green:arc4random()%255/255.0f
                                                     blue:arc4random()%255/255.0f
                                                    alpha:0];
        
        
        
        
        _scrollSubViews = [[NSMutableArray alloc]init];
        _centerPoints = [[NSMutableArray alloc]init];
        
        _scrollViewSV = [[UIScrollView alloc]initWithFrame:sb];
        _scrollViewSV.delegate = self;
        _scrollViewSV.decelerationRate =0.1;
        [self addSubview:_scrollViewSV];
        
    }
    return self;
}


-(void)setSubViewsWithArray:(NSArray *)views
{
    [_scrollSubViews removeAllObjects];
    [_scrollSubViews addObjectsFromArray:views];
    
    _curIndex = 0;
    [self resetSubViews];
    _scrollViewSV.contentOffset = CGPointMake(740, _scrollViewSV.contentOffset.y);
}


-(void)resetSubViews
{
    float x = 0;
    float y = 100;
    float w = 200;
    float h = 200;
    _scrollViewSV.contentSize = CGSizeMake(w*_scrollSubViews.count, 200);
    for (int i=0; i<_scrollSubViews.count; i++) {
        TFMenuVI *view = _scrollSubViews[i];
        view.index = i;
        view.tag = i;
        view.imageStr = @"dog.png";
        [_scrollViewSV addSubview:view];
        view.frame = CGRectMake(x, y , w , h);
        x +=w;
        //        view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0f
        //                                               green:arc4random()%255/255.0f
        //                                                blue:arc4random()%255/255.0f
        //                                               alpha:1];
        [_centerPoints addObject:[NSString stringWithFormat:@"%f",140.0 + 200.0 *i]];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        CGPoint ofset = scrollView.contentOffset;
        float x = [self getNearstPoint:ofset.x];
        [scrollView scrollRectToVisible:CGRectMake(x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
        
    }
}

-(float)getNearstPoint:(float)x
{
    
    NSInteger index = -1;
    float nearst = 999999;
    for (int i=0; i<_centerPoints.count; i++) {
        float cur = [_centerPoints[i]floatValue];
        float cha = (cur - x)<=0?-(cur - x):(cur - x);
        if (cha < nearst) {
            index = i;
            nearst = cha;
        }
    }
    return [_centerPoints[index]floatValue];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    CGPoint ofset = scrollView.contentOffset;
    float x = [self getNearstPoint:ofset.x];
    [scrollView scrollRectToVisible:CGRectMake(x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    for (TFMenuVI *vi in _scrollSubViews) {
        vi.ofSet = scrollView.contentOffset;
    }
}

//调用scrollRectToVisible的回调
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self resetSubViews2];
}

-(void)resetSubViews2
{
    if (_scrollViewSV.contentOffset.x == 540) {
        [[_scrollViewSV subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        for (int i=0; i<_scrollSubViews.count; i++) {
            TFMenuVI *menu = _scrollSubViews[i];
            CGRect of = menu.frame;
            of = tfRectSetX(of, of.origin.x + 200);
            if (of.origin.x < 0) {
                of = tfRectSetX(of, 1600);
                [_scrollViewSV addSubview:menu];
            }else if(of.origin.x > 1600){
                of = tfRectSetX(of, 0);
                menu.frame = of;
                [_scrollViewSV addSubview:menu];
            }else{
                menu.frame = of;
                [_scrollViewSV addSubview:menu];
            }
        }
        
    }else if (_scrollViewSV.contentOffset.x == 940){
        [[_scrollViewSV subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i=0; i<_scrollSubViews.count; i++) {
            TFMenuVI *menu = _scrollSubViews[i];
            CGRect of = menu.frame;
            of = tfRectSetX(of, of.origin.x - 200);
            if (of.origin.x < 0) {
                menu.frame = tfRectSetX(of, 1600);
                [_scrollViewSV addSubview:menu];
            }else if(of.origin.x > 1600){
                menu.frame = tfRectSetX(of, 0);
                [_scrollViewSV addSubview:menu];
            }else{
                menu.frame = of;
                [_scrollViewSV addSubview:menu];
            }
        }
    }
    
    _scrollViewSV.contentOffset = CGPointMake(740, _scrollViewSV.contentOffset.y);
    [_scrollSubViews removeAllObjects];
    for (int i=0; i< _scrollViewSV.subviews.count; i++) {
        UIView *vi = _scrollViewSV.subviews[i];
        if ([vi isKindOfClass:[TFMenuVI class]]) {
            [_scrollSubViews addObject:vi];
        }
        
    }
}





/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
