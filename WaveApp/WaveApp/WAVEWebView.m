//
//  WAVEWebView.m
//  WaveApp
//
//  Created by Christoffer Winterkvist on 14/03/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "WAVEWebView.h"

static const CGFloat kSwipeMinimumLength = 0.3;

static NSString * const kEnableSwipe = @"AppleEnableSwipeNavigateWithScrolls";

@interface WAVEWebView ()

@property (nonatomic, strong) NSMutableDictionary *gestures;

@end

@implementation WAVEWebView

- (void)awakeFromNib
{
    [self setWantsLayer:YES];
	[self setShouldCloseWithWindow:NO];
}

#pragma mark View

- (BOOL)acceptsFirstResponder
{
	return YES;
}

- (BOOL)canDrawSubviewsIntoLayer {
    return YES;
}

#pragma mark Event handlers

- (BOOL)twoFingerGestures
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kEnableSwipe];
}

- (void)beginGestureWithEvent:(NSEvent *)event
{
    if (![self twoFingerGestures]) {
    	return;
    }

	NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseAny inView:nil];

    self.gestures = [[NSMutableDictionary alloc] init];

    for (NSTouch *touch in touches) {
    	[self.gestures setObject:touch forKey:touch.identity];
    }
}

- (void)endGestureWithEvent:(NSEvent *)event
{
    BOOL naturalDirectionEnabled = [[[NSUserDefaults standardUserDefaults] valueForKey:@"com.apple.swipescrolldirection"] boolValue];

	if (![self twoFingerGestures]) {
    	return;
    }

    NSSet *touches = [event touchesMatchingPhase:NSTouchPhaseAny inView:nil];
    NSMutableDictionary *beginTouches = [self.gestures copy];
    NSMutableArray *magnitudes = [[NSMutableArray alloc] init];
    self.gestures = nil;

	for (NSTouch *touch in touches) {
    	NSTouch *beginTouch = [beginTouches objectForKey:touch.identity];

    	if (!beginTouch) {
    		continue;
    	}

    	float magnitude = touch.normalizedPosition.x - beginTouch.normalizedPosition.x;
    	[magnitudes addObject:[NSNumber numberWithFloat:magnitude]];
	}

	if ([magnitudes count] < 2) {
		return;
	}

	float sum = 0;

	for (NSNumber *magnitude in magnitudes) {
		sum += [magnitude floatValue];
	}

    if (naturalDirectionEnabled) {
        sum *= -1;
    }

    float absoluteSum = fabsf(sum);

    if (absoluteSum < kSwipeMinimumLength) {
    	return;
    }

    if (sum > 0) {
    	[self goBack];
    } else {
      [self goForward];
    }
}

@end
