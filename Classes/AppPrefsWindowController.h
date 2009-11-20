//
//  AppPrefsWindowController.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h"

@interface AppPrefsWindowController : DBPrefsWindowController {
    IBOutlet NSView *generalPreferenceView;
    IBOutlet NSView *updatesPreferenceView;
}

@end
