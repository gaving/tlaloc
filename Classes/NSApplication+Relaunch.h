//
//  NSApplication+Relaunch.h
//  Relaunch Demo
//
//  Created by Matt Patenaude on 4/16/09.
//  Copyright 2009 Matt Patenaude. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define NSApplicationRelaunchDaemon @"relaunch"


@interface NSApplication (Relaunch)

- (void)relaunch:(id)sender;

@end
