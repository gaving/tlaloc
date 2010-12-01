//
//  TorrentListController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentListController.h"
#import "Config.h"
#import "Util.h"
#import "Torrent.h"
#import "TorrentTableCell.h"
#import "TorrentPreferencesController.h"
#import "TlalocAppDelegate.h"

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>
#import <Quartz/Quartz.h>
#include <QuickLook/QuickLook.h>

#define UPDATE_UI_SECONDS   1.5

@interface Torrent (QLPreviewItem) <QLPreviewItem>
@end

@implementation Torrent (QLPreviewItem)

- (NSURL *)previewItemURL {
    return [NSURL fileURLWithPath: [self fullPath]];
}

- (NSString *)previewItemTitle {
    return self.filename;
}

@end

@implementation TorrentListController

NSPredicate *predicateTemplate;

- (id) init {
    if (self = [super init]) {
        [NSApp setDelegate:self];
        if ([self grabTorrents]) {
            torrents  = [[NSMutableArray alloc] init];
            [self buildTorrents];
        } else {
            [self showFetchError];
        }
    }
    return self;
}

#define TorrentTableViewDragAndDropDataType @"TorrentTableViewDragAndDropDataType"
-(void)awakeFromNib {

    NSTableColumn* column = [[tableView tableColumns] objectAtIndex:0];
    TorrentTableCell* cell = [[[TorrentTableCell alloc] init] autorelease];
    [column setDataCell: cell];

    [cell setPrimaryTextKeyPath: @"filename"];
    [cell setSecondaryTextKeyPath: @"remainingString"];
    [cell setTypeIconKeyPath: @"typeIcon"];
    [cell setRatioIconKeyPath: @"ratioIcon"];

    predicateTemplate = [[NSPredicate predicateWithFormat:@"(filename contains[cd] $searchString)"] retain];

    [tableView setTarget:self];
    [tableView setDoubleAction:@selector(openTorrent:)];
    [tableView registerForDraggedTypes: [NSArray arrayWithObject:NSFilenamesPboardType] ];
    [tableView setDraggingSourceOperationMask:NSDragOperationEvery forLocal:NO];

    [mainWindow setDelegate: self];
    [mainWindow makeFirstResponder: tableView];
    [mainWindow setExcludedFromWindowsMenu: YES];

    /* Notifications */
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver: self selector: @selector(torrentFinishedDownloading:)
                    name: @"TorrentFinishedDownloading" object: nil];


    [self updateUI];

    /* Interface update timer */
    timer = [NSTimer scheduledTimerWithTimeInterval: UPDATE_UI_SECONDS target: self
                                           selector: @selector(updateUI) userInfo: nil repeats: YES];
    [[NSRunLoop currentRunLoop] addTimer: timer forMode: NSModalPanelRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer: timer forMode: NSEventTrackingRunLoopMode];

    fInfoController = [[TorrentInfoController alloc] init];
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

- (int)incompleteTorrents {
    NSArray *selectedTorrents = [self torrents];
    int complete = 0;
    for (int i = 0; i < [selectedTorrents count]; i++) {
        if ([[[selectedTorrents objectAtIndex:i] complete] intValue] == 0) {
            complete++;
        }
    }

    return complete;
}

#pragma mark -
#pragma mark Toolbar actions

- (BOOL)validateToolbarItem:(NSToolbarItem *)toolbarItem {

    if ([[toolbarItem itemIdentifier] isEqualTo:@"Remove"]) {
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
                [Util showError:@"Couldn't add torrent" withMessage: @"Please verify this file is a valid torrent file."];
            }
        }
        [self refreshTorrents:self];
    }
}

- (IBAction)copyTorrent:(id)sender {

    NSArray *selectedTorrents = [arrayTorrents selectedObjects];
    if ([selectedTorrents count] == 0) {
        return;
    }

    NSString *torrentDestination = [Config torrentDestination];
    NSMutableArray *fileNames = [NSMutableArray array];
    for (int i = 0; i < [selectedTorrents count]; i++) {
        Torrent *torrent = [selectedTorrents objectAtIndex:i];
        NSString *realPath = [torrentDestination stringByAppendingPathComponent: [torrent filename]];
        [fileNames addObject: realPath];
    }

    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
    [pb declareTypes:types owner:self];
    [pb setString: [fileNames componentsJoinedByString:@","] forType:NSStringPboardType];
}

- (IBAction)deleteFile:(id)sender {

    NSArray *selectedTorrents = [arrayTorrents selectedObjects];
    if ([selectedTorrents count] == 0) {
        return;
    }

    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"Cancel"];

    NSString* messageText;
    if ([selectedTorrents count] == 1) {
        Torrent *torrent = [selectedTorrents objectAtIndex:0];
        messageText = [NSString stringWithFormat: @"Are you sure you want to delete %@?", [torrent filename]];
    } else {
        messageText = [NSString stringWithFormat: @"Are you sure you want to delete the selected torrents (and associated files)?"];
    }

    [alert setMessageText:messageText];
    [alert setInformativeText:@"This action cannot be undone."];
    [alert setAlertStyle:NSWarningAlertStyle];
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        for (int i = 0; i < [selectedTorrents count]; i++) {
            Torrent *torrent = [selectedTorrents objectAtIndex:i];
            [arrayTorrents delete:torrent];
        }
    }
}

- (IBAction)removeTorrent:(id)sender {

    NSArray *selectedTorrents = [arrayTorrents selectedObjects];
    if ([selectedTorrents count] == 0) {
        return;
    }

    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"Yes"];
    [alert addButtonWithTitle:@"Cancel"];

    NSString* messageText;
    if ([selectedTorrents count] == 1) {
        Torrent *torrent = [selectedTorrents objectAtIndex:0];
        messageText = [NSString stringWithFormat: @"Are you sure you want to remove %@?", [torrent filename]];
    } else {
        messageText = [NSString stringWithFormat: @"Are you sure you want to remove the selected torrents?"];
    }

    [alert setMessageText:messageText];
    [alert setInformativeText:@"This action cannot be undone."];
    [alert setAlertStyle:NSWarningAlertStyle];

    if ([alert runModal] == NSAlertFirstButtonReturn) {
        for (int i = 0; i < [selectedTorrents count]; i++) {
            Torrent *torrent = [selectedTorrents objectAtIndex:i];
            [arrayTorrents remove:torrent];
        }
    }
}

- (IBAction)refreshTorrents:(id)sender {
    [progressIndicator startAnimation: self];
    [self updateTorrents];
    [progressIndicator stopAnimation: self];
}

- (IBAction)qlTorrent:(id)sender {
    [self togglePreviewPanel:self];
}

- (void)updateTorrents {

    if ([self grabTorrents]) {
        id selection = [tableView selectedRowIndexes];
        int index = [selection firstIndex];

        [torrents release];
        torrents  = [[NSMutableArray alloc] init];
        [self buildTorrents];

        /* Set the array controllers new content */
        [arrayTorrents setContent:torrents];

        if (index) {
            [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
        }
    } else {
        [self showFetchError];
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

- (IBAction)openTorrent:(id)sender {
    NSString *torrentDestination = [Config torrentDestination];

    if (torrentDestination == nil) {
        [Util showError:@"Couldn't open destination" withMessage: @"No torrent destination defined in preferences."];
    } else {
        Torrent *torrent = [[arrayTorrents selectedObjects] objectAtIndex:0];
        NSString *realPath = [torrentDestination stringByAppendingPathComponent: [torrent filename]];
        [[NSWorkspace sharedWorkspace] openFile:realPath];
    }
}

- (IBAction)openDestination:(id)sender {
    NSString *torrentDestination = [Config torrentDestination];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (torrentDestination == nil) {
         [Util showError:@"Couldn't open destination" withMessage: @"No torrent destination defined in preferences."];
    } else if ([fileManager fileExistsAtPath: torrentDestination] == NO) {
         [Util showError:@"Couldn't open destination" withMessage: @"Torrent destination is not a valid folder."];
    } else {
        [[NSWorkspace sharedWorkspace] openFile:torrentDestination];
    }
}

- (IBAction)infoTorrent:(id)sender {
    NSLog(@"Show info window");
    if ([[fInfoController window] isVisible])
        [fInfoController close];
    [[fInfoController window] orderFront: nil];
}

- (IBAction)preferences:(id)sender {
    [[TorrentPreferencesController sharedPrefsWindowController] showWindow:nil];
    (void)sender;
}

- (IBAction) productWebsite:(id) sender {
    [Util openWebsite];
}

- (void) application: (NSApplication *) app openFiles: (NSArray *) filenames {
    [self openFiles: filenames];
}

- (void) openFiles: (NSArray *) filenames {
    for(int i = 0; i < [filenames count]; i++ ) {
        NSString* fileName = [filenames objectAtIndex:i];
        if (![arrayTorrents add:fileName]) {
            [Util showError:@"Couldn't add torrent" withMessage: @"Please verify this file is a valid torrent file."];
        }
    }
    [self refreshTorrents:self];
}

- (void)showFetchError {
    [Util showError:@"Couldn't fetch torrents" withMessage: @"Please check your connection settings."];
}

#pragma mark -
#pragma mark Quick look source

- (IBAction)togglePreviewPanel:(id)previewPanel {
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    } else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }
}

-(BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel {
    return YES;
}

-(void)beginPreviewPanelControl:(QLPreviewPanel *)panel {
    previewPanel = [panel retain];
    panel.delegate = self;
    panel.dataSource = self;
}

-(void)endPreviewPanelControl:(QLPreviewPanel *)panel {
    [previewPanel release];
    previewPanel = nil;
}

-(NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel {
    return [[arrayTorrents selectedObjects] count];
}

-(id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index {
    return [[arrayTorrents selectedObjects] objectAtIndex:index];
}

-(BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event {
    if ([event type] == NSKeyDown) {
        [tableView keyDown:event];
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark Interface methods

- (void) updateUI {
    if (![NSApp isHidden]) {
        if ([mainWindow isVisible]) {
            [self updateTorrents];
        }
    }

    [self updateBadge];
}

- (void) updateBadge {

    int incomplete = [self incompleteTorrents];
    if (incomplete == 0) {
        [[NSApp dockTile] setShowsApplicationBadge: NO];
        return;
    }

    NSString *label = [NSString stringWithFormat:@"%d", incomplete];

    [[NSApp dockTile] setBadgeLabel:label];
}

#pragma mark -
#pragma mark Notifications

- (void) torrentFinishedDownloading: (NSNotification *) notification {
    Torrent *torrent = [notification object];
    [Util doGrowl:@"Download Complete" withMessage:[NSString stringWithFormat: @"%@ finished", [torrent filename]]];
}

- (void) dealloc {
    [torrents release];
    [super dealloc];
}

- (void) applicationWillTerminate: (NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [timer invalidate];
    [fInfoController release];
}

@end
