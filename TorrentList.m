//
//  TorrentList.m
//  rt-tray
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009 SPSA. All rights reserved.
//

#import "TorrentList.h"

@implementation TorrentList

@synthesize torrents;

+ (TorrentList *)instance {
    static TorrentList *gInstance = NULL;

    @synchronized(self) {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return(gInstance);
}

- (void) dealloc {
    [torrents release];
    [super dealloc];
}

@end
