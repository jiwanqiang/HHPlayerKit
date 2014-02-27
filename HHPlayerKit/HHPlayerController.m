//
//  HHPlayerController.m
//
//  Copyright (c) 2013 Ji Wanqiang
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

#import "HHPlayerController.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/message.h>

#import "HHPlayerView.h"
#import "HHPlayerKeys.h"
#import "HHPlayerNotification.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

static const void *isPlayingKey   = &isPlayingKey;
static const void *durationKey    = &durationKey;
static const void *currentTimeKey = &currentTimeKey;

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface HHPlayerController ()
{
    CMTime _seekTime;
    BOOL _hadStop;
}

@property (nonatomic, retain) AVURLAsset *curAsset;

@property (nonatomic, retain) AVPlayerItem *curItem;

@property (nonatomic, retain) AVPlayer *player;

@property (nonatomic, retain) id timeObserver;

@property (nonatomic, assign) BOOL isManualPause;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HHPlayerController

- (void)__destroyProperty
{
    self.curAsset = nil;
    
    [self.player removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    
    [self.curItem removeObserver:self forKeyPath:kItemStatus];
    self.curItem = nil;
    
    [self.player removeObserver:self forKeyPath:kPlayerCurrentItem];
    [self.player removeObserver:self forKeyPath:kPlayerRate];
    self.player = nil;
}

- (void)__destroyVariable
{
    [_view release], _view = nil;
    [_currentURL release], _currentURL = nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self __destroyProperty];
    [self __destroyVariable];
    
    [super dealloc];
}


#pragma mark - Super Methods

- (id)init
{
    self = [super init];
    if (self) {
        _seekTime = kCMTimeInvalid;
        [self __initalize];
    }
    
    return self;
}

#pragma mark - Setter and Getter

- (NSString *)version
{
    return @"0.1";
}

- (void)setIsPlaying:(BOOL)isPlaying
{
    objc_setAssociatedObject(self, isPlayingKey, [NSNumber numberWithBool:isPlaying], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)isPlaying
{
    return [objc_getAssociatedObject(self, isPlayingKey) boolValue];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    objc_setAssociatedObject(self, currentTimeKey, [NSNumber numberWithFloat:currentTime], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)currentTime
{
    return [objc_getAssociatedObject(self, currentTimeKey) floatValue];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setDuration:(NSTimeInterval)duration
{
    objc_setAssociatedObject(self, durationKey, [NSNumber numberWithFloat:duration], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)duration
{
    return [objc_getAssociatedObject(self, durationKey) floatValue];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setAllowsAirPlay:(BOOL)allowsAirPlay
{
    _allowsAirPlay = allowsAirPlay;
    [self __initalizeAirPlay];
}

#pragma mark - Private Methods

- (void)__initAVPlayerWithItem:(AVPlayerItem *)item
{
    self.player = [AVPlayer playerWithPlayerItem:item];
    
    self.allowsAirPlay = YES;
    [self __initalizeAirPlay];
    
    objc_msgSend(_view, @selector(__setPlayer:), _player);
    /* Observe the AVPlayer "currentItem" property to find out when any
     AVPlayer replaceCurrentItemWithPlayerItem: replacement will/did
     occur.*/
    [self.player addObserver:self
                  forKeyPath:kPlayerCurrentItem
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:HHPlayerCurrentItemObservationContext];
    
    /* Observe the AVPlayer "rate" property to update . */
    [self.player addObserver:self
                  forKeyPath:kPlayerRate
                     options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                     context:HHPlayerRateObservationContext];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:NULL];
    
    [self __initTimeObserver];
}
- (void)__initPlayerView
{
    _view = [[HHPlayerView alloc] initWithFrame:CGRectZero];

    objc_msgSend(_view, @selector(__setPlayer:), _player);
}

- (void)__initTimeObserver
{
    if (CMTIME_IS_INVALID(self.curItem.duration) || !(self.duration >= 0.f)) {
        return;
    }
    
    double interval = .1f;
    CMTime cInterval = CMTimeMakeWithSeconds(interval, NSEC_PER_SEC);
    __block typeof(self) bself = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:cInterval
                                                                  queue:NULL
                                                             usingBlock:^(CMTime time) {
                             NSTimeInterval tI = CMTimeGetSeconds(time);
                             [bself setCurrentTime:tI];
                         }];

}

- (void)__initalizeAirPlay
{
    //5.0 - 6.0 API
    if ([self.player respondsToSelector:@selector(setAllowsAirPlayVideo:)]) {
        [self.player setAllowsAirPlayVideo:_allowsAirPlay];
        [self.player setUsesAirPlayVideoWhileAirPlayScreenIsActive:_allowsAirPlay];
    }
    
    //6.0 API
    if ([self.player respondsToSelector:@selector(setAllowsExternalPlayback:)]) {
        [self.player setAllowsExternalPlayback:_allowsAirPlay];
        [self.player setUsesExternalPlaybackWhileExternalScreenIsActive:_allowsAirPlay];
    }
}

- (void)__initalize
{
    [self __initAVPlayerWithItem:nil];
    [self __initPlayerView];
}

- (NSError *)__generateErrorWithDescription:(NSString *)desc reason:(NSString *)reason code:(NSInteger)errorCode
{
    NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               desc, NSLocalizedDescriptionKey,
                               reason, NSLocalizedFailureReasonErrorKey,
                               nil];
    return [NSError errorWithDomain:HHErrorDomain code:errorCode userInfo:errorDict];
}

- (BOOL)__verifyStateLoadAsset:(AVURLAsset *)asset withKeys:(NSArray *)keys
{
    for (NSString *key in keys) {
        NSError *error;
        AVKeyValueStatus status = [asset statusOfValueForKey:key error:&error];
        
        switch (status) {
            case AVKeyValueStatusFailed: {
                [self __assetFailedToPrepareForPlayback:error];
                return NO;
            }
            case AVKeyValueStatusCancelled: {
                NSString *failureDescription = @"Cancel Loading Data.";
                NSString *failureReason = @"The asset load had cancelled.";
                error = [self __generateErrorWithDescription:failureDescription
                                                      reason:failureReason
                                                        code:kHHErrorCancelLoadingCode];
                [self __assetFailedToPrepareForPlayback:error];
                return NO;
            }
            case AVKeyValueStatusLoaded: {
                if (_hadStop) {
                    return NO;
                }
            }
            case AVKeyValueStatusLoading: {
                
            }
        }
    }
    return YES;
}

- (BOOL)__verifyPlayableAsset:(AVURLAsset *)asset
{
    if (asset.playable) {
        return YES;
    }
    
    NSString *failureDescription = @"Item cannot played.";
    NSString *failureReason = @"The assets tracks were loaded, but could not be made playable.";
    NSError *error = [self __generateErrorWithDescription:failureDescription
                                                   reason:failureReason
                                                     code:kHHErrorUnavailableCode];
    [self __assetFailedToPrepareForPlayback:error];
    return NO;
}

- (BOOL)__verifyPlayerAvaliableWithItem:(AVPlayerItem *)item
{
    if (!self.player) {
        [self __initAVPlayerWithItem:item];
        return NO;
    }
    
    return YES;
}

- (void)__prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)keys
{
    if ([self __verifyStateLoadAsset:asset withKeys:keys]) {
        if (self.curItem) {
            [self.curItem removeObserver:self forKeyPath:kItemStatus];
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:AVPlayerItemDidPlayToEndTimeNotification
                                                          object:self.curItem];
        }
        
        self.curItem = [AVPlayerItem playerItemWithAsset:asset];
        
        /* Observe the player item "status" key to determine when it is ready to play. */
        [self.curItem addObserver:self
                       forKeyPath:kItemStatus
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:HHPlayerStatusObservationContext];
        [self.curItem addObserver:self
                       forKeyPath:kItemBufferEmpty
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:HHPlayerStatusObservationContext];
        
        // When the player item has played to its end time we'll post the notification to the
        // viewcontroller.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(__syncPlaybackFinishItem:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.curItem];
        [self __verifyPlayerAvaliableWithItem:self.curItem];
        
        if (self.player.currentItem != self.curItem) {
            [self.player replaceCurrentItemWithPlayerItem:self.curItem];
            if (CMTIME_IS_VALID(_seekTime)) {
                [_player seekToTime:_seekTime];
                _seekTime = kCMTimeInvalid;
            }
        }
    }
}

#pragma mark - Post Notification

- (void)__assetFailedToPrepareForPlayback:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerLoadFailedNotification object:error];
}

- (void)__syncPlaybackStartItem:(AVPlayerItem *)item
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerPlaybackStartNotification object:item];
}

- (void)__syncPlaybackFinishItem:(AVPlayerItem *)item
{
    [self setIsPlaying:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerPlaybackFinishNotification object:item];
}

#pragma mark - Public Methods

- (void)setURL:(NSURL *)url
{
    if (_currentURL != url) {
        if (url) {
            _hadStop = NO;
        }
        
        [_currentURL release], _currentURL = nil;
        _currentURL = [url copy];
        
        [self.curAsset cancelLoading];
        [self.curItem.asset cancelLoading];
        [_player replaceCurrentItemWithPlayerItem:nil];
        
        AVURLAsset *curAsset = [AVURLAsset URLAssetWithURL:_currentURL options:nil];
        NSArray *keys = [NSArray arrayWithObjects:kAssetTracks, kAssetPlayable, nil];
        
        __block typeof(self) bself = self;
        [curAsset loadValuesAsynchronouslyForKeys:keys completionHandler:^ {
             if (!_hadStop) {
                 dispatch_async(dispatch_get_main_queue(), ^ {
                                    [bself __prepareToPlayAsset:curAsset withKeys:keys];
                                });
             }
         }];
        self.curAsset = curAsset;
    }
}

- (void)play
{
    [self.player play];
}

- (void)pause
{
    self.isManualPause = YES;
    [self.player pause];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerPlaybackPauseNotificaion object:self.curItem];
}

- (void)stop
{
    _hadStop = YES;
    [self.curAsset cancelLoading];
    [self.player pause];
    [self.curItem.asset cancelLoading];
    self.curItem = nil;
    [self.player replaceCurrentItemWithPlayerItem:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kPlayerPlaybackStopNotificaion object:self.curItem];
}

- (void)playFromSeconds:(NSTimeInterval)seconds
{
    CMTime cTime = CMTimeMakeWithSeconds(seconds, NSEC_PER_SEC);
    if (self.curItem) {
        [self.player seekToTime:cTime];
    } else {
        _seekTime = cTime;
    }
}

- (void)observeValueForKeyPath:(NSString *)path ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == HHPlayerStatusObservationContext) {
        if ([path isEqualToString:kItemStatus]) {
            AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
            
            switch (status) {
                case AVPlayerStatusUnknown:
                    break;
                case AVPlayerStatusReadyToPlay: {
                    [_player play];
                    AVPlayerItem *playerItem = (AVPlayerItem *)object;
                    CMTime time = playerItem.duration;
                    [self setDuration:time.value/(time.timescale*1.f)];
                    [self __syncPlaybackStartItem:self.curItem];
                    [self __initTimeObserver];
                }
                    break;
                case AVPlayerStatusFailed: {
                    AVPlayerItem *playerItem = (AVPlayerItem *)object;
                    [self __assetFailedToPrepareForPlayback:playerItem.error];
                }
                    break;
            }
        } else if ([path isEqualToString:kItemBufferEmpty]) {
            [self setIsPlaying:!self.curItem.playbackBufferEmpty];
        }
    } else if (context == HHPlayerRateObservationContext) {
        float rate = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
        [self setIsPlaying:!(rate == 0.f)];
    }
}

#pragma mark -

@end

#pragma clang diagnostic pop
