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
	holdProgress.allowableMovement = 1000.0; // Move as much as you want
	[self.view addGestureRecognizer:holdProgress];
}

- (void)gestureRecogizerTarget:(UIGestureRecognizer *)gestureRecognizer {
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
		self.backgroundImageView.highlighted = YES;
	} else if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
		self.backgroundImageView.highlighted = NO;
	}
}

@end
