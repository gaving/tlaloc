//
//  Config.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "Config.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"

@implementation Config

@synthesize torrents;

NSString* const XMLRPCUserAgent = @"tlaloc";

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

+ (id)executeXMLRPCRequest:(XMLRPCRequest *)req {
    XMLRPCResponse *userInfoResponse = [XMLRPCConnection sendSynchronousXMLRPCRequest:req];
    // NSLog(@"Response body: %@", [userInfoResponse body]);
    return [userInfoResponse object];
}

- (void) dealloc {
    [torrents release];
    [super dealloc];
}

@end
