//
//  HHPlayerView.m
//
//  Copyright (c) 2013 Wanqiang Ji
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

#import "HHPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "HHPlayerKit.h"

#define NAV_VIEW_H      57.f
#define CONTROL_VIEW_H  67.f
#define ANIMATION_TIME_INTERVAL .5f

#define INDICATOR_TITLE @"提示 : 该视频已经通过AirPlay转到高清屏幕播放"

#pragma mark - __MediaView

@interface __MediaView : UIView

@end

@implementation __MediaView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

@end

#pragma mark - HHPlayerView

@implementation HHPlayerView
{
    BOOL _isInitalized;
    CGRect _preFrame;
    UIView *_statusBarView;
}

- (void)__destroyProperty
{
    self.backgroundView = nil;
    self.controlView = nil;
    self.navigationView = nil;
}

- (void)__destroyVariable
{
    [_mediaView release], _mediaView = nil;
    [_statusBarView release], _statusBarView = nil;
}

- (void)dealloc
{
    [self __destroyVariable];
    [self __destroyProperty];
    [super dealloc];
}

#pragma mark - Private Methods

- (void)__setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)_mediaView.layer setPlayer:player];
    [(AVPlayerLayer *)_mediaView.layer setVideoGravity:AVLayerVideoGravityResizeAspect];
}

- (void)__initBackgroundView
{
    _backgroundView = [[HHPlayerBGView alloc] initWithFrame:CGRectMake(0, 0, _width, _height)];
    [self addSubview:_backgroundView];
    _airplayActiveView = [[HHAirplayActiveView alloc] initWithFrame:CGRectMake(0.f, 0.f, _width, _height) indicatorTitle:INDICATOR_TITLE];
    [_airplayActiveView setHidden:YES];
    [self addSubview:_airplayActiveView];
}

- (void)__initMediaView
{
    _mediaView.frame = CGRectMake(0, 0, _width, _height);
    [self addSubview:_mediaView];
}

- (void)__initNavigationView
{
    _statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, _width, 44.f)];
    [_statusBarView setBackgroundColor:[UIColor blackColor]];
    _statusBarView.hidden = YES;
    [self addSubview:_statusBarView];
    
    _navigationView = [[HHPlayerNavView alloc] initWithFrame:CGRectMake(0.f, 20.f, _width, 44.f)];
    [_navigationView setHidden:YES];
    [self addSubview:_navigationView];
}

- (void)__initControlView
{
    _controlView = [[HHPlayerControlView alloc] initWithFrame:CGRectMake(0.f, _height - 78.f, _width, 78.f)];
    [self addSubview:_controlView];
}

- (void)__initalize
{
    _isInitalized = YES;
    [self __initBackgroundView];
    [self __initMediaView];
    [self __initControlView];
    [self __initNavigationView];
}

- (void)__layoutSubViews
{
    _statusBarView.frame = CGRectMake(0.f, 0.f, _width, 20.f);
    
    _backgroundView.frame = CGRectMake(0, 0, _width, _height);
    _airplayActiveView.frame = CGRectMake(0, 0, _width, _height);
    _mediaView.frame = CGRectMake(0, 0, _width, _height);
    _navigationView.frame = CGRectMake(0.f, 20.f, _width, NAV_VIEW_H);
    _controlView.frame = CGRectMake(0.f, _height - CONTROL_VIEW_H, _width, CONTROL_VIEW_H);
}

#pragma mark - Super Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isInitalized = NO;
        
        _width = CGRectGetWidth(frame);
        _height = CGRectGetHeight(frame);
        
        [self setBackgroundColor:[UIColor clearColor]];
        _mediaView = [__MediaView new];
    }
    return self;
}

#pragma mark - Setter and Getter

- (void)setFrame:(CGRect)frame
{
    if (CGRectIsEmpty(frame)) return;
    
    [super setFrame:frame];
    _width = CGRectGetWidth(frame);
    _height = CGRectGetHeight(frame);
    
    if (_isInitalized) {
        [self __layoutSubViews];
    } else {
        [self __initalize];
    }
}

- (void)setScalingMode:(HHMovieScalingMode)scalingMode
{
    _scalingMode = scalingMode;
    
    NSString *videoGravity = nil;
    switch (scalingMode) {
        case HHMovieScalingModeNone:
            videoGravity = nil;
            break;
        case HHMovieScalingModeAspectFit:
            videoGravity = AVLayerVideoGravityResizeAspect;
            break;
        case HHMovieScalingModeAspectFill:
            videoGravity = AVLayerVideoGravityResizeAspectFill;
            break;
        case HHMovieScalingModeFill:
            videoGravity = AVLayerVideoGravityResize;
            break;
    }
    
    [(AVPlayerLayer *)_mediaView.layer setVideoGravity:videoGravity];
}

- (void)setBackgroundView:(HHPlayerBGView *)backgroundView
{
    if (_backgroundView != backgroundView) {
        [_backgroundView removeFromSuperview];
        [_backgroundView release], _backgroundView = nil;
    }
}

- (void)setNavigationView:(HHPlayerNavView *)navigationView
{
    if (_navigationView) {
        [_navigationView release], _navigationView = nil;
    }
    _navigationView = [navigationView retain];
    
    [self setNeedsLayout];
}

- (void)setControlView:(HHPlayerControlView *)controlView
{
    if (_controlView) {
        [_controlView release], _controlView = nil;
    }
    _controlView = [controlView retain];
    
    [self setNeedsLayout];
}

- (BOOL)isFullScreen
{
    CGFloat h = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]);
    return (_width == h);
}

- (NSTimeInterval)controlViewHideAnimationDuration
{
    return ANIMATION_TIME_INTERVAL;
}

#pragma mark - Public Methods

- (void)becomeFullScreenWithAnimation:(BOOL)animation
{
    if (animation) {
        self.userInteractionEnabled = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIMATION_TIME_INTERVAL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(showControlView)];
        [self hideControlView];
    }
    
    _preFrame = self.frame;
    CGFloat w = CGRectGetHeight([UIScreen mainScreen].applicationFrame);
    CGFloat h = CGRectGetWidth([UIScreen mainScreen].applicationFrame);
    [self setFrame:CGRectMake(0.f, 0.f, w, h + 20.f)];
    
    if (animation) {
        [UIView commitAnimations];
    } else {
        self.navigationView.hidden = NO;
    }
}

- (void)resignFullScreenWithAnimation:(BOOL)animation
{
    if (animation) {
        self.userInteractionEnabled = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIMATION_TIME_INTERVAL];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(showControlView)];
        [self setFrame:_preFrame];
        [self hideControlView];
        [UIView commitAnimations];
    } else {
        self.frame = _preFrame;
    }
}

- (void)hideControlView
{
    _isHideControl = YES;
    
    self.controlView.hidden = YES;
    self.navigationView.hidden = YES;
    
    _statusBarView.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:[self isFullScreen]];
}

- (void)showControlView
{
    self.userInteractionEnabled = YES;
    _isHideControl = NO;
    
    self.controlView.hidden = NO;
    self.navigationView.hidden = ![self isFullScreen];
    _statusBarView.hidden = ![self isFullScreen];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - 

@end
