//
//  HHPlayerControlView.h
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

/**
 *  Control View of the Player, such as play/pause/speed/reverse/volume and so on.
 */
@interface HHPlayerControlView : UIView
{
  @private
    UIImageView *_bgImageView;
}

/**
 *  When is playing the button's selected is no.
 *
 *  Default show the pause image
 */
@property (nonatomic, readonly) UIButton *playPauseButton;

/**
 *  Returns a button which show zoom in and zoom out.
 */
@property (nonatomic, readonly) UIButton *scaleButton;

/**
 *  Returns a slider which indicates the media's playback progress.
 */
@property (nonatomic, readonly) UISlider *progressSlider;

/**
 *  Returns a imageview which indicates the volume's state.
 */
@property (nonatomic, readonly) UIImageView *volumeIndicateView;

/**
 *  Returns a slider which indicates the volume's value.
 */
@property (nonatomic, readonly) UISlider *volumeSlider;

/**
 *  Returns a label which indicates the time's value.
 */
@property (nonatomic, readonly) UILabel *timeLabel;

/**
 *  init method
 *
 *  @param frame the frame of the control view
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  Set the control view's background.
 *
 *  @param image background image
 */
- (void)setBackgroundImage:(UIImage *)image;

////////////////////////////////////////////////////////////////////////////////////////////////////
/**-------------------------------------------------------------------------------------------------
 *  @name Sets the control tab's control's style.
 * -------------------------------------------------------------------------------------------------
 */
////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  Set the play or pause button's image.
 *
 *  @param playImg  show it when the media pause.
 *  @param pauseImg show it when is playing.
 */
- (void)setPlayImage:(UIImage *)playImg pauseImage:(UIImage *)pauseImg;

/**
 *  Set the zoom in button's image.
 *
 *  @param nImg normal image
 *  @param hImg highlighted image
 */
- (void)setZoomInNormalImage:(UIImage *)nImg highlightedImage:(UIImage *)hImg;

/**
 *  Set the zoom out button's image.
 *
 *  @param nImg normal image
 *  @param hImg highlighted image
 */
- (void)setZoomOutNormalImage:(UIImage *)nImg highlightedImage:(UIImage *)hImg;

/**
 *  Set the progress's style.
 *
 *  @param maxImg The progress slider's style of max value.
 *  @param minImg The progress slider's style of min value.
 *  @param tImg   The thumb style of progress slider.
 */
- (void)setProgressMaxImage:(UIImage *)maxImg minImage:(UIImage *)minImg thumbImage:(UIImage *)tImg;

/**
 *  Set the volume view's style
 *
 *  @param hImg    high style
 *  @param mImg    middle style
 *  @param lImg    low style
 *  @param muteImg mute style
 */
- (void)setVolumeHighImage:(UIImage *)hImg middleImage:(UIImage *)mImg lowImage:(UIImage *)lImg muteImage:(UIImage *)muteImg;

/**
 *  Set the volume's value style
 *
 *  @param maxImg max value
 *  @param minImg min value
 *  @param tImg   thumb style
 */
- (void)setVolumeMaxImage:(UIImage *)maxImg minImage:(UIImage *)minImg thumbImage:(UIImage *)tImg;

/**
 *  Set the time label's text
 *
 *  @param text  the content of the time label which you want display.
 */
- (void)setTimeLabelText:(NSString *)text;

/**
 *  Resets the value to default value.
 */
- (void)resetValue;

@end
