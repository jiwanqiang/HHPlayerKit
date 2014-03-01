//
//  HHPlayerBGView.m
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

#import "HHPlayerBGView.h"

#define IMAGEVIEW_W 624.f
#define IMAGEVIEW_H 235.f

#define LABEL_TITLE_L 20.f
#define LABEL_TITLE_T 40.f
#define LABEL_TITLE_FONT [UIFont systemFontOfSize:18.f]
#define LABEL_TITLE_COLOR [UIColor whiteColor]

@interface HHPlayerBGView ()
{
    UIActivityIndicatorView *_aiView;
}

@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, retain) UIImage *bgImage;

@end

@implementation HHPlayerBGView

- (void)dealloc
{
    [_bgImgView release], _bgImgView = nil;
    [_titleLabel release], _titleLabel = nil;
    
    [_title release], _title = nil;
    [_aiView release], _aiView = nil;
    [super dealloc];
}

#pragma mark - Super Methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setContentMode:UIViewContentModeRedraw];
        [self setBackgroundColor:[UIColor blackColor]];
        _bgImgView = [UIImageView new];
        [self addSubview:_bgImgView];
        _titleLabel = [UILabel new];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextColor:LABEL_TITLE_COLOR];
        [self addSubview:_titleLabel];
        
        _aiView = [UIActivityIndicatorView new];
        [_aiView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [_aiView startAnimating];
        [self addSubview:_aiView];
        
        self.isAnimation = NO;
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGFloat w = CGRectGetWidth(self.frame);
    CGFloat h = CGRectGetHeight(self.frame);
    CGFloat x = (w - IMAGEVIEW_W) / 2;
    CGFloat y = (h - IMAGEVIEW_H) / 2 - 40.f;
    
    if (self.isAnimation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5f];
    }
    
    [_bgImgView setFrame:CGRectMake(x, y, IMAGEVIEW_W, IMAGEVIEW_H)];
    [_bgImgView setImage:self.bgImage];
    CGSize size = [_title sizeWithFont:LABEL_TITLE_FONT];
    CGRect r = _aiView.frame;
    x = (w - size.width - r.size.width - LABEL_TITLE_L) / 2 + 20.f;
    y = (y + IMAGEVIEW_H - LABEL_TITLE_T);
    r.origin.x = x;
    r.origin.y = y;
    _aiView.frame = r;
    [_titleLabel setFrame:CGRectMake( x+r.size.width+LABEL_TITLE_L, y-12.f, size.width, size.height)];
    [_titleLabel setText:_title];
    
    if (self.isAnimation) {
        [UIView commitAnimations];
    }
    
    self.isAnimation = YES;
}

#pragma mark - Setter and Getter

- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        [_title release], _title = nil;
        _title = [title copy];
        self.isAnimation = NO;
        _titleLabel.hidden = NO;
        [_aiView startAnimating];
        [self setNeedsLayout];
    }
}

#pragma mark - Public Methods

- (void)startAnimatin
{
    _titleLabel.hidden = NO;
    [_aiView startAnimating];
}

- (void)stopAnimating
{
    _titleLabel.hidden = YES;
    [_aiView stopAnimating];
}

- (void)setBackgroundImage:(UIImage *)image
{
    self.bgImage = image;
}

@end
