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
        NSLog(@"%@", [(NSError *)response localizedDescription]);
        [Util showError:@"Couldn't make request" withMessage: [(NSError *)response localizedDescription]];
        return NO;
    }

    return YES;
}

- (BOOL)addTorrent:(NSString *)fileName {
    NSLog(@"TorrentActionController addTorrent: %@", fileName);
    NSData *data = [NSData dataWithContentsOfFile:fileName];

    if ([TorrentActionController executeCommand:@"load_raw_start" withData:data]) {
        [Util doGrowl:@"Download Queued" withMessage:[NSString stringWithFormat: @"%@ queued", [fileName lastPathComponent]]];
        return YES;
    }

    return NO;
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
