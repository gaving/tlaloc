//
//  TorrentListController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentListController.h"
#import "TorrentActionController.h"
#import "Config.h"
#import "Torrent.h"
#import "ImageTextCell.h"

@implementation TorrentListController

NSPredicate *predicateTemplate;

- (id) init {
    if (self = [super init]) {
        if ([self grabTorrents]) {
            torrents  = [[NSMutableArray alloc] init];
            [self buildTorrents];
            actionController = [TorrentActionController alloc];
        } else {
            NSAlert* alert = [NSAlert new];
            [alert setInformativeText: @"Couldn't connect fetch torrents"];
            [alert setMessageText: @"Please check your connection settings"];
            [alert runModal];
        }
    }
    return self;
}

-(void)awakeFromNib {

    NSTableColumn* column = [[tableView tableColumns] objectAtIndex:0];
    ImageTextCell* cell = [[[ImageTextCell alloc] init] autorelease];
    [column setDataCell: cell];

    [cell setPrimaryTextKeyPath: @"filename"];
    [cell setSecondaryTextKeyPath: @"remainingString"];
    [cell setTypeIconKeyPath: @"typeIcon"];
    [cell setRatioIconKeyPath: @"ratioIcon"];

    predicateTemplate = [[NSPredicate predicateWithFormat:@"(filename contains[cd] $searchString)"] retain];
}

- (NSArray*) torrents {
        return torrents;
}

- (void)buildTorrents {
    torrents = [[Config instance] torrents];
}

- (BOOL)grabTorrents {
    return ([Torrent loadAll] == YES);
}

#pragma mark -
#pragma mark Toolbar actions

- (IBAction)refreshTorrents:(id)sender {
    if ([self grabTorrents]) {
        [torrents release];
        torrents  = [[NSMutableArray alloc] init];
        [self buildTorrents];
        [tableView reloadData];
    }
}

- (IBAction)addTorrent:(id)sender {
    NSLog(@"Open up the add dialog!");
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    if ([openDlg runModalForDirectory:nil file:nil] == NSOKButton ) {
        NSArray* files = [openDlg filenames];
        for(int i = 0; i < [files count]; i++ ) {
            NSString* fileName = [files objectAtIndex:i];
            NSLog(@"Do something with: %@", fileName);
        }
    }
}

- (IBAction)removeTorrent:(id)sender {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Are you sure you wish to delete the torrent?"];
    [alert setInformativeText:@"This action cannot be undone."];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[tableView window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertFirstButtonReturn) {
        NSLog(@"Find the currently selected torrent and remove it");
        NSLog(@"Call the torrent action controller");
        int rowIndex = [tableView selectedRow];
        NSLog(@"This is the hash: %@", [[torrents objectAtIndex:rowIndex] hash]);
        [actionController removeTorrent:[torrents objectAtIndex:rowIndex]];
    }
}

- (IBAction)filterTorrent:(id)sender {
    NSString *searchString = [searchField stringValue];
    NSPredicate *predicate;

    if ([searchString isEqualToString:@""]) {
        predicate = nil;
    } else {
        NSMutableDictionary *bindVariables = [[NSMutableDictionary alloc] init];
        [bindVariables setObject:searchString forKey:@"searchString"];
        predicate = [predicateTemplate predicateWithSubstitutionVariables:bindVariables];
    }

    [arrayTorrents setFilterPredicate:predicate];
}

- (IBAction)infoTorrent:(id)sender {
    NSLog(@"Show the torrent info");
}

- (IBAction)preferences:(id)sender {
    NSLog(@"Show the preferences dialog");
}

@end
