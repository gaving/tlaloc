//
//  tlalocAppDelegate.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TlalocAppDelegate.h"
#import "PFMoveApplication.h"

@implementation TlalocAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (NSWindow *)window {
    return window;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    PFMoveToApplicationsFolderIfNecessary();
}

-(BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (void) application: (NSApplication *) app openFiles: (NSArray *) filenames {
    [self openFiles: filenames];
}

- (void) openFiles: (NSArray *) filenames {
    [[NSNotificationCenter defaultCenter] postNotificationName: @"TorrentAdded" object: filenames];
}

@end
