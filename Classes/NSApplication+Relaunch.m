//
//  NSApplication+Relaunch.m
//  Relaunch Demo
//
//  Created by Matt Patenaude on 4/16/09.
//  Copyright 2009 Matt Patenaude. All rights reserved.
//

#import "NSApplication+Relaunch.h"


@implementation NSApplication (Relaunch)

- (void)relaunch:(id)sender
{
	NSString *daemonPath = [[NSBundle mainBundle] pathForResource:NSApplicationRelaunchDaemon ofType:nil];
	[NSTask launchedTaskWithLaunchPath:daemonPath arguments:[NSArray arrayWithObjects:[[NSBundle mainBundle] bundlePath], [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]], nil]];
	[self terminate:sender];
}

@end
