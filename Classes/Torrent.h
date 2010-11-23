//
//  Torrent.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/07/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>

@interface Torrent : NSObject <NSCopying> {
    NSString *name;
    NSString *hash;
    NSString *uri;
    NSString *filename;
    NSString *state;
    NSNumber *bytesDone;
    NSNumber *bytesTotal;
    NSString *bytesDoneReadable;
    NSString *bytesTotalReadable;
    NSString *sizeFiles;
    NSNumber *ratio;
    NSNumber *multiFile;
    NSImage *iconImage;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *uri;
@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSNumber *bytesDone;
@property (nonatomic, retain) NSNumber *bytesTotal;
@property (nonatomic, retain) NSString *bytesDoneReadable;
@property (nonatomic, retain) NSString *bytesTotalReadable;
@property (nonatomic, retain) NSString *sizeFiles;
@property (nonatomic, retain) NSNumber *ratio;
@property (nonatomic, retain) NSNumber *multiFile;
@property (retain) NSImage* iconImage;

+ (NSString *)stringFromFileSize:(NSNumber *)theSize;
+ (BOOL) loadAll;
- (NSString *)fullPath;

@end
