//
//  TorrentTableView.m
//  tlaloc
//
//  Created by Gavin Gilmour on 21/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "TorrentTableView.h"


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

// - (void)drawRect:(NSRect)dirtyRect {
   // // Drawing code here.
// }

/*
 * -(NSMenu*)menuForEvent:(NSEvent*)event {
 *     if ([event type] == NSRightMouseDown)
 *     {
 *         NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
 *         int row = [self rowAtPoint:mousePoint];
 *         if (row >= 0) {
 *             [self selectRow:row byExtendingSelection:NO];
 *         } else {
 *             [self deselectAll:self];
 *         }
 *     }
 *     return [super menuForEvent:event];
 * }
 */

-(NSMenu *)menuForEvent:(NSEvent *)theEvent {
    NSMenu *menu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"This is my menu"];
    [menu addItemWithTitle: @"Open" action: @selector (mItem1) keyEquivalent: @"O" ];
    [menu addItemWithTitle: @"Remove" action: @selector (mItem1) keyEquivalent: @"D" ];
    [menu addItem: [NSMenuItem separatorItem]];
    [menu addItemWithTitle: @"Get Info" action: @selector ( mItem2: ) keyEquivalent: @"I" ];
    [menu setAutoenablesItems: NO ];
    return  menu;
}

@end
