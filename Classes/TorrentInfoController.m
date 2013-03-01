//
//  TorrentInfoController.m
//  Tlaloc
//
//  Created by Gavin Gilmour on 30/11/2010.
//  Copyright 2010 All rights reserved.
//

#import "TorrentInfoController.h"


@implementation TorrentInfoController

- (id) init
{
    self = [super initWithWindowNibName: @"TorrentInfoView"];
    return self;
}

- (void) awakeFromNib
{

    NSLog(@"hello");

}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    
    [super dealloc];
}

@end
