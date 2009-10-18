//
//  Config.h
//  rt-tray
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009 SPSA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Config : NSObject {
    NSMutableArray *torrents;
}

@property (copy) NSMutableArray *torrents;

+ (Config *)instance;

@end
