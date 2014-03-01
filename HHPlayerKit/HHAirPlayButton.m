//
//  HHAirPlayButton.m
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

#import "HHAirPlayButton.h"
#import <objc/message.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

static const void *isAirplayActive = &isAirplayActive;

@interface HHAirPlayButton ()

@property (nonatomic, retain) UIButton *mpButton;

@property (nonatomic, retain) UIImage *avaiableImage;

@property (nonatomic, retain) UIImage *disabledImage;

@property (nonatomic, retain) UIImage *inuseImage;

@property (nonatomic, readonly) MPVolumeView *volumeView;

@end

#pragma mark -

@implementation HHAirPlayButton

- (void)dealloc
{
    [self.mpButton removeObserver:self forKeyPath:@"alpha"];
    self.mpButton = nil;
    [_volumeView release], _volumeView = nil;
    [super dealloc];
}

- (HHAirPlayButton *)initWithFrame:(CGRect)frame availableImage:(UIImage *)aImage disabledImage:(UIImage *)dImage inuseImage:(UIImage *)iImage
{
    self = [self initWithFrame:frame];
    if (self) {
        self.avaiableImage = aImage;
        self.disabledImage = dImage;
        self.inuseImage = iImage;
    }
    
    return self;
}

#pragma mark - Super Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _volumeFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self __buildAirPlayButton];
        [self __buildCustomVolumeView];
        [self addSubview:_airPlayButton];
        [self addSubview:_volumeView];
    }
    
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( (object == self.mpButton) && ([[change valueForKey:NSKeyValueChangeNewKey] intValue] == 1) && self) {
        [_airPlayButton setHidden:YES];
        [self __setMPButtonImage:[self __isAirPlayActive]];
        [self setIsAirplayActive:[self __isAirPlayActive]];
    } else {
        [_airPlayButton setHidden:NO];
    }
}

#pragma mark - Setter and Getter

- (void)setIsAirplayActive:(BOOL)isAirPlayActive
{
    objc_setAssociatedObject(self, isAirplayActive, [NSNumber numberWithBool:isAirPlayActive], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isAirplayActive
{
    return [objc_getAssociatedObject(self, isAirplayActive) boolValue];
}

#pragma mark - Private Methods

- (void)__buildAirPlayButton
{
    _airPlayButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_airPlayButton setUserInteractionEnabled:NO];
    [_airPlayButton setAdjustsImageWhenDisabled:YES];
    [_airPlayButton setEnabled:NO];
    [_airPlayButton setFrame:_volumeFrame];
    [_airPlayButton setImage:self.disabledImage forState:UIControlStateDisabled];
}

- (void)__buildCustomVolumeView
{
    CGRect frame = CGRectMake(_volumeFrame.origin.x - 7.f, _volumeFrame.origin.y - 2.f, _volumeFrame.size.width, _volumeFrame.size.height);
    _volumeView = [[MPVolumeView alloc] initWithFrame:frame];
    [_volumeView setShowsVolumeSlider:NO];
    
    for (id temp in _volumeView.subviews) {
        if (![temp isKindOfClass:[UIButton class]]) continue;
        
        self.mpButton = (UIButton*)temp;
        [self.mpButton setAdjustsImageWhenHighlighted:NO];
        [self.mpButton setShowsTouchWhenHighlighted:NO];
        [self.mpButton setFrame:_volumeFrame];
        [self.mpButton addObserver:self
                        forKeyPath:@"alpha"
                           options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                           context:nil];
        break;
    }

}

- (void)__setMPButtonImage:(BOOL)isOutPlaying
{
    UIImage *img = isOutPlaying ? self.inuseImage : self.avaiableImage;
    [self.mpButton setImage:img forState:UIControlStateNormal];
    [self.mpButton setImage:img forState:UIControlStateHighlighted];
    [self.mpButton setImage:img forState:UIControlStateSelected];
}

- (BOOL)__isAirPlayActive
{
    CFDictionaryRef currentRouteDescriptionDictionary = nil;
    UInt32 dataSize = sizeof(currentRouteDescriptionDictionary);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &currentRouteDescriptionDictionary);
    
    if (currentRouteDescriptionDictionary) {
        CFArrayRef outputs = CFDictionaryGetValue(currentRouteDescriptionDictionary, kAudioSession_AudioRouteKey_Outputs);
        if(CFArrayGetCount(outputs) > 0) {
            CFDictionaryRef currentOutput = CFArrayGetValueAtIndex(outputs, 0);
            CFStringRef outputType = CFDictionaryGetValue(currentOutput, kAudioSession_AudioRouteKey_Type);
            
            return (CFStringCompare(outputType, kAudioSessionOutputRoute_AirPlay, 0) == kCFCompareEqualTo);
        }
    }
    
    return NO;
}

@end
