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
#import "Util.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"

@implementation TorrentActionController

+ (BOOL)executeCommand:(NSString *)command withData:(NSObject *)data {
    NSURL *rtorrentRPCURL = [Config rtorrentRPCURL];
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:rtorrentRPCURL];
    [request setUserAgent:XMLRPCUserAgent];
    [request setMethod:command withParameter:data];
    NSObject *response = [Util executeXMLRPCRequest:request];
    [request release];

    if ([response isKindOfClass:[NSError class]]) {

        /* TODO: Present some sort of error dialog */
        return NO;
    }

    return YES;
}

- (BOOL)addTorrent:(NSString *)fileName {
    NSLog(@"TorrentActionController addTorrent: %@", fileName);
    NSData *data = [NSData dataWithContentsOfFile:fileName];
    return [TorrentActionController executeCommand:@"load_raw_start" withData:data];
}

- (BOOL)removeTorrent:(Torrent *)torrent {
    NSLog(@"TorrentActionController removeTorrent: %@", [torrent hash]);
    return [TorrentActionController executeCommand:@"d.erase" withData:[torrent hash]];
}

- (BOOL)deleteFile:(Torrent *)torrent {
    NSLog(@"TorrentActionController deleteFile: %@", [torrent hash]);

    /* Delete the actual file */
    return [TorrentActionController executeCommand:@"d.delete_tied" withData:[torrent hash]];
}

@end
