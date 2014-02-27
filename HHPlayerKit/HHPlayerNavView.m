//
//  HHPlayerNavView.m
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

#import "HHPlayerNavView.h"

@interface HHPlayerNavView ()
{
    CGFloat _w;
    CGFloat _h;
}

@property (nonatomic, retain) UIImage *backNormalImage;

@property (nonatomic, retain) UIImage *backHighlightedImage;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation HHPlayerNavView

- (void)__destroyProperty
{
    self.title = nil;
    self.backNormalImage = nil;
    self.backHighlightedImage = nil;
}

- (void)__destroyVariable
{
    [_bgImgView release], _bgImgView = nil;
    [_titleLabel release], _titleLabel = nil;
    [_backButton release], _backButton = nil;
}

- (void)dealloc
{
    [self __destroyProperty];
    [self __destroyVariable];
    [super dealloc];
}

#pragma mark - Super Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_bgImgView];
        
        _backButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [self addSubview:_backButton];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:HH_LABEL_NAV_TITLE_COLOR];
        [_titleLabel setFont:HH_LABEL_NAV_TITLE_FONT];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    _w = CGRectGetWidth(self.frame);
    _h = CGRectGetHeight(self.frame);
    
    [_bgImgView setFrame:CGRectMake(0.f, 0.f, _w, _h)];
    [_backButton setFrame:CGRectMake(HH_BUTTON_BACK_L, HH_BUTTON_BACK_T,
                                     HH_BUTTON_BACK_W, HH_BUTTON_BACK_H)];
    [_backButton setImage:_backNormalImage forState:UIControlStateNormal];
    [_backButton setImage:_backHighlightedImage forState:UIControlStateHighlighted];
    
    [self __changeNavLabelTitle];
}

#pragma mark - Private Methods

- (void)__changeNavLabelTitle
{
    // why use the int data type?
    // because if the location's value like this 100.5,the text will present blur to user.
    CGSize size = [_title sizeWithFont:HH_LABEL_NAV_TITLE_FONT];
    int x = (int)(_w - size.width)/2.f;
    int y = (int)(_h - size.height)/2.f;
    CGRect frame = CGRectMake(x, y, size.width, size.height);
    [_titleLabel setFrame:frame];
    [_titleLabel setText:_title];
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title
{
    if (_title) {
        [_title release], _title = nil;
    }
    _title = [title copy];
    
    [self __changeNavLabelTitle];
}

- (void)setBackgroundImage:(UIImage *)img
{
    [_bgImgView setImage:img];
}

- (void)setBackButtonNormalImage:(UIImage *)nImg highlightedImage:(UIImage *)hImg
{
    self.backNormalImage = nImg;
    self.backHighlightedImage = hImg;
    
    [_backButton setImage:nImg forState:UIControlStateNormal];
    [_backButton setImage:hImg forState:UIControlStateHighlighted];
}

#pragma mark -

@end
