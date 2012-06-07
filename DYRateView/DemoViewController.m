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

#import "DemoViewController.h"

@interface DemoViewController ()

- (void)setUpEditableRateView;
- (void)setUpLeftAlignedRateView;
- (void)setUpCenterAlignedRateView;
- (void)setUpRightAlignedRateView;

@end

@implementation DemoViewController

@synthesize rateLabel = _rateLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];

    [self setUpEditableRateView];
    [self setUpLeftAlignedRateView];
    [self setUpCenterAlignedRateView];
    [self setUpRightAlignedRateView];
}

- (void)setUpEditableRateView {
    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 20) fullStar:[UIImage imageNamed:@"StarFullLarge.png"] emptyStar:[UIImage imageNamed:@"StarEmptyLarge.png"]];
    rateView.padding = 20;
    rateView.alignment = RateViewAlignmentCenter;
    rateView.editable = YES;
    rateView.delegate = self;
    [self.view addSubview:rateView];
    [rateView release];

    // Set up a label view to display rate
    self.rateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 20)] autorelease];
    self.rateLabel.textAlignment = UITextAlignmentCenter;
    self.rateLabel.text = @"Tap above to rate";
    [self.view addSubview:self.rateLabel];
}

- (void)setUpLeftAlignedRateView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 140, 120, 20)];
    label.text = @"Left aligned:";
    [self.view addSubview:label];
    [label release];

    DYRateView *rateView = [[[DYRateView alloc] initWithFrame:CGRectMake(140, 140, 160, 14)] autorelease];
    rateView.rate = 4.7;
    rateView.alignment = RateViewAlignmentLeft;
    [self.view addSubview:rateView];
}

- (void)setUpCenterAlignedRateView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 120, 20)];
    label.text = @"Center aligned:";
    [self.view addSubview:label];
    [label release];

    DYRateView *rateView = [[[DYRateView alloc] initWithFrame:CGRectMake(140, 180, 160, 14)] autorelease];
    rateView.rate = 3.3;
    rateView.alignment = RateViewAlignmentCenter;
    [self.view addSubview:rateView];
}

- (void)setUpRightAlignedRateView {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 120, 20)];
    label.text = @"Right aligned:";
    [self.view addSubview:label];
    [label release];

    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(140, 220, 160, 14)];
    rateView.rate = 4;
    rateView.alignment = RateViewAlignmentRight;
    [self.view addSubview:rateView];
    [rateView release];
}

- (void)dealloc {
    [_rateLabel release]; _rateLabel = nil;
    [super dealloc];
}

#pragma mark - DYRateViewDelegate

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
    self.rateLabel.text = [NSString stringWithFormat:@"Rate: %d", rate.intValue];
}

@end