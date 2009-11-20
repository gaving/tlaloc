//
//  Config.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLRPCRequest.h"

@interface Config : NSObject {
    NSMutableArray *torrents;
}

extern NSString* const XMLRPCUserAgent;

@property (retain) NSMutableArray *torrents;

+ (NSURL *) rtorrentRPCURL;
+ (id) executeXMLRPCRequest:(XMLRPCRequest *)req;
+ (Config *)instance;

@end
