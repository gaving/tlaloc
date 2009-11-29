//
//  Config.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject {
    NSMutableArray *torrents;
}

extern NSString* const XMLRPCUserAgent;
extern NSString* const ProductWebsite;

@property (retain) NSMutableArray *torrents;

+ (NSURL *) rtorrentRPCURL;
+ (NSString *) torrentDestination;
+ (NSString *) productWebsite;
+ (Config *)instance;

@end
