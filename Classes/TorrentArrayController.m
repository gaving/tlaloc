//
//  TorrentArrayController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 21/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentArrayController.h"

@implementation TorrentArrayController

-(void)awakeFromNib {
    actionController = [TorrentActionController alloc];
}

- (IBAction)add:(id)sender {
    NSLog(@"TorrentArrayController add");
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    if ([openDlg runModalForDirectory:nil file:nil] == NSOKButton) {
        NSArray* files = [openDlg filenames];
        for(int i = 0; i < [files count]; i++ ) {
            NSString* fileName = [files objectAtIndex:i];
            NSLog(@"Fire add action with: %@", fileName);
            if ([actionController addTorrent:fileName]) {
                // [super add:sender];
            }
        }
    }
}

- (IBAction)remove:(id)sender {
    NSLog(@"TorrentArrayController remove");
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Are you sure you wish to delete the torrent?"];
    [alert setInformativeText:@"This action cannot be undone."];
    [alert setAlertStyle:NSWarningAlertStyle];
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        Torrent *torrent = [[self selectedObjects] objectAtIndex:0];
        if ([actionController removeTorrent:torrent]) {
            [super remove:sender];
        }
    }
}

- (void) dealloc {
    [actionController release];
    [super dealloc];
}

@end
