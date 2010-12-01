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
    NSMutableDictionary *torrentHistory;
}

extern NSString* const XMLRPCUserAgent;
extern NSString* const ProductWebsite;

@property (retain) NSMutableArray *torrents;
@property (retain) NSMutableDictionary *torrentHistory;

+ (NSURL *) rtorrentRPCURL;
+ (NSString *) torrentDestination;
+ (NSString *) productWebsite;
+ (Config *)instance;

@end
