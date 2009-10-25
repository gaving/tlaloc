//
//  TorrentListController.m
//  rt-control
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentListController.h"
#import "Config.h"
#import "Torrent.h"
#import "ImageTextCell.h"

@implementation TorrentListController

NSPredicate *predicateTemplate;

- (id) init {
    if (self = [super init]) {
        if ([self grabTorrents]) {
            torrents  = [[NSMutableArray alloc] init];
            [self buildTorrents];
        } else {
            NSAlert* alert = [NSAlert new];
            [alert setInformativeText: @"Couldn't connect fetch torrents"];
            [alert setMessageText: @"Please check your connection settings"];
            [alert runModal];
        }
    }
    return self;
}

-(void)awakeFromNib {

    NSTableColumn* column = [[tableView tableColumns] objectAtIndex:0];
    ImageTextCell* cell = [[[ImageTextCell alloc] init] autorelease];
    [column setDataCell: cell];

    [cell setPrimaryTextKeyPath: @"filename"];
    [cell setSecondaryTextKeyPath: @"bytesDoneReadable"];
    [cell setIconKeyPath: @"icon"];

    predicateTemplate = [[NSPredicate predicateWithFormat:@"(filename contains[cd] $searchString)"] retain];
}

- (NSArray*) torrents {
        return torrents;
}

- (void)buildTorrents {
    torrents = [[Config instance] torrents];
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
