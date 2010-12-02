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
    NSUserDefaults *userDefaults;
    NSString *torrentDestination;
    NSString *rtorrentRPCString;    
    NSURL *rtorrentRPCURL;
}

extern NSString* const XMLRPCUserAgent;
extern NSString* const ProductWebsite;

@property (nonatomic, retain) NSMutableArray *torrents;
@property (nonatomic, retain) NSMutableDictionary *torrentHistory;
@property (nonatomic, retain) NSString *torrentDestination;
@property (nonatomic, retain) NSURL *rtorrentRPCURL;

+ (NSString *) productWebsite;
+ (Config *)instance;

@end
