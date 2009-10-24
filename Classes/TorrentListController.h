//
//  ConfigController.h
//  rt-control
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

// @interface TorrentListController : NSWindowController {
@interface TorrentListController : NSObject {
    IBOutlet NSToolbarItem *refreshItem;
    IBOutlet NSTableView *tableView;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSArrayController *arrayTorrents;

    NSMutableArray* torrents;
}

- (BOOL)grabTorrents;
- (void)buildTorrents;
- (IBAction)fetchTorrents:(id)sender;
- (IBAction)updateFilterAction:(id)sender;

@end
