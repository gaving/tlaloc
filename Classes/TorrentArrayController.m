//
//  TorrentArrayController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 21/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentArrayController.h"
#import "Config.h"
#import "Torrent.h"

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

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard {
    [pboard declareTypes:[NSArray arrayWithObject:NSFilenamesPboardType] owner:self];
    NSArray *selectedTorrents = [self selectedObjects];
    if ([selectedTorrents count] == 0) {
        return NO;
    }

    NSString *torrentDestination = [Config torrentDestination];
    NSMutableArray *fileNames = [NSMutableArray array];
    for (int i = 0; i < [selectedTorrents count]; i++) {
        Torrent *torrent = [selectedTorrents objectAtIndex:i];
        NSString *realPath = [torrentDestination stringByAppendingPathComponent: [torrent filename]]; 
        [fileNames addObject: realPath];
    }

    [pboard setPropertyList:fileNames forType:NSFilenamesPboardType];
    return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op {

    /* TODO: Bother to deal with this? */
    return NSDragOperationEvery;
}

- (void) dealloc {
    [actionController release];
    [super dealloc];
}

@end
