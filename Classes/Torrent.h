//
//  Torrent.h
//  rt-control
//
//  Created by Gavin Gilmour on 18/07/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLRPCRequest.h"

@interface Torrent : NSObject <NSCopying> {
    NSString *name;
    NSString *hash;
    NSString *uri;
    NSString *filename;
    NSNumber *bytesDone;
    NSNumber *bytesTotal;
    NSString *bytesDoneReadable;
    NSString *bytesTotalReadable;
    NSString *sizeFiles;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *uri;
@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSNumber *bytesDone;
@property (nonatomic, retain) NSNumber *bytesTotal;
@property (nonatomic, retain) NSString *bytesDoneReadable;
@property (nonatomic, retain) NSString *bytesTotalReadable;
@property (nonatomic, retain) NSString *sizeFiles;

+ (NSString *)stringFromFileSize:(NSNumber *)theSize;
+ (NSURL *) rtorrentRPCURL;
+ (id) fetchInfo:(NSString *)methodName param:(NSString *)param;
+ (id) executeXMLRPCRequest:(XMLRPCRequest *)req;
+ (BOOL) loadAll;

@end
