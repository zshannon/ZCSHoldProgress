//
//  ViewController.m
//  ZCSHoldProgessDemo
//
//  Created by Zane Shannon on 9/3/14.
//  Copyright (c) 2014 Zane Shannon. All rights reserved.
//

#import "ViewController.h"
#import "ZCSHoldProgress.h"

@interface ViewController ()

- (void)gestureRecogizerTarget:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	ZCSHoldProgress *holdProgress = [[ZCSHoldProgress alloc] initWithTarget:self action:@selector(gestureRecogizerTarget:)];
	holdProgress.minimumPressDuration = 3.0;
	[self.view addGestureRecognizer:holdProgress];

	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
	[singleTap requireGestureRecognizerToFail:holdProgress];
	[self.view addGestureRecognizer:singleTap];
}

- (void)singleTap:(UIGestureRecognizer *)gestureRecognizer {
	NSLog(@"singleTap!");
}

- (void)gestureRecogizerTarget:(UIGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		self.backgroundImageView.highlighted = YES;
	} else if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
		self.backgroundImageView.highlighted = NO;
	}
}

@end
