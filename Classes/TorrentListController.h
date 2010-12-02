//
//  ConfigController.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <Growl/Growl.h>

#import "TorrentInfoController.h"
#import "TorrentArrayController.h"

@class TorrentInfoController;

@interface TorrentListController : NSObject <NSMenuDelegate, GrowlApplicationBridgeDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate> {

    IBOutlet NSWindow *mainWindow;
    IBOutlet NSMenu *statusMenu;

    IBOutlet NSToolbarItem *addItem;
    IBOutlet NSToolbarItem *refreshItem;
    IBOutlet NSToolbarItem *qlItem;
    IBOutlet NSToolbarItem *infoItem;
    IBOutlet NSToolbarItem *removeItem;
    IBOutlet NSToolbarItem *preferencesItem;

    IBOutlet NSTableView *tableView;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSProgressIndicator *progressIndicator;

    IBOutlet TorrentArrayController *arrayTorrents;

    NSStatusItem *statusItem;
    NSImage *statusImage;
    NSImage *statusHighlightImage;

    NSMutableArray *torrents;
    NSTimer *timer;

    TorrentInfoController *fInfoController;
    QLPreviewPanel *previewPanel;
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
- (IBAction)qlTorrent:(id)sender;
- (IBAction)filterTorrent:(id)sender;
- (IBAction)openTorrent:(id)sender;
- (IBAction)openDestination:(id)sender;
- (IBAction)infoTorrent:(id)sender;
- (IBAction)preferences:(id)sender;

- (IBAction)productWebsite:(id)sender;
- (IBAction)togglePreviewPanel:(id)previewPanel;

- (void)openFiles:(NSArray *) filenames;
- (void)updateUI;
- (void)updateBadge;

@end
