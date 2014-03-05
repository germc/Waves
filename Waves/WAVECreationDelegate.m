//
//  WAVECreationDelegate.m
//  Waves
//
//  Created by Christoffer Winterkvist on 05/03/14.
//  Copyright (c) 2014 Hyper. All rights reserved.
//

#import "WAVECreationDelegate.h"

@implementation WAVECreationDelegate

@synthesize name, url, location;

#pragma mark Interface builder actions

- (IBAction)create:(id)sender
{
	NSLog(@"name: %@", self.name);
	NSLog(@"url: %@", self.url);
	NSLog(@"location: %@", self.location);
}

#pragma mark Window Delegate

- (void)windowDidBecomeMain:(NSNotification *)notification
{
	NSLog(@"window became main");
}

@end
