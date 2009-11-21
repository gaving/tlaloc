//
//  TorrentArrayController.h
//  tlaloc
//
//  Created by Gavin Gilmour on 21/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TorrentActionController.h"
#import "Torrent.h"

@interface TorrentArrayController : NSArrayController {
    TorrentActionController* actionController;
}

- (BOOL)add:(NSString *)fileName;
- (BOOL)remove:(Torrent *)torrent;

@end
