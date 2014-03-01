//
//  HHPlayerControlView.m
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

#import "HHPlayerControlView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define BUTTON_PLAY_PAUSE_L 23.f
#define BUTTON_PLAY_PAUSE_R 16.f
#define BUTTON_PLAY_PAUSE_T 9.f
#define BUTTON_PLAY_PAUSE_W 49.f
#define BUTTON_PLAY_PAUSE_H 49.f

#define SLIDER_PROGRESS_L   16.f
#define SLIDER_PROGRESS_R   21.f
#define SLIDER_PROGRESS_T   23.f
#define SLIDER_PROGRESS_W   0.f
#define SLIDER_PROGRESS_H   29.f
#define SLIDER_PROGRESS_FR  54.f

#define IMAGEVIEW_VOLUME_L  49.f
#define IMAGEVIEW_VOLUME_R  4.f
#define IMAGEVIEW_VOLUME_T  29.f
#define IMAGEVIEW_VOLUME_W  26.f
#define IMAGEVIEW_VOLUME_H  22.f

#define SLIDER_VOLUME_L     4.f
#define SLIDER_VOLUME_R     37.f
#define SLIDER_VOLUME_T     27.f
#define SLIDER_VOLUME_W     127.f
#define SILDER_VOLUME_H     29.f

#define BUTTON_SCALE_L      0.f
#define BUTTON_SCALE_R      25.f
#define BUTTON_SCALE_T      13.f
#define BUTTON_SCALE_W      49.f
#define BUTTON_SCALE_H      43.f

#define LABEL_TIME_L        17.f
#define LABEL_TIME_T        53.f
#define LABEL_TIME_FONT     [UIFont systemFontOfSize:18.f]
#define LABEL_TIME_COLOR    [UIColor whiteColor]

#define LABEL_TIME_DEFAULT_TEXT @"--:-- / --:--"

@interface NSObject (Listener)

- (void)listenOutPutVolumeWithCallBack:(AudioSessionPropertyListener)intProc;
- (void)removeOutPutVolumeListenerWithProc:(AudioSessionPropertyListener)intProc;

- (void)listenAudioRouteChangeWithCallBack:(AudioSessionPropertyListener)intProc;
- (void)removeAudioRouteVolumeListenerWithProc:(AudioSessionPropertyListener)intProc;

@end

@implementation NSObject (Listener)

- (void)listenOutPutVolumeWithCallBack:(AudioSessionPropertyListener)intProc
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                    intProc,
                                    self);
}

- (void)removeOutPutVolumeListenerWithProc:(AudioSessionPropertyListener)intProc;
{
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                                   intProc,
                                                   self);
}

- (void)listenAudioRouteChangeWithCallBack:(AudioSessionPropertyListener)intProc
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
                                    intProc,
                                    self);
}

- (void)removeAudioRouteVolumeListenerWithProc:(AudioSessionPropertyListener)intProc
{
    AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange,
                                                   intProc,
                                                   self);
}

@end


void outputVolumeListenerCallback(void                      *inUserData,
                                  AudioSessionPropertyID    inPropertyID,
                                  UInt32                    inPropertyValueSize,
                                  const void                *inPropertyValue
                                  )
{
    float volume = [MPMusicPlayerController iPodMusicPlayer].volume;
    HHPlayerControlView *controlView = (HHPlayerControlView *)inUserData;
    if (![controlView isKindOfClass:[HHPlayerControlView class]]) {
        return;
    }
    
    controlView.volumeSlider.value = volume;
    
    if (volume >= 0.65) {
        [controlView.volumeIndicateView setImage:[controlView valueForKey:@"volumeHighImage"]];
    } else if (volume < 0.65 && volume >= 0.35) {
        [controlView.volumeIndicateView setImage:[controlView valueForKey:@"volumeMiddleImage"]];
    } else if (volume < 0.35 && volume > 0) {
        [controlView.volumeIndicateView setImage:[controlView valueForKey:@"volumeLowImage"]];
    } else {
        [controlView.volumeIndicateView setImage:[controlView valueForKey:@"volumeMuteImage"]];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface HHPlayerControlView ()
{
    CGFloat _w;
    CGFloat _h;
}

@property (nonatomic, retain) UIImage *bgImg;

@property (nonatomic, retain) UIImage *zoomInNormalImg;
@property (nonatomic, retain) UIImage *zoomInHightImg;
@property (nonatomic, retain) UIImage *zoomOutNormalImg;
@property (nonatomic, retain) UIImage *zoomOutHightImg;

@property (nonatomic, retain) UIImage *volumeHighImage;
@property (nonatomic, retain) UIImage *volumeMiddleImage;
@property (nonatomic, retain) UIImage *volumeLowImage;
@property (nonatomic, retain) UIImage *volumeMuteImage;


@property (nonatomic, retain) UIImage *volumeSliderMaxImage;
@property (nonatomic, retain) UIImage *volumeSliderMinImage;
@property (nonatomic, retain) UIImage *volumeSliderThumbImage;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HHPlayerControlView

- (void)__destoryProperty
{
    self.bgImg = nil;
    self.zoomInHightImg = nil;
    self.zoomInNormalImg = nil;
    self.zoomOutNormalImg = nil;
    self.zoomOutHightImg = nil;
    self.volumeHighImage = nil;
    self.volumeLowImage = nil;
    self.volumeMiddleImage = nil;
    self.volumeSliderMaxImage = nil;
    self.volumeSliderMinImage = nil;
    self.volumeSliderThumbImage = nil;
}

- (void)__destoryVariable
{
    [_bgImg release], _bgImg = nil;
    [_bgImageView release], _bgImageView = nil;
    [_playPauseButton release], _playPauseButton = nil;
    [_scaleButton release], _scaleButton = nil;
    [_progressSlider release], _progressSlider = nil;
    [_volumeIndicateView release], _volumeIndicateView = nil;
    [_volumeSlider release], _volumeSlider = nil;
    [_timeLabel release], _timeLabel = nil;
}

- (void)dealloc
{
    [self removeOutPutVolumeListenerWithProc:outputVolumeListenerCallback];
    
    [self __destoryProperty];
    [self __destoryVariable];
    [super dealloc];
}

#pragma mark - Super Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _w = CGRectGetWidth(frame);
        _h = CGRectGetHeight(frame);
        [self setContentMode:UIViewContentModeRedraw];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self __initalize];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _w = CGRectGetWidth(self.frame);
    _h = CGRectGetHeight(self.frame);
    
    [_bgImageView setFrame:CGRectMake(0.f, 0.f, _w, _h)];
    [_playPauseButton setFrame:CGRectMake(BUTTON_PLAY_PAUSE_L, BUTTON_PLAY_PAUSE_T,
                                          BUTTON_PLAY_PAUSE_W, BUTTON_PLAY_PAUSE_H)];
    CGFloat x = _w - BUTTON_SCALE_R - BUTTON_SCALE_W;
    [_scaleButton setFrame:CGRectMake(x, BUTTON_SCALE_T, BUTTON_SCALE_W, BUTTON_SCALE_H)];
    
    x = _playPauseButton.frame.origin.x + BUTTON_PLAY_PAUSE_W + LABEL_TIME_L;
    CGRect r = _timeLabel.frame;
    r.origin.x = x;
    [_timeLabel setFrame:r];
    
    if ([self __isFullScreen]) {
        [self __layoutOfFullScreen];
    } else {
        [self __layoutOfDefault];
    }
    
}

#pragma mark - Private Methods

- (void)__initBackgroundImageView
{
    if (_bgImageView) {
        return;
    }
    
    CGRect frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _bgImageView = [[UIImageView alloc] initWithFrame:frame];
    [_bgImageView setImage:_bgImg];
    [self addSubview:_bgImageView];
}

- (void)__initPlayPauseButton
{
    if (_playPauseButton) {
        return;
    }
    
    _playPauseButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _playPauseButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:_playPauseButton];
}

- (void)__initScaleButton
{
    if (_scaleButton) {
        return;
    }
    
    _scaleButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _scaleButton.adjustsImageWhenHighlighted = NO;
    [self addSubview:_scaleButton];
}

- (void)__initProgressSlider
{
    if (_progressSlider) {
        return;
    }
    
    CGFloat x = _playPauseButton.frame.origin.x + BUTTON_PLAY_PAUSE_W + SLIDER_PROGRESS_L;
    CGFloat w = _scaleButton.frame.origin.x - x - SLIDER_PROGRESS_R;
    _progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(x, SLIDER_PROGRESS_T, w, SLIDER_PROGRESS_H)];
    [self addSubview:_progressSlider];
}

- (void)__initTimeLabel
{
    if (_timeLabel) {
        return;
    }
    
    CGFloat x = _playPauseButton.frame.origin.x + BUTTON_PLAY_PAUSE_W + LABEL_TIME_L;
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,
                                                           LABEL_TIME_T,
                                                           100,
                                                           44)];
    [_timeLabel setBackgroundColor:[UIColor clearColor]];
    [_timeLabel setTextColor:LABEL_TIME_COLOR];
    [_timeLabel setFont:LABEL_TIME_FONT];
    [_timeLabel setText:LABEL_TIME_DEFAULT_TEXT];
    CGSize s = [_timeLabel.text sizeWithFont:LABEL_TIME_FONT];
    CGRect r = _timeLabel.frame;
    r.size.width = s.width;
    r.size.height = s.height;
    _timeLabel.frame = r;
    [self addSubview:_timeLabel];
}

- (void)__initVolumeIndicateImageView
{
    CGRect r = _progressSlider.frame;
    CGFloat x = r.origin.x + r.size.width + IMAGEVIEW_VOLUME_L;
    r = CGRectMake( x, IMAGEVIEW_VOLUME_T, IMAGEVIEW_VOLUME_W, IMAGEVIEW_VOLUME_H);
    [_volumeIndicateView setFrame:r];
    
    float value = [MPMusicPlayerController iPodMusicPlayer].volume;
    if (value >= 0.65) {
        [_volumeIndicateView setImage:self.volumeHighImage];
    } else if (value < 0.65 && value >= 0.35) {
        [_volumeIndicateView setImage:self.volumeMiddleImage];
    } else if (value < 0.35 && value > 0) {
        [_volumeIndicateView setImage:self.volumeLowImage];
    } else {
        [_volumeIndicateView setImage:self.volumeMuteImage];
    }
    
    if (![self.subviews containsObject:_volumeIndicateView])
    {
        [self addSubview:_volumeIndicateView];
    }

}

- (void)__initVolumeSlider
{
    CGRect r = _volumeIndicateView.frame;
    CGFloat x = r.origin.x + r.size.width + SLIDER_VOLUME_L;
    r = CGRectMake( x, SLIDER_VOLUME_T, SLIDER_VOLUME_W, SILDER_VOLUME_H);
    [_volumeSlider setFrame:r];
    [_volumeSlider setThumbImage:_volumeSliderThumbImage forState:UIControlStateNormal];
    [_volumeSlider setMaximumTrackImage:_volumeSliderMaxImage forState:UIControlStateNormal];
    [_volumeSlider setMinimumTrackImage:_volumeSliderMinImage forState:UIControlStateNormal];
    [_volumeSlider setValue:[MPMusicPlayerController iPodMusicPlayer].volume];
    
    if (![self.subviews containsObject:_volumeSlider]) {
        [self addSubview:_volumeSlider];
    }
    
    [self listenOutPutVolumeWithCallBack:outputVolumeListenerCallback];
}
////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)__initalize
{
    [self __initBackgroundImageView];
    [self __initPlayPauseButton];
    [self __initScaleButton];
    [self __initProgressSlider];
    [self __initTimeLabel];
    
    _volumeIndicateView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _volumeSlider = [[UISlider alloc] initWithFrame:CGRectZero];
}

- (void)__layoutOfFullScreen
{
    [_scaleButton setImage:self.zoomOutNormalImg forState:UIControlStateNormal];
    [_scaleButton setImage:self.zoomOutHightImg forState:UIControlStateHighlighted];
    
    CGFloat x = _playPauseButton.frame.origin.x + BUTTON_PLAY_PAUSE_W + SLIDER_PROGRESS_L;
    CGFloat w = _scaleButton.frame.origin.x - (x + SLIDER_PROGRESS_FR + IMAGEVIEW_VOLUME_W
                                               + IMAGEVIEW_VOLUME_R + SLIDER_VOLUME_W
                                               + SLIDER_VOLUME_R);
    [_progressSlider setFrame:CGRectMake(x, SLIDER_PROGRESS_T, w, SLIDER_PROGRESS_H)];
    
    [self __initVolumeIndicateImageView];
    [self __initVolumeSlider];
    
    _volumeIndicateView.hidden = NO;
    _volumeSlider.hidden = NO;
}

- (void)__layoutOfDefault
{
    [_scaleButton setImage:self.zoomInNormalImg forState:UIControlStateNormal];
    [_scaleButton setImage:self.zoomInHightImg forState:UIControlStateHighlighted];
    
    CGFloat x = _playPauseButton.frame.origin.x + BUTTON_PLAY_PAUSE_W + SLIDER_PROGRESS_L;
    CGFloat w = _scaleButton.frame.origin.x - x - SLIDER_PROGRESS_R;
    [_progressSlider setFrame:CGRectMake(x, SLIDER_PROGRESS_T, w, SLIDER_PROGRESS_H)];
    
    _volumeIndicateView.hidden = YES;
    _volumeSlider.hidden = YES;
    
    [self removeOutPutVolumeListenerWithProc:outputVolumeListenerCallback];
}

- (BOOL)__isFullScreen
{
    CGFloat ah = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]);
    return (_w == ah);
}

#pragma mark - Public Methods

- (void)setBackgroundImage:(UIImage *)image
{
    self.bgImg = image;
    [_bgImageView setImage:_bgImg];
}

- (void)setPlayImage:(UIImage *)playImg pauseImage:(UIImage *)pauseImg
{
    [_playPauseButton setImage:pauseImg forState:UIControlStateNormal];
    [_playPauseButton setImage:playImg forState:UIControlStateSelected];
}

- (void)setZoomInNormalImage:(UIImage *)nImg highlightedImage:(UIImage *)hImg
{
    self.zoomInNormalImg = nImg;
    self.zoomInHightImg = hImg;
    if (![self __isFullScreen]) {
        [_scaleButton setImage:nImg forState:UIControlStateNormal];
        [_scaleButton setImage:hImg forState:UIControlStateHighlighted];
    }
}

- (void)setZoomOutNormalImage:(UIImage *)nImg highlightedImage:(UIImage *)hImg
{
    self.zoomOutNormalImg = nImg;
    self.zoomOutHightImg = hImg;
    if ([self __isFullScreen]) {
        [_scaleButton setImage:nImg forState:UIControlStateNormal];
        [_scaleButton setImage:hImg forState:UIControlStateHighlighted];
    }
}

- (void)setProgressMaxImage:(UIImage *)maxImg minImage:(UIImage *)minImg thumbImage:(UIImage *)tImg
{
    [_progressSlider setThumbImage:tImg forState:UIControlStateNormal];
    [_progressSlider setMaximumTrackImage:maxImg forState:UIControlStateNormal];
    [_progressSlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
}

- (void)setVolumeHighImage:(UIImage *)hImg middleImage:(UIImage *)mImg lowImage:(UIImage *)lImg muteImage:(UIImage *)muteImg
{
    self.volumeHighImage = hImg;
    self.volumeMiddleImage = mImg;
    self.volumeLowImage = lImg;
    self.volumeMuteImage = muteImg;
}

- (void)setVolumeMaxImage:(UIImage *)maxImg minImage:(UIImage *)minImg thumbImage:(UIImage *)tImg
{
    self.volumeSliderMaxImage = maxImg;
    self.volumeSliderMinImage = minImg;
    self.volumeSliderThumbImage = tImg;
    if (_volumeSlider) {
        [_volumeSlider setThumbImage:tImg forState:UIControlStateNormal];
        [_volumeSlider setMaximumTrackImage:maxImg forState:UIControlStateNormal];
        [_volumeSlider setMinimumTrackImage:minImg forState:UIControlStateNormal];
    }
}

- (void)setTimeLabelText:(NSString *)text
{
    CGSize s = [text sizeWithFont:LABEL_TIME_FONT];
    CGRect r = _timeLabel.frame;
    r.size.width = s.width;
    r.size.height = s.height;
    [_timeLabel setFrame:r];
    [_timeLabel setText:text];
}

- (void)resetValue
{
    [self setTimeLabelText:LABEL_TIME_DEFAULT_TEXT];
    [self.progressSlider setValue:0.f];
}

#pragma mark -

@end
