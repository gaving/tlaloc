//
//  TorrentListController.h
//  rt-tray
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009 SPSA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TorrentList.h"

@interface TorrentListController : NSObject {
    IBOutlet NSToolbarItem *refreshItem;
    IBOutlet NSTableView *tableView;
    TorrentList *torrentList;
    NSArray *torrentArray;
}

- (void)initializeTableStuff;
- (IBAction)fetchTorrents:(id)sender;

@end
