//
//  AppPrefsWindowController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentPreferencesController.h"

#define DOWNLOAD_FOLDER     0
#define DOWNLOAD_TORRENT    2

@implementation TorrentPreferencesController

- (id) init {
    if ((self = [super init])) {
        fDefaults = [NSUserDefaults standardUserDefaults];
    }

    return self;
}

- (void) awakeFromNib {
}

- (void)setupToolbar {
    [self addView:generalPreferenceView label:@"General"];
    [self addView:updatesPreferenceView label:@"Updates"];
}

- (void) incompleteFolderSheetShow: (id) sender {
    NSOpenPanel * panel = [NSOpenPanel openPanel];

    [panel setPrompt: @"Select"];
    [panel setAllowsMultipleSelection: NO];
    [panel setCanChooseFiles: NO];
    [panel setCanChooseDirectories: YES];
    [panel setCanCreateDirectories: YES];

    [panel beginSheetForDirectory: nil file: nil types: nil
                   modalForWindow: [self window] modalDelegate: self didEndSelector:
     @selector(incompleteFolderSheetClosed:returnCode:contextInfo:) contextInfo: nil];
}

- (void) incompleteFolderSheetClosed: (NSOpenPanel *) openPanel returnCode: (int) code contextInfo: (void *) info {
    if (code == NSOKButton) {
        NSString * folder = [[openPanel filenames] objectAtIndex: 0];
        NSLog(@"%@", folder);
        [fDefaults setObject:folder forKey:@"torrentDestination"];
        [fDefaults synchronize];
       
        NSString *torrentDestination = [fDefaults stringForKey:@"torrentDestination"];
        NSLog(@"%@", torrentDestination);
        NSLog(@"______");

    }
    [destFolder selectItemAtIndex: 0];
}


@end
