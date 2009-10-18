//
//  Torrent.m
//  rt-phone
//
//  Created by Gavin Gilmour on 18/07/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Torrent.h"
#import "Config.h"

#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"

@implementation Torrent

@synthesize name;
@synthesize uri;
@synthesize hash;
@synthesize filename;
@synthesize bytesDone;
@synthesize bytesTotal;
@synthesize bytesDoneReadable;
@synthesize bytesTotalReadable;

+ (NSURL *)rtorrentRPCURL {

    /* Make this configurable in the settings page */
    // NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // NSString *rtorrentRPCURL = [userDefaults stringForKey:@"rtorrentRPCURL"];

    // if ([rtorrentRPCURL length] == 0) {
        // return nil;
    // }

    return [NSURL URLWithString:  @"http://192.168.1.100:90/RPC2"];
}

+  (id)fetchInfo:(NSString *)methodName param:(NSString *)param {
    XMLRPCRequest *infoRequest = [[XMLRPCRequest alloc] initWithURL:[Torrent rtorrentRPCURL]];
    [infoRequest setMethod:methodName withParameter:param];
    [infoRequest setUserAgent:@"rt-phone"];
    NSString *response = [Torrent executeXMLRPCRequest:infoRequest];
    [infoRequest release];
    return response;
}

+ (id)executeXMLRPCRequest:(XMLRPCRequest *)req {
    XMLRPCResponse *userInfoResponse = [XMLRPCConnection sendSynchronousXMLRPCRequest:req];
    return [userInfoResponse object];
}

+ (NSString *)stringFromFileSize:(int)theSize {
    float floatSize = theSize;
    if (theSize<1023)
        return([NSString stringWithFormat:@"%i bytes",theSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f KB",floatSize]);
    floatSize = floatSize / 1024;
    if (floatSize<1023)
        return([NSString stringWithFormat:@"%1.1f MB",floatSize]);
    floatSize = floatSize / 1024;

    return([NSString stringWithFormat:@"%1.1f GB",floatSize]);
}

+ (BOOL)loadAll {

    NSLog(@"Fetching the torrent list");

    NSURL *rtorrentRPCURL = [Torrent rtorrentRPCURL];

    if (rtorrentRPCURL == nil) {

        /* No URL has been specified at all */
        return NO;
    }

    /* Fetch the main download list */
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:rtorrentRPCURL];

    [request setUserAgent:@"rt-phone"];
    [request setMethod:@"download_list" withParameter:@"main"];

    NSObject *response = [Torrent executeXMLRPCRequest:request];
    [request release];

    if ([response isKindOfClass:[NSError class]]) {

        /* Not received a suitable response, return early */
        return NO;
    }

    NSMutableArray *torrents = [[[NSMutableArray alloc] init] autorelease];
    NSArray* hashArray = (NSArray *)response;

    /* Loop through the torrents and get more info about them */
    for (NSString *hash in hashArray) {

        /* Extended information about the torrent */
        NSString *name = [self fetchInfo:@"d.get_name" param:hash];
        NSNumber *bytesDone = [self fetchInfo:@"d.get_completed_bytes" param:hash];
        NSNumber *bytesTotal = [self fetchInfo:@"d.get_size_bytes" param:hash];

        Torrent *tempTorrent = [[[Torrent alloc] init] autorelease];
        [tempTorrent setHash:hash];
        [tempTorrent setFilename:name];
        [tempTorrent setBytesDone:bytesDone];
        [tempTorrent setBytesTotal:bytesTotal];
        [tempTorrent setBytesDoneReadable:[Torrent stringFromFileSize: bytesDone]];
        [tempTorrent setBytesTotalReadable:[Torrent stringFromFileSize: bytesTotal]];
        [torrents addObject:tempTorrent];
    }

    /* Set these torrents in the config */
    [[Config instance] setTorrents:torrents];

    return YES;
}


- (void) dealloc {
    [name release];
    [hash release];
    [filename release];
    [uri release];
    [super dealloc];
}

@end
