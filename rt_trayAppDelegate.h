//
//  rt_trayAppDelegate.h
//  rt-tray
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009 SPSA. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface rt_trayAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
