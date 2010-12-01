//
//  AppPrefsWindowController.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentPreferencesController.h"

@implementation TorrentPreferencesController

- (void)setupToolbar {
    [self addView:generalPreferenceView label:@"General"];
    [self addView:updatesPreferenceView label:@"Updates"];
}

@end
