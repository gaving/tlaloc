//
//  ConfigController.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

#import "TorrentArrayController.h"

@interface TorrentListController : NSObject <QLPreviewPanelDataSource, QLPreviewPanelDelegate> {

    IBOutlet NSWindow *mainWindow;

    IBOutlet NSToolbarItem *addItem;
    IBOutlet NSToolbarItem *refreshItem;
    IBOutlet NSToolbarItem *infoItem;
    IBOutlet NSToolbarItem *removeItem;
    IBOutlet NSToolbarItem *preferencesItem;

    IBOutlet NSTableView *tableView;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSProgressIndicator *progressIndicator;

    IBOutlet TorrentArrayController *arrayTorrents;

    QLPreviewPanel * previewPanel;
    NSMutableArray* torrents;
    NSTimer* timer;
}

- (BOOL)grabTorrents;
- (void)buildTorrents;
- (void)updateTorrents;
- (void)showFetchError;

- (IBAction)addTorrent:(id)sender;
- (IBAction)copyTorrent:(id)sender;
- (IBAction)deleteFile:(id)sender;
- (IBAction)removeTorrent:(id)sender;
- (IBAction)refreshTorrents:(id)sender;
- (IBAction)filterTorrent:(id)sender;
- (IBAction)openTorrent:(id)sender;
- (IBAction)openDestination:(id)sender;
- (IBAction)infoTorrent:(id)sender;
- (IBAction)preferences:(id)sender;

- (IBAction)productWebsite:(id)sender;

- (void)openFiles:(NSArray *) filenames;
- (void) updateUI;
- (void) updateBadge;

@end
