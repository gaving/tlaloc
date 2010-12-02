//
//  Torrent.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/07/2009.
//  Copyright 2009. All rights reserved.
//

#import "Torrent.h"
#import "Config.h"
#import "Util.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"

#include <QuickLook/QuickLook.h>

@implementation Torrent

#define ICON_SIZE 32.0

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
@synthesize ratio;
@synthesize multiFile;
@synthesize iconImage;
@synthesize complete;

//static NSDictionary* quickLookOptions = nil;
//static NSOperationQueue* downloadIconQueue = nil;

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

    NSURL *rtorrentRPCURL = [[[Config instance] rtorrentRPCURL] retain];

    if (rtorrentRPCURL == nil) {

        /* No URL has been specified at all */
        return NO;
    }

    /* Fetch the main download list */
    XMLRPCRequest *request = [[XMLRPCRequest alloc] initWithURL:rtorrentRPCURL];
    [rtorrentRPCURL release];
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
    [params addObject:@"d.get_ratio="];
    [params addObject:@"d.is_active="];
    [params addObject:@"d.is_hash_checking="];
    [params addObject:@"d.is_multi_file="];

    [request setMethod:@"d.multicall" withParameter:params];

    NSObject *response = [Util executeXMLRPCRequest:request];
    [request release];

    if ([response isKindOfClass:[NSError class]]) {

        /* Request failed, bail */
        return NO;
    }

    NSMutableDictionary *torrentHistory = [[Config instance] torrentHistory];
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
        [tempTorrent setRatio:[value objectAtIndex:15]];
        [tempTorrent setMultiFile:[value objectAtIndex:18]];
        [tempTorrent setComplete:[value objectAtIndex:14]];

        [torrents addObject:tempTorrent];

        if ([torrentHistory objectForKey:[tempTorrent hash]]) {
            Torrent *existingTorrent = [torrentHistory objectForKey:[tempTorrent hash]];

            /* Check if the status flag has changed */
            if (([[tempTorrent complete] intValue] == 1) && ([[existingTorrent complete] intValue] == 0)) {
                [[NSNotificationCenter defaultCenter] postNotificationName: @"TorrentFinishedDownloading" object: tempTorrent];
            }


            /* TODO: Check to see if something has now failed */
        }

        /* Update the key*/
        [torrentHistory setObject:tempTorrent forKey:[tempTorrent hash]];
    }


    /* TODO: Clean up all the keys that aren't in torrents */

    /* Set these torrents in the config */
    [[Config instance] setTorrents:torrents];

    return YES;
}

- (id)copyWithZone:(NSZone *)zone {
    Torrent *copy = [[self class] allocWithZone: zone];
    [copy setFilename:[self filename]];
    [copy setBytesDone:[self bytesDone]];
    [copy setBytesTotal:[self bytesTotal]];
    [copy setBytesDoneReadable:[self bytesDoneReadable]];
    [copy setBytesTotalReadable:[self bytesTotalReadable]];
    [copy setRatio:[self ratio]];
    [copy setMultiFile:[self multiFile]];
    return copy;
}

- (NSImage*) typeIcon {
    //    NSString * pathExtension = [multiFile boolValue] ? NSFileTypeForHFSTypeCode('fldr') : [filename pathExtension];
    //    NSImage* image = [[NSWorkspace sharedWorkspace] iconForFileType:pathExtension];
    //    return image;

    if (iconImage == nil) {
        NSString* realPath = [self fullPath];
        iconImage = [[[NSWorkspace sharedWorkspace] iconForFile:realPath] retain];
        [iconImage setSize:NSMakeSize(ICON_SIZE, ICON_SIZE)];
        // if (!downloadIconQueue) {
            // downloadIconQueue = [[NSOperationQueue alloc] init];
            // [downloadIconQueue setMaxConcurrentOperationCount:2];
            // quickLookOptions = [[NSDictionary alloc] initWithObjectsAndKeys:
                // (id)kCFBooleanTrue, (id)kQLThumbnailOptionIconModeKey,
                // nil];
        // }

        // [downloadIconQueue addOperationWithBlock:^{
            // CFURLRef baseURL = (CFURLRef) [[NSURL alloc] initFileURLWithPath:realPath];
            // NSLog(@"%@", baseURL);

            // CGImageRef quickLookIcon = QLThumbnailImageCreate(NULL, baseURL, CGSizeMake(ICON_SIZE, ICON_SIZE), (CFDictionaryRef)quickLookOptions);
            // NSLog(@"%@", quickLookIcon);
            // if (quickLookIcon != NULL) {
                // NSImage* betterIcon = [[NSImage alloc] initWithCGImage:quickLookIcon size:NSMakeSize(ICON_SIZE, ICON_SIZE)];
                // [self performSelectorOnMainThread:@selector(setIconImagez:) withObject:betterIcon waitUntilDone:YES];
                // [betterIcon release];
                // CFRelease(quickLookIcon);
            // }
        // }];
    }
    return [iconImage autorelease];
}

- (NSImage*) ratioIcon {

    NSString* resource = [[NSString alloc] init];
    float torrentRatio = [[self ratio] floatValue] / 1000;

    /* Grab the correct image for the ratio */
    if (torrentRatio >= 0.95) {
        resource = @"surprise";
    } else if (torrentRatio >= 0.90) {
        resource = @"wink";
    } else if (torrentRatio >= 0.75) {
        resource = @"smile-big";
    } else if (torrentRatio >= 0.60) {
        resource = @"smile";
    } else if (torrentRatio >= 0.50) {
        resource = @"plain";
    } else if (torrentRatio >= 0.30) {
        resource = @"sad";
    } else {
        resource = @"crying";
    }

    NSString *textPath = [[NSBundle mainBundle] pathForResource:resource ofType:@"png"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile: textPath];
    return [image autorelease];
}

- (NSString*) fullPath {
    NSString *torrentDestination = [[Config instance] torrentDestination];
    NSString *realPath = [torrentDestination stringByAppendingPathComponent: self.filename];
    return realPath;
}

- (NSString*) remainingString {
    NSNumber* percentage = [NSNumber numberWithInt:([bytesDone intValue] / [bytesTotal intValue]) * 100];
    return [NSString stringWithFormat: @"%@ / %@ (%@%%)", bytesDoneReadable, bytesTotalReadable, percentage];
}

- (void) dealloc {
    [name release];
    [hash release];
    [filename release];
    [uri release];
    [bytesDone release];
    [bytesTotal release];
    [bytesDoneReadable release];
    [bytesTotalReadable release];
    [sizeFiles release];
    [ratio release];
    [multiFile release];
    [complete release];
    [state release];
    [super dealloc];
}

@end
