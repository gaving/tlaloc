//
//  TorrentActionController.h
//  tlaloc
//
//  Created by Gavin Gilmour on 26/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Torrent.h"

@interface TorrentActionController : NSObject {

}

- (BOOL)addTorrent:(NSString *)fileName;
- (BOOL)removeTorrent:(Torrent *)torrent;
- (BOOL)deleteFile:(Torrent *)torrent;

@end
