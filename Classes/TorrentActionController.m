//
//  TorrentActionController.m
//  rt-control
//
//  Created by Gavin Gilmour on 26/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentActionController.h"


@implementation TorrentActionController

- (BOOL)removeTorrent:(Torrent *)torrent {
      NSLog(@"Right, NUKE: %@", [torrent hash]);
}

@end
