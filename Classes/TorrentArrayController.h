//
//  TorrentArrayController.h
//  tlaloc
//
//  Created by Gavin Gilmour on 21/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TorrentActionController.h"

@interface TorrentArrayController : NSArrayController {
    TorrentActionController* actionController;
}

- (IBAction)add:(id)sender;
- (IBAction)remove:(id)sender;

@end
