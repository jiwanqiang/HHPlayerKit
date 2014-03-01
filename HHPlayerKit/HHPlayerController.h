//
//  HHPlayerController.h
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

#import <UIKit/UIKit.h>

@class AVPlayer;
@class HHPlayerView;

/**
 *  The HHPlayerController class is the core of the Player framework which control all the events.
 *
 *  Example:
 *
 *      - when you want the player playback the media,it will post Notification
 *
 *      - when you want the player cancel the current items,it will post Notification
 */
@interface HHPlayerController : NSObject
{
  @private
  
  @public
    AVPlayer *_player;
}

/**
 *  PlayerKit's version
 */
@property (nonatomic, readonly) NSString *version;

/**-------------------------------------------------------------------------------------------------
 *  @name UIView
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  The view in which the media and playback controls are displayed.
 */
@property (nonatomic, readonly) HHPlayerView *view;

/**-------------------------------------------------------------------------------------------------
 *  @name KVO
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  Returns the current state of the player.This property is key value observable.
 */
@property (nonatomic, readonly) BOOL isPlaying;

/**
 *  Returns the media's duration time(seconds).This property is key value observable.
 *
 *  If return value is nan,indicate this is living stream.
 */
@property (nonatomic, readonly) NSTimeInterval duration;

/**
 *  Returns the current time(seconds) that the player playback.This property is key value observable.
 */
@property (nonatomic, readonly) NSTimeInterval currentTime;

/**-------------------------------------------------------------------------------------------------
 *  @name Normal
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  Returns the current url the player used.
 */
@property (nonatomic, readonly) NSURL *currentURL;

/**
 *  Set airplay switch,default is YES.
 */
@property (nonatomic, assign) BOOL allowsAirPlay NS_AVAILABLE_IOS(5_0);

/**-------------------------------------------------------------------------------------------------
 *  @name Set Player's Resoureces
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  Set the URL which the player need.
 *
 *  @param url the video's address.
 */
- (void)setURL:(NSURL *)url;

/**-------------------------------------------------------------------------------------------------
 *  @name Player's Control
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  It told the player should playback the current item.
 */
- (void)play;

/**
 *  It told the player should playback from the seconds which you want.
 *
 *  @param seconds seconds You want the player playback from.
 */
- (void)playFromSeconds:(NSTimeInterval)seconds;

/**
 *  It told the player should pause the current item.
 */
- (void)pause;

/**
 *  It told the player should stop play.
 */
- (void)stop;

@end
