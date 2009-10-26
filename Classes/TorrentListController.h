//
//  ConfigController.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TorrentActionController.h"

@interface TorrentListController : NSObject {
    IBOutlet NSToolbarItem *addItem;
    IBOutlet NSToolbarItem *refreshItem;
    IBOutlet NSToolbarItem *infoItem;
    IBOutlet NSToolbarItem *removeItem;
    IBOutlet NSToolbarItem *preferencesItem;

    IBOutlet NSTableView *tableView;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSArrayController *arrayTorrents;

    NSMutableArray* torrents;
    TorrentActionController* actionController;
}

- (BOOL)grabTorrents;
- (void)buildTorrents;

- (IBAction)addTorrent:(id)sender;
- (IBAction)refreshTorrents:(id)sender;
- (IBAction)removeTorrent:(id)sender;
- (IBAction)filterTorrent:(id)sender;
- (IBAction)infoTorrent:(id)sender;
- (IBAction)preferences:(id)sender;

@end
