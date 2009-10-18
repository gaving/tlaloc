//
//  TorrentListController.m
//  rt-tray
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009 SPSA. All rights reserved.
//

#import "TorrentListController.h"
#import "Config.h"
#import "Torrent.h"

@implementation TorrentListController

@synthesize torrents;

NSPredicate *predicateTemplate;

-(void)awakeFromNib {
    if ([self grabTorrents]) {

        //initialize the contacts array
        torrents  = [[NSMutableArray alloc] init];

        [self buildTorrents];
    }

    predicateTemplate = [[NSPredicate predicateWithFormat:@"(filename contains[cd] $searchString)"] retain];
}


- (void)buildTorrents {
    NSMutableArray* theTorrents = [[Config instance] torrents];
    for (Torrent *torrent in theTorrents) {

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
            [torrent filename], @"filename",
            [torrent bytesTotalReadable], @"size",
            [torrent bytesDoneReadable], @"downloaded",
            @"-", @"uploaded",
            @"-", @"ratio",
            nil];

        //add it to the arrayController
        [arrayTorrents addObject:dict];
    }
}

- (BOOL)grabTorrents {
    return ([Torrent loadAll] == YES);
}

- (IBAction)fetchTorrents:(id)sender {
    if ([self grabTorrents]) {
        [torrents release];
        torrents  = [[NSMutableArray alloc] init];
        [self buildTorrents];
        [tableView reloadData];
    }
}

- (IBAction)updateFilterAction:(id)sender {

    NSString *searchString = [searchField stringValue];
    NSPredicate *predicate;

    //if the search field is empty do not search!
    if ([searchString isEqualToString:@""]) {
        predicate = nil;
    } else {
        //create a new dictionary with the search string
        NSMutableDictionary *bindVariables = [[NSMutableDictionary alloc] init];
        [bindVariables setObject:searchString forKey:@"searchString"];

        //and create a predicate from the template by replacing the variable with its actual value
        predicate = [predicateTemplate predicateWithSubstitutionVariables:bindVariables];
    }

    //apply the predicate to the array controller
    [arrayTorrents setFilterPredicate:predicate];
}


@end
