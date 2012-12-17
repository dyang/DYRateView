/*
Copyright (C) 2012 Derek Yang. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.
* Neither the name of the author nor the names of its contributors may be used
  to endorse or promote products derived from this software without specific
  prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DYRateView.h"

static NSString *DefaultFullStarImageFilename = @"StarFull.png";
static NSString *DefaultEmptyStarImageFilename = @"StarEmpty.png";

@interface DYRateView ()

- (void)commonSetup;
- (void)handleTouchAtLocation:(CGPoint)location;
- (void)notifyDelegate;

@end

@implementation DYRateView

@synthesize rate = _rate;
@synthesize alignment = _alignment;
@synthesize padding = _padding;
@synthesize editable = _editable;
@synthesize fullStarImage = _fullStarImage;
@synthesize emptyStarImage = _emptyStarImage;
@synthesize delegate = _delegate;

- (DYRateView *)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame fullStar:[UIImage imageNamed:DefaultFullStarImageFilename] emptyStar:[UIImage imageNamed:DefaultEmptyStarImageFilename]];
}

- (DYRateView *)initWithFrame:(CGRect)frame fullStar:(UIImage *)fullStarImage emptyStar:(UIImage *)emptyStarImage {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

        _fullStarImage = [fullStarImage retain];
        _emptyStarImage = [emptyStarImage retain];
        
        [self commonSetup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        _fullStarImage = [[UIImage imageNamed:DefaultFullStarImageFilename] retain];
        _emptyStarImage = [[UIImage imageNamed:DefaultEmptyStarImageFilename] retain];

        [self commonSetup];
    }
    return self;
}

- (void)dealloc {
    [_fullStarImage release]; _fullStarImage = nil;
    [_emptyStarImage release]; _emptyStarImage = nil;
    [super dealloc];
}

- (void)commonSetup
{
    // Include the initialization code that is common to initWithFrame:
    // and initWithCoder: here.
    _padding = 4;
    _numOfStars = 5;
    self.alignment = RateViewAlignmentLeft;
    self.editable = NO;
}

- (void)drawRect:(CGRect)rect
{
    switch (_alignment) {
        case RateViewAlignmentLeft:
        {
            _origin = CGPointMake(0, 0);
            break;
        }
        case RateViewAlignmentCenter:
        {
            _origin = CGPointMake((self.bounds.size.width - _numOfStars * _fullStarImage.size.width - (_numOfStars - 1) * _padding)/2, 0);
            break;
        }
        case RateViewAlignmentRight:
        {
            _origin = CGPointMake(self.bounds.size.width - _numOfStars * _fullStarImage.size.width - (_numOfStars - 1) * _padding, 0);
            break;
        }
    }

    float x = _origin.x;
    for(int i = 0; i < _numOfStars; i++) {
        [_emptyStarImage drawAtPoint:CGPointMake(x, _origin.y)];
        x += _fullStarImage.size.width + _padding;
    }


    float floor = floorf(_rate);
    x = _origin.x;
    for (int i = 0; i < floor; i++) {
        [_fullStarImage drawAtPoint:CGPointMake(x, _origin.y)];
        x += _fullStarImage.size.width + _padding;
    }

    if (_numOfStars - floor > 0.01) {
        UIRectClip(CGRectMake(x, _origin.y, _fullStarImage.size.width * (_rate - floor), _fullStarImage.size.height));
        [_fullStarImage drawAtPoint:CGPointMake(x, _origin.y)];
    }
}

- (void)setRate:(CGFloat)rate {
    _rate = rate;
    [self setNeedsDisplay];
    [self notifyDelegate];
}

- (void)setAlignment:(RateViewAlignment)alignment
{
    _alignment = alignment;
    [self setNeedsLayout];
}

- (void)setEditable:(BOOL)editable {
    _editable = editable;
    self.userInteractionEnabled = _editable;
}

- (void)setFullStarImage:(UIImage *)fullStarImage
{
    if (fullStarImage != _fullStarImage) {
        [_fullStarImage release];
        _fullStarImage = [fullStarImage retain];
        [self setNeedsDisplay];
    }
}

- (void)setEmptyStarImage:(UIImage *)emptyStarImage
{
    if (emptyStarImage != _emptyStarImage) {
        [_emptyStarImage release];
        _emptyStarImage = [emptyStarImage retain];
        [self setNeedsDisplay];
    }
}

- (void)handleTouchAtLocation:(CGPoint)location {
    for(int i = _numOfStars - 1; i > -1; i--) {
        if (location.x > _origin.x + i * (_fullStarImage.size.width + _padding) - _padding / 2.) {
            self.rate = i + 1;
            return;
        }
    }
    self.rate = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)notifyDelegate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(rateView:changedToNewRate:)]) {
        [self.delegate performSelector:@selector(rateView:changedToNewRate:)
                            withObject:self withObject:[NSNumber numberWithFloat:self.rate]];
    }
}

@end
