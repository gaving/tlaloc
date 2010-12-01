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

NSString* const XMLRPCUserAgent = @"Tlaloc";
NSString* const ProductWebsite = @"http://github.com/gaving/tlaloc/";

- (Config *)init {
    if((self = [super init])) {
        torrentHistory = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (Config *)instance {
    static Config *gInstance = NULL;

    @synchronized(self) {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return(gInstance);
}

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

+ (NSString *)torrentDestination {

    /* Make this configurable in the settings page */
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *torrentDestination = [userDefaults stringForKey:@"torrentDestination"];

    if ([torrentDestination length] == 0) {
        NSLog(@"No volume specified.");
        return nil;
    }

    return torrentDestination;
}

+ (NSString *)productWebsite {
    return ProductWebsite;
}

- (void) dealloc {
    [torrents release];
    [torrentHistory release];
    [super dealloc];
}

@end
