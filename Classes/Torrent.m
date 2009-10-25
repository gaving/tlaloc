//
//  Torrent.m
//  rt-control
//
//  Created by Gavin Gilmour on 18/07/2009.
//  Copyright 2009. All rights reserved.
//

#import "Torrent.h"
#import "Config.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"

@implementation Torrent

NSString* const XMLRPCUserAgent = @"rt-control";

@synthesize name;
@synthesize uri;
@synthesize hash;
@synthesize filename;
@synthesize state;
@synthesize bytesDone;
@synthesize bytesTotal;
@synthesize bytesDoneReadable;
@synthesize bytesTotalReadable;
@synthesize sizeFiles;

+ (NSURL *)rtorrentRPCURL {

    /* Make this configurable in the settings page */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *rtorrentRPCURL = [userDefaults stringForKey:@"rtorrentRPCURL"];

    if ([rtorrentRPCURL length] == 0) {
        NSLog(@"No rtorrent RPC URL specified. Aborting.");
        return nil;
    }

    return [NSURL URLWithString:  rtorrentRPCURL];
}

+ (id)executeXMLRPCRequest:(XMLRPCRequest *)req {
    XMLRPCResponse *userInfoResponse = [XMLRPCConnection sendSynchronousXMLRPCRequest:req];
    // NSLog(@"Response body: %@", [userInfoResponse body]);
    return [userInfoResponse object];
}

+ (NSString *)stringFromFileSize:(NSNumber *)theSize {
    float floatSize = [theSize floatValue];
    if (floatSize<1023){
        return ([NSString stringWithFormat:@"%i bytes",floatSize]);
    }

    floatSize = floatSize / 1024;
    if (floatSize<1023) {
        return ([NSString stringWithFormat:@"%1.1f KB",floatSize]);
    }

    floatSize = floatSize / 1024;
    if (floatSize<1023) {
        return ([NSString stringWithFormat:@"%1.1f MB",floatSize]);
    }

    floatSize = floatSize / 1024;
    return ([NSString stringWithFormat:@"%1.1f GB",floatSize]);
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
    [request setUserAgent:XMLRPCUserAgent];
    NSMutableArray *params = [[[NSMutableArray alloc] init] autorelease];

    [params addObject:@"main"];
    [params addObject:@"d.get_hash="];
    [params addObject:@"d.get_name="];
    [params addObject:@"d.get_state="];
    [params addObject:@"d.get_completed_bytes="];
    [params addObject:@"d.get_size_bytes="];
    [params addObject:@"d.get_left_bytes="];
    [params addObject:@"d.get_down_rate="];
    [params addObject:@"d.get_up_rate="];
    [params addObject:@"d.get_peers_connected="];
    [params addObject:@"d.get_peers_not_connected="];
    [params addObject:@"d.get_peers_accounted="];
    [params addObject:@"d.get_bytes_done="];
    [params addObject:@"d.get_up_total="];
    [params addObject:@"d.get_creation_date="];
    [params addObject:@"d.get_complete="];
    [params addObject:@"d.is_active="];
    [params addObject:@"d.is_hash_checking="];

    [request setMethod:@"d.multicall" withParameter:params];

    NSObject *response = [Torrent executeXMLRPCRequest:request];
    [request release];

    if ([response isKindOfClass:[NSError class]]) {

        /* Request failed, bail */
        return NO;
    }

    NSMutableArray *torrents = [[[NSMutableArray alloc] init] autorelease];
    NSArray* detailsArray = (NSArray *)response;
    for (int i = 0; i < [detailsArray count]; i++) {

        NSMutableArray* value = [detailsArray objectAtIndex:i];
        Torrent *tempTorrent = [[[Torrent alloc] init] autorelease];
        [tempTorrent setHash:[value objectAtIndex:0]];
        [tempTorrent setFilename:[value objectAtIndex:1]];
        [tempTorrent setState:[value objectAtIndex:2]];
        [tempTorrent setBytesDone:[value objectAtIndex:3]];
        [tempTorrent setBytesTotal:[value objectAtIndex:4]];
        [tempTorrent setBytesDoneReadable:[Torrent stringFromFileSize: [tempTorrent bytesDone]]];
        [tempTorrent setBytesTotalReadable:[Torrent stringFromFileSize: [tempTorrent bytesTotal]]];

        [torrents addObject:tempTorrent];
    }

    /* Set these torrents in the config */
    [[Config instance] setTorrents:torrents];

    return YES;
}

- (id)copyWithZone:(NSZone *)zone {
    Torrent *copy = [[self class] allocWithZone: zone];
    [copy setFilename:[self filename]];
    [copy setBytesDoneReadable:[self bytesDoneReadable]];
    return copy;
}

- (NSImage*) icon {
    NSImage *image = [[NSWorkspace sharedWorkspace] iconForFileType:[filename pathExtension]];
    return image;
}

- (void) dealloc {
    [name release];
    [hash release];
    [filename release];
    [uri release];
    [super dealloc];
}

@end
