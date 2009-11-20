//
//  TorrentActionController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 26/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "Torrent.h"
#import "TorrentActionController.h"
#import "Config.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"

@implementation TorrentActionController

- (BOOL)addTorrent:(NSString *)fileName {
    NSLog(@"TorrentActionController addTorrent: %@", fileName);
    NSData *data = [NSData dataWithContentsOfFile:fileName];

    /* Send the data of the torrent over */
    NSURL *rtorrentRPCURL = [Config rtorrentRPCURL];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:rtorrentRPCURL];
    [request setUserAgent:XMLRPCUserAgent];
    [request setMethod:@"load_raw_start" withParameter:data];
    NSObject *response = [Config executeXMLRPCRequest:request];
    [request release];

    return !([response isKindOfClass:[NSError class]]);
}

- (BOOL)removeTorrent:(Torrent *)torrent {
    NSLog(@"TorrentActionController removeTorrent: %@", [torrent hash]);

    /* Nuke the torrent */
    NSURL *rtorrentRPCURL = [Config rtorrentRPCURL];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:rtorrentRPCURL];
    [request setUserAgent:XMLRPCUserAgent];
    [request setMethod:@"d.erase" withParameter:[torrent hash]];
    NSObject *response = [Config executeXMLRPCRequest:request];
    [request release];

    return !([response isKindOfClass:[NSError class]]);
}

@end
