//
//  HHPlayList.h
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

/**
 * HHPlayerView which contains many elements and display the media content in it.
 *
 * Example:
 *
 *   - You can use the default elements.
 *   - If you need,you can rewrite it.
 *   - In some case,you can add the other element in it.
 */

#import <Foundation/Foundation.h>

/**
 *  Play List (To-Do)
 */
@interface HHPlayList : NSObject

/**-------------------------------------------------------------------------------------------------
 *  @name Properties
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  Returns the AVPlayerItems in the PlayList.
 */
@property (nonatomic, readonly) NSArray *items;

/**
 *  Returns the index which the player's current play.
 */
@property (nonatomic, readonly) NSInteger currentPlayIndex;

/** 
 *  Returns the index which the player's next play.
 */
@property (nonatomic, readonly) NSInteger nextPlayIndex;

/**-------------------------------------------------------------------------------------------------
 *  @name Instance Methods
 * -------------------------------------------------------------------------------------------------
 */

/**
 *  Initalize the instance with the play items.
 *
 *  @param items NSArray instance which stored a lots of AVPlayerItem instance.
 *
 *  @return instance
 */
- (id)initWithItems:(NSArray *)items;

@end
