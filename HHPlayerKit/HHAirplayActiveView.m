//
//  AirplayActiveView.m
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

#import "HHAirplayActiveView.h"

#define IMAGEVIEW_LOGO_X  0.f
#define IMAGEVIEW_LOGO_Y  0.f
#define IMAGEVIEW_LOGO_W  213.f
#define IMAGEVIEW_LOGO_H  174.f
#define IMAGEVIEW_LOGO_FW 320.f
#define IMAGEVIEW_LOGO_FH 261.f

#define LABEL_INDI_T  16.f
#define LABEL_FONT_F  [UIFont systemFontOfSize:20.f] //full screen
#define LABEL_FONT_N  [UIFont systemFontOfSize:16.f] //normal screen

@interface HHAirplayActiveView ()
{
    CGFloat _w;
    CGFloat _h;
    BOOL _isAnimation;
}

@property (nonatomic, copy) NSString *indicatorTitle;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, retain) UIImageView *bgImgView;

@end

@implementation HHAirplayActiveView

- (void)dealloc
{
    self.indicatorTitle = nil;
    self.titleLabel = nil;
    self.bgImgView = nil;
    [super dealloc];
}

#pragma mark - Super Methods

- (id)initWithFrame:(CGRect)frame indicatorTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        _isAnimation = NO;
        self.indicatorTitle = title;
        
        [self setContentMode:UIViewContentModeRedraw];
        self.BackgroundColor = [UIColor colorWithRed:99/255.f green:99/255.f blue:99/255.f alpha:1.f];
        _bgImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_bgImgView setImage:[UIImage imageNamed:@"mp_ap_ind.png"]];
        [self addSubview:_bgImgView];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        _titleLabel.textColor = [UIColor colorWithRed:49/255.f green:49/255.f blue:49/255.f alpha:1.f];
        [_titleLabel setText:title];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    _w = CGRectGetWidth(self.frame);
    _h = CGRectGetHeight(self.frame);
    
    CGFloat x = 0.f;
    CGFloat y = 0.f;
    CGRect frame = CGRectZero;
    CGSize size = CGSizeZero;
    
    if (_isAnimation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5f];
    }
    
    if (_w == [UIScreen mainScreen].bounds.size.height) {
        size = [_indicatorTitle sizeWithFont:LABEL_FONT_F];
        
        x = (_w - IMAGEVIEW_LOGO_FW) / 2;
        y = (_h - IMAGEVIEW_LOGO_FH - LABEL_INDI_T - size.height) / 2;
        frame = CGRectMake(x, y, IMAGEVIEW_LOGO_FW, IMAGEVIEW_LOGO_FH);
        [_bgImgView setFrame:frame];
        
        x = (int)((_w - size.width) / 2);
        y = y + IMAGEVIEW_LOGO_FH + LABEL_INDI_T;
        frame = CGRectMake(x, y, size.width, size.height);
        [_titleLabel setFont:LABEL_FONT_F];
        [_titleLabel setFrame:frame];
    } else {
        size = [_indicatorTitle sizeWithFont:LABEL_FONT_N];
        
        x = (_w - IMAGEVIEW_LOGO_W) / 2;
        y = (_h - IMAGEVIEW_LOGO_H - LABEL_INDI_T - size.height) / 2;
        frame = CGRectMake(x, y, IMAGEVIEW_LOGO_W, IMAGEVIEW_LOGO_H);
        [_bgImgView setFrame:frame];
        
        x = (int)((_w - size.width) / 2);
        y = y + IMAGEVIEW_LOGO_H + LABEL_INDI_T;
        frame = CGRectMake(x, y, size.width, size.height);
        [_titleLabel setFont:LABEL_FONT_N];
        [_titleLabel setFrame:frame];
    }
    
    if (_isAnimation) {
        [UIView commitAnimations];
    }
    
    _isAnimation = YES;
}

@end
