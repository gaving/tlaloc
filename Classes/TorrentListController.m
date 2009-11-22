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
        [NSApp setDelegate:self];
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
    } else if ([[toolbarItem itemIdentifier] isEqualTo:@"Remove"]) {
        return [[arrayTorrents selectedObjects] count] > 0;
    }

    return YES;
}

- (IBAction)addTorrent:(id)sender {
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    NSArray* fileTypes = [NSArray arrayWithObjects: @"torrent", nil];
    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:YES];
    if ([openDlg runModalForDirectory:nil file:nil types:fileTypes] == NSOKButton) {
        NSArray* files = [openDlg filenames];
        for(int i = 0; i < [files count]; i++ ) {
            NSString* fileName = [files objectAtIndex:i];
            if (![arrayTorrents add:fileName]) {
                NSAlert* alert = [NSAlert new];
                [alert setInformativeText: @"Could not add torrent!"];
                [alert setMessageText: @"Check the torrent file you are trying to add"];
                [alert setAlertStyle: NSCriticalAlertStyle];
                [alert runModal];
                [alert release];
            }
        }
        [self refreshTorrents:self];
    }
}

- (IBAction)removeTorrent:(id)sender {
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"Cancel"];
    [alert setMessageText:@"Are you sure you wish to delete the selected torrents?"];
    [alert setInformativeText:@"This action cannot be undone."];
    [alert setAlertStyle:NSWarningAlertStyle];
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        NSArray *selectedTorrents = [arrayTorrents selectedObjects];
        for (int i = 0; i < [selectedTorrents count]; i++) {
            Torrent *torrent = [selectedTorrents objectAtIndex:i];
            [arrayTorrents remove:torrent];
        }
    }
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
        [alert release];
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
        [alert release];
    } else if ([fileManager fileExistsAtPath: torrentDestination] == NO) { 
        NSAlert* alert = [NSAlert new];
        [alert setInformativeText: @"Couldn't open destination"];
        [alert setMessageText: @"Path does not exist"];
        [alert runModal];
        [alert release];
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

- (IBAction) productWebsite:(id) sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://github.com/gaving/tlaloc/"]];
}

- (void) application: (NSApplication *) app openFiles: (NSArray *) filenames {
    [self openFiles: filenames];
}

- (void) openFiles: (NSArray *) filenames {
    NSLog(@"openFiles handling given files");
    for(int i = 0; i < [filenames count]; i++ ) {
        NSString* fileName = [filenames objectAtIndex:i];
        if (![arrayTorrents add:fileName]) {
            NSAlert* alert = [NSAlert new];
            [alert setInformativeText: @"Could not add torrent!"];
            [alert setMessageText: @"Check the torrent file you are trying to add"];
            [alert setAlertStyle: NSCriticalAlertStyle];
            [alert runModal];
            [alert release];
        }
    }
    [self refreshTorrents:self];
}

- (void)showError {
    NSAlert* alert = [NSAlert new];
    [alert setInformativeText: @"Couldn't connect fetch torrents"];
    [alert setMessageText: @"Please check your connection settings"];
    [alert runModal];
    [alert release];
}

- (void) dealloc {
    [torrents release];
    [super dealloc];
}

@end
