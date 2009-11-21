//
//  TorrentArrayController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 21/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentArrayController.h"

@implementation TorrentArrayController

-(void)awakeFromNib {
    actionController = [TorrentActionController alloc];
}

- (BOOL)add:(NSString *)fileName {
    if ([actionController addTorrent:fileName]) {
        return YES;
    }

    return NO;
}

- (BOOL)remove:(Torrent *)torrent {
    if ([actionController removeTorrent:torrent]) {
        [super remove:self];
        return YES;
    }
    return NO;
}

- (void) dealloc {
    [actionController release];
    [super dealloc];
}

@end
