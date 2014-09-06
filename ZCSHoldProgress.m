//
//  ZCSHoldProgress.m
//  ZCSHoldProgessDemo
//
//  Created by Zane Shannon on 9/3/14.
//  Copyright (c) 2014 Zane Shannon. All rights reserved.
//

#import "ZCSHoldProgress.h"

@interface ZCSHoldProgress ()

@property (nonatomic, readwrite) UIGestureRecognizerState state;
@property (strong, nonatomic) id myTarget;
@property SEL myAction;
@property (strong, nonatomic) NSTimer *progressTimer;
@property (strong, nonatomic) NSDate *startDate;
@property BOOL should_trigger;
@property BOOL is_triggered;
@property (strong, nonatomic) UIView *progressView;
@property (strong, nonatomic) CALayer *progressLayer;
@property (nonatomic) CGPoint startingPoint;
@property (copy, nonatomic) NSSet *lastTouches;

- (void)setDefaultValues;
- (void)handleTimer:(NSTimer *)timer;
- (void)setup;
- (void)tearDown;
- (void)setupProgressView;
- (void)updateProgressLayer:(CGFloat)progress;
- (void)tearDownProgressView;

@end

@implementation ZCSHoldProgress

@synthesize state;

- (id)initWithTarget:(id)target action:(SEL)action {
	self = [super initWithTarget:target action:action];
	if (self != nil) {
		self.myTarget = target;
		self.myAction = action;
		self.should_trigger = NO;
		self.is_triggered = NO;
		[self setDefaultValues];
	}
	return self;
}

- (void)setDefaultValues {
	self.displayDelay = 0.25f;
	self.alpha = 0.75f;
	self.color = [UIColor blackColor];
	self.completedColor = [UIColor greenColor];
	self.borderSize = 3.0f;
	self.size = 200.0f;
	self.minimumSize = 60.0f;
	self.hideOnComplete = YES;
}

- (void)handleTimer:(NSTimer *)timer {
	NSTimeInterval timerElapsed = [[NSDate new] timeIntervalSinceDate:self.startDate];
	self.should_trigger = timerElapsed >= self.minimumPressDuration;
	if (timerElapsed >= self.displayDelay && self.progressView == nil) {
		[self setupProgressView];
	}
	if (self.should_trigger && !self.is_triggered) {
		self.is_triggered = YES;
		self.state = UIGestureRecognizerStateBegan;
		[self.myTarget performSelector:self.myAction withObject:self afterDelay:0.0];
	}
	[self updateProgressLayer:(timerElapsed / self.minimumPressDuration)];
}

- (void)setup {
	if (self.progressTimer == nil) {
		self.progressTimer =
			[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
		self.startDate = [NSDate new];
	}
}

- (void)tearDown {
	[self.progressTimer invalidate];
	self.progressTimer = nil;
	[self tearDownProgressView];
	self.should_trigger = NO;
	self.is_triggered = NO;
	[self.myTarget performSelector:self.myAction withObject:self afterDelay:0.0];
}

- (void)setupProgressView {
	self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size, self.size)];
	UITouch *touch = (UITouch *)[self.lastTouches anyObject];
	UIView *view = nil;
	for (UIGestureRecognizer *recognizer in touch.gestureRecognizers) {
		if ([recognizer isEqual:self]) {
			view = recognizer.view;
			break;
		}
	}
	CGPoint center = [touch locationInView:view];
	self.progressView.center = center;
	self.progressView.alpha = self.alpha;
	self.progressView.layer.borderColor = self.color.CGColor;
	self.progressView.layer.borderWidth = self.borderSize;
	self.progressView.layer.cornerRadius = self.size / 2.0f;
	self.progressLayer = [[CALayer alloc] init];
	self.progressLayer.frame = CGRectZero;
	self.progressLayer.backgroundColor = self.color.CGColor;
	self.progressLayer.cornerRadius = self.size / 2.0f;
	[self.progressView.layer addSublayer:self.progressLayer];
	[self.view addSubview:self.progressView];
}

- (void)updateProgressLayer:(CGFloat)progress {
	if (progress > 1.0) {
		self.progressLayer.backgroundColor = self.completedColor.CGColor;
		self.progressView.layer.borderColor = self.completedColor.CGColor;
		self.progressView.hidden = self.hideOnComplete;
		return;
	}
	CGFloat size = self.size * progress;
	if (size < self.minimumSize) size = self.minimumSize;
	CGFloat center = (self.size / 2.0f) - (size / 2.0f);
	self.progressLayer.cornerRadius = size / 2.0f;
	self.progressLayer.frame = CGRectMake(center, center, size, size);
}

- (void)tearDownProgressView {
	if (self.progressView == nil) return;
	[self.progressView removeFromSuperview];
	self.progressView = nil;
}

#pragma mark - UIGestureRecognizer Subclass Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = (UITouch *)[touches anyObject];
	UIView *view = nil;
	for (UIGestureRecognizer *recognizer in touch.gestureRecognizers) {
		if ([recognizer isEqual:self]) {
			view = recognizer.view;
			break;
		}
	}
	self.startingPoint = [touch locationInView:view];
	self.lastTouches = touches;
	[self setup];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	self.lastTouches = touches;
	if (self.progressTimer != nil) {
		self.state = UIGestureRecognizerStatePossible;
		[self tearDown];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	self.lastTouches = touches;
	if (self.progressTimer != nil) {
		if (!self.is_triggered) {
			self.enabled = NO;
			self.enabled = YES;
		}
		self.state = UIGestureRecognizerStatePossible;
		[self tearDown];
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = (UITouch *)[touches anyObject];
	UIView *view = nil;
	for (UIGestureRecognizer *recognizer in touch.gestureRecognizers) {
		if ([recognizer isEqual:self]) {
			view = recognizer.view;
			break;
		}
	}
	self.lastTouches = touches;
	if (self.progressView != nil) {
		self.state = UIGestureRecognizerStateChanged;
		CGPoint center = [touch locationInView:view];
		if (!isnan(center.x) && !isnan(center.y)) self.progressView.center = center;
	}
	CGPoint lastCenter = [touch locationInView:view];
	CGFloat xDist = (lastCenter.x - self.startingPoint.x);
	CGFloat yDist = (lastCenter.y - self.startingPoint.y);
	CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
	if (distance >= self.allowableMovement) {
		self.enabled = NO;
		self.enabled = YES;
		self.state = UIGestureRecognizerStatePossible;
		[self tearDown];
	}
}

@end
