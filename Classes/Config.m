//
//  Config.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "Config.h"


@implementation Config

@synthesize torrents;
@synthesize torrentHistory;
@synthesize torrentDestination;
@synthesize rtorrentRPCURL;

NSString* const XMLRPCUserAgent = @"Tlaloc";
NSString* const ProductWebsite = @"http://github.com/gaving/tlaloc/";

- (Config *)init {

    if((self = [super init])) {
        torrentHistory = [[NSMutableDictionary alloc] init];
        userDefaults = [NSUserDefaults standardUserDefaults];
        torrentDestination = [userDefaults stringForKey:@"torrentDestination"];
        rtorrentRPCString = [userDefaults stringForKey:@"rtorrentRPCURL"];
        rtorrentRPCURL = [[NSURL URLWithString: rtorrentRPCString] retain];
    }
    return self;
}

+ (Config *)instance {
    static Config *gInstance = NULL;

    @synchronized(self) {
        if (gInstance == NULL) {
            gInstance = [[self alloc] init];
        }
    }

    return gInstance;
}

+ (NSString *)productWebsite {
    return ProductWebsite;
}

- (void) dealloc {
    [torrents release];
    [torrentHistory release];
    [userDefaults release];
    [torrentDestination release];
    [rtorrentRPCString release];
    [rtorrentRPCURL release];
    [super dealloc];
}

@end
