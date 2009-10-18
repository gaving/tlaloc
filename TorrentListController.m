//
//  TorrentListController.m
//  rt-tray
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009 SPSA. All rights reserved.
//

#import "TorrentListController.h"
#import "TorrentList.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"
#import "XMLRPCConnectionManager.h"
#import "XMLRPCDelegate.h"

@implementation TorrentListController

-(void)awakeFromNib {
    [self initializeTableStuff];
}

- (void) initializeTableStuff {
    torrentArray = [[NSArray alloc] init];

    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString: @"http://192.168.1.100:90/RPC2"]];
    XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    XMLRPCDelegate* delegate = [[XMLRPCDelegate alloc] init];
    [request setMethod:@"download_list" withParameter:@"main"];
    // NSLog(@"Request body: %@", [request body]);
    [manager spawnConnectionWithXMLRPCRequest: request delegate: delegate];
    [manager release];
    [request release];

/*     XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:[NSURL URLWithString: @"http://192.168.1.100:90/RPC2"]]; */
    // // XMLRPCConnectionManager *manager = [XMLRPCConnectionManager sharedManager];
    // // XMLRPCConnection *connection = [[XMLRPCConnection alloc] init];
    // XMLRPCDelegate* delegate = [[XMLRPCDelegate alloc] init];
    // [request setMethod:@"download_list" withParameter:@"main"];
    // // NSLog(@"Request body: %@", [request body]);
    // // [manager spawnConnectionWithXMLRPCRequest: request delegate: delegate];
    // XMLRPCResponse *response = [XMLRPCConnection sendSynchronousXMLRPCRequest: request];
    // torrentArray = (NSArray *)[response object];
    // // [manager release];
    // // [connection release];
    // [request release];
    /* [response release]; */

    NSLog(@"Finished initing the table");
}

- (IBAction)fetchTorrents:(id)sender {
    torrentArray = [[TorrentList instance] torrents];
    [tableView reloadData];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView {
    return [torrentArray count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row {
    return [torrentArray objectAtIndex:row];
}


@end
