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

        /* Report the error if something happened */
    }
}

@end
