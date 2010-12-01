//
//  TorrentTableView.m
//  tlaloc
//
//  Created by Gavin Gilmour on 21/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentTableView.h"
#import "TlalocAppDelegate.h"
#import "TorrentListController.h"

@implementation TorrentTableView

-(void)awakeFromNib {
}

- (id)initWithFrame:(NSRect)frame {
   self = [super initWithFrame:frame];
   if (self) {
       // Initialization code here.
   }
   return self;
}

/*
 * -(NSMenu *)menuForEvent:(NSEvent *)theEvent {
 *     NSMenu *menu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"This is my menu"];
 *     [menu addItemWithTitle: @"Open" action: @selector (refreshTorrents) keyEquivalent: @"O" ];
 *     [menu addItemWithTitle: @"Remove" action: @selector (mItem1) keyEquivalent: @"D" ];
 *     [menu addItem: [NSMenuItem separatorItem]];
 *     [menu addItemWithTitle: @"Get Info" action: @selector (mItem2:) keyEquivalent: @"I" ];
 *     [menu setAutoenablesItems: NO ];
 *     return  menu;
 * }
 */

- (void)keyDown:(NSEvent *)theEvent {
    NSString* key = [theEvent charactersIgnoringModifiers];
    if([key isEqual:@" "]) {
        [((TorrentListController *)[self delegate]) togglePreviewPanel:self];
    } else {
        [super keyDown:theEvent];
    }
}

@end

