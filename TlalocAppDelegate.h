//
//  tlalocAppDelegate.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TlalocAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}


@property (assign) IBOutlet NSWindow *window;

@end
