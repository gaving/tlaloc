//
//  TorrentListController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentListController.h"
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

- (NSMutableArray*) torrents {
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
        // [tableView reloadData];
        [arrayTorrents setContent:torrents];
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
