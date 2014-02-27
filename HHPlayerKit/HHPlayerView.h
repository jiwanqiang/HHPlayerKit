//
//  HHPlayerView.h
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

#import <UIKit/UIKit.h>

#define INDICATOR_TITLE @"提示 : 该视频已经通过AirPlay转到高清屏幕播放"

@class HHPlayerBGView;
@class HHPlayerNavView;
@class HHAirplayActiveView;
@class HHPlayerController;
@class HHPlayerControlView;
@class __MediaView;

typedef enum HHMovieScalingMode
{
    HHMovieScalingModeNone,         /**< None scaling*/
    HHMovieScalingModeAspectFit,    /**< Uniform scale until one dimension fits*/
    HHMovieScalingModeAspectFill,   /**< Uniform scale until the movie fills the visible bounds*/
                                    /**< One dimension may have clipped contents*/
    HHMovieScalingModeFill          /**< Non-uniform scale. Both render dimensions will exactly match the*/
                                    /**< visible bounds*/
} HHMovieScalingMode;

/**
 *  HHPlayerView which contains many elements and display the media content in it.
 *
 *  Example:
 *
 *      - You can use the default elements.
 *
 *      - If you need, you can overwrite it.
 *
 *      - In some case, you can add the other element in it.
 */
@interface HHPlayerView : UIView
{
  @private
    float _width;
    float _height;
  @public
    __MediaView *_mediaView;
}

/**-------------------------------------------------------------------------------------------------
 *  @name Player Settings
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  Returns the player controller which controled the media events.
 */
@property (nonatomic, readonly) HHPlayerController *playerController;

/**
 *  Determines how the content scales to fit the view. Defaults to HHMovieScalingModeAspectFit.
 */
@property (nonatomic) HHMovieScalingMode scalingMode;

/**-------------------------------------------------------------------------------------------------
 *  @name Player Screen's Elements
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  Before playback the media,the view also present to users.
 */
@property (nonatomic, retain) HHPlayerBGView *backgroundView;

/**
 *  Airplay active view.Default is hidden.
 */
@property (nonatomic, retain) HHAirplayActiveView *airplayActiveView;

/**
 *  Contains play and pause button,scrubber and volume.
 *
 *  If you need,you can set it to your own view.Default is nil.
 */
@property (nonatomic, retain) HHPlayerControlView *controlView;

/**
 *  Contains back button,title label and recommand button.
 *
 *  If you need,you can set it to your own view.Default is nil.
 */
@property (nonatomic, retain) HHPlayerNavView *navigationView;

/**
 *  Returns the value which indicate the media view whether is full screen.
 */
@property (nonatomic, readonly) BOOL isFullScreen;

/**
 *  Returns the value which indicate the media control view whether is hiddened.
 */
@property (nonatomic, readonly) BOOL isHideControl;


@property (nonatomic, readonly) NSTimeInterval controlViewHideAnimationDuration;

/**-------------------------------------------------------------------------------------------------
 *  @name Initalize
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  init method
 *
 *  @param frame frame the view's frame
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  method of become full screen
 *
 *  @param animation appoint the action whether with animation
 */
- (void)becomeFullScreenWithAnimation:(BOOL)animation;

/**
 *  method of resign full screen
 *
 *  @param animation appoint the action whether with animation
 */
- (void)resignFullScreenWithAnimation:(BOOL)animation;

/**
 *  method of hide the control view
 */
- (void)hideControlView;

/**
 *  method of show the control view
 */
- (void)showControlView;

@end
