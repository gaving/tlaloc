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
#import "AppPrefsWindowController.h"

@implementation TorrentListController

NSPredicate *predicateTemplate;

- (id) init {
    if (self = [super init]) {
        if ([self grabTorrents]) {
            torrents  = [[NSMutableArray alloc] init];
            [self buildTorrents];
        } else {
            [self showError];
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

    [tableView setTarget:self];
    [tableView setDoubleAction:@selector(openTorrent:)];
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

- (BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem {
    if ([[toolbarItem itemIdentifier] isEqualTo:@"InfoTorrent"]) {

        /* TODO: Implement this */
        return NO;
    }

    return YES;
}

- (IBAction)refreshTorrents:(id)sender {

    [progressIndicator startAnimation: self];

    if ([self grabTorrents]) {
        [torrents release];
        torrents  = [[NSMutableArray alloc] init];
        [self buildTorrents];

        /* Set the array controllers new content */
        [arrayTorrents setContent:torrents];
    } else {
        [self showError];
    }

    [progressIndicator stopAnimation: self];
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

- (IBAction)openTorrent:(id)sender {
    NSLog(@"Open the torrent");
    NSString *torrentDestination = [Config torrentDestination];

    if (torrentDestination == nil) {
        NSAlert* alert = [NSAlert new];
        [alert setInformativeText: @"No destination set in preferences"];
        [alert setMessageText: @"Please configure this in the preferences panel"];
        [alert runModal];
    } else {
        Torrent *torrent = [[arrayTorrents selectedObjects] objectAtIndex:0];
        NSString *realPath = [torrentDestination stringByAppendingPathComponent: [torrent filename]]; 
        [[NSWorkspace sharedWorkspace] openFile:realPath];
    }
}

- (IBAction)openDestination:(id)sender {
    NSLog(@"Open the volume in preferences");
    NSString *torrentDestination = [Config torrentDestination];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (torrentDestination == nil) {
        NSAlert* alert = [NSAlert new];
        [alert setInformativeText: @"Couldn't open destination"];
        [alert setMessageText: @"Please check your preferences"];
        [alert runModal];
    } else if ([fileManager fileExistsAtPath: torrentDestination] == NO) { 
        NSAlert* alert = [NSAlert new];
        [alert setInformativeText: @"Couldn't open destination"];
        [alert setMessageText: @"Path does not exist"];
        [alert runModal];
    } else {
        [[NSWorkspace sharedWorkspace] openFile:torrentDestination];
    }
}

- (IBAction)infoTorrent:(id)sender {
    NSLog(@"Show the torrent info");
}

- (IBAction)preferences:(id)sender {
    [[AppPrefsWindowController sharedPrefsWindowController] showWindow:nil];
    (void)sender;
}

- (void)showError {
    NSAlert* alert = [NSAlert new];
    [alert setInformativeText: @"Couldn't connect fetch torrents"];
    [alert setMessageText: @"Please check your connection settings"];
    [alert runModal];
}

- (void) dealloc {
    [torrents release];
    [super dealloc];
}

@end
