//
//  ZCSHoldProgress.h
//  ZCSHoldProgessDemo
//
//  Created by Zane Shannon on 9/3/14.
//  Copyright (c) 2014 Zane Shannon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZCSHoldProgress : UILongPressGestureRecognizer

@property (nonatomic) NSTimeInterval displayDelay;
@property (nonatomic) float alpha;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIColor *completedColor;
@property (nonatomic) float borderSize;
@property (nonatomic) float size;
@property (nonatomic) BOOL hideOnComplete;

@end
