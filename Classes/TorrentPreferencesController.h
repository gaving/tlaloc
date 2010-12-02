//
//  AppPrefsWindowController.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DBPrefsWindowController.h"

@interface TorrentPreferencesController : DBPrefsWindowController {
    IBOutlet NSView *generalPreferenceView;
    IBOutlet NSView *viewPreferenceView;
    IBOutlet NSView *updatesPreferenceView;
    IBOutlet NSPopUpButton *destFolder;

    NSUserDefaults *fDefaults;
}

- (void) incompleteFolderSheetShow: (id) sender;

@end
