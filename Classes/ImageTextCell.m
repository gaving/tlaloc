//
//  ImageTextCell.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "ImageTextCell.h"
#define PROGRESS_INDICATOR_DIMENSION    16
#define PROGRESS_INDICATOR_LEFT_MARGIN  1

@implementation ImageTextCell

- (void)dealloc {
    [self setDataDelegate: nil];
    [self setTypeIconKeyPath: nil];
    [self setRatioIconKeyPath: nil];
    [self setPrimaryTextKeyPath: nil];
    [self setSecondaryTextKeyPath: nil];
    [super dealloc];
}

- copyWithZone:(NSZone *)zone {
    ImageTextCell *cell = (ImageTextCell *)[super copyWithZone:zone];
    cell->delegate = nil;
    [cell setDataDelegate: delegate];
    return cell;
}

- (void) setTypeIconKeyPath: (NSString*) path {
    [typeIconKeyPath autorelease];
    typeIconKeyPath = [path retain];
}

- (void) setRatioIconKeyPath: (NSString*) path {
    [ratioIconKeyPath autorelease];
    ratioIconKeyPath = [path retain];
}

- (void) setPrimaryTextKeyPath: (NSString*) path {
    [primaryTextKeyPath autorelease];
    primaryTextKeyPath = [path retain];
}
- (void) setSecondaryTextKeyPath: (NSString*) path {
    [secondaryTextKeyPath autorelease];
    secondaryTextKeyPath = [path retain];
}

- (void) setDataDelegate: (NSObject*) aDelegate {
    [aDelegate retain];
    [delegate autorelease];
    delegate = aDelegate;
}

- (id) dataDelegate {
    if (delegate) return delegate;
    return self; // in case there is no delegate we try to resolve values by using key paths
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
   [self setTextColor:[NSColor blackColor]];

   NSObject* data = [self objectValue];

   // give the delegate a chance to set a different data object
   if ([[self dataDelegate] respondsToSelector: @selector(dataElementForCell:)]) {
        data = [[self dataDelegate] dataElementForCell:self];
   }

   BOOL elementDisabled    = NO;
   if ([[self dataDelegate] respondsToSelector: @selector(disabledForCell:data:)]) {
                elementDisabled = [[self dataDelegate] disabledForCell: self data: data];
   }

   NSColor* primaryColor   = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : (elementDisabled? [NSColor disabledControlTextColor] : [NSColor textColor]);
   NSString* primaryText   = [[self dataDelegate] primaryTextForCell:self data: data];

   NSDictionary* primaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: primaryColor, NSForegroundColorAttributeName,
                                                           [NSFont systemFontOfSize:13], NSFontAttributeName, nil];
   [primaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y) withAttributes:primaryTextAttributes];

   NSColor* secondaryColor = [self isHighlighted] ? [NSColor alternateSelectedControlTextColor] : [NSColor disabledControlTextColor];
   NSString* secondaryText = [[self dataDelegate] secondaryTextForCell:self data: data];
   NSDictionary* secondaryTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: secondaryColor, NSForegroundColorAttributeName,
                                                             [NSFont systemFontOfSize:10], NSFontAttributeName, nil];
   [secondaryText drawAtPoint:NSMakePoint(cellFrame.origin.x+cellFrame.size.height+10, cellFrame.origin.y+cellFrame.size.height/2)
               withAttributes:secondaryTextAttributes];

   // if (!progressIndicator) {

       // [> Progress indicator at the side <]
       // progressIndicator = [[NSProgressIndicator alloc] initWithFrame:NSMakeRect(0, 0, 16, 16)];
       // [progressIndicator setStyle:NSProgressIndicatorBarStyle];
       // [progressIndicator setIndeterminate:NO];
       // [progressIndicator setMaxValue:100.0];
       // [progressIndicator setDisplayedWhenStopped:YES];
       // [progressIndicator setUsesThreadedAnimation:YES];
       // [progressIndicator startAnimation:self];
       // [progressIndicator autorelease];
   // }
   // [progressIndicator setDoubleValue:90];

   // NSRect progressIndicatorFrame;
   // NSDivideRect(cellFrame, &progressIndicatorFrame, &cellFrame, PROGRESS_INDICATOR_DIMENSION + PROGRESS_INDICATOR_LEFT_MARGIN, NSMaxXEdge);
   // progressIndicatorFrame.size = NSMakeSize(200, PROGRESS_INDICATOR_DIMENSION);
   // progressIndicatorFrame.origin.x -= 100;

   // if ([progressIndicator superview] != controlView) {
       // [controlView addSubview:progressIndicator];
   // }

   // if (!NSEqualRects([progressIndicator frame], progressIndicatorFrame)) {
       // [progressIndicator setFrame:progressIndicatorFrame];
   // }

   /* File type icon */

   [[NSGraphicsContext currentContext] saveGraphicsState];
   float yOffset = cellFrame.origin.y;
   if ([controlView isFlipped]) {
       NSAffineTransform* xform = [NSAffineTransform transform];
       [xform translateXBy:0.0 yBy: cellFrame.size.height];
       [xform scaleXBy:1.0 yBy:-1.0];
       [xform concat];
       yOffset = 0-cellFrame.origin.y;
   }
   NSImage* icon = [[self dataDelegate] typeIconForCell:self data: data];

   NSImageInterpolation interpolation = [[NSGraphicsContext currentContext] imageInterpolation];
   [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];

   [icon drawInRect:NSMakeRect(cellFrame.origin.x+5,yOffset+3,cellFrame.size.height-6, cellFrame.size.height-6)
           fromRect:NSMakeRect(0,0,[icon size].width, [icon size].height)
          operation:NSCompositeSourceOver
           fraction:1.0];

   [[NSGraphicsContext currentContext] setImageInterpolation: interpolation];
   [[NSGraphicsContext currentContext] restoreGraphicsState];

   /* Ratio icon */

   [[NSGraphicsContext currentContext] saveGraphicsState];
   yOffset = cellFrame.origin.y;
   if ([controlView isFlipped]) {
       NSAffineTransform* xform = [NSAffineTransform transform];
       [xform translateXBy:0.0 yBy: cellFrame.size.height];
       [xform scaleXBy:1.0 yBy:-1.0];
       [xform concat];
       yOffset = 0-cellFrame.origin.y;
   }

   NSImage* ratio = [[self dataDelegate] ratioIconForCell:self data: data];

   NSImageInterpolation ratioInterpolation = [[NSGraphicsContext currentContext] imageInterpolation];
   [[NSGraphicsContext currentContext] setImageInterpolation: NSImageInterpolationHigh];

   [ratio drawInRect:NSMakeRect(cellFrame.size.width-40,yOffset+3,cellFrame.size.height-6, cellFrame.size.height-6)
           fromRect:NSMakeRect(0,0,[ratio size].width, [ratio size].height)
          operation:NSCompositeSourceOver
           fraction:1.0];

   [[NSGraphicsContext currentContext] setImageInterpolation: ratioInterpolation];
   [[NSGraphicsContext currentContext] restoreGraphicsState];
}

#pragma mark -
#pragma mark Delegate methods

- (NSImage*) typeIconForCell: (ImageTextCell*) cell data: (NSObject*) data {
    if (typeIconKeyPath) {
        return [data valueForKeyPath: typeIconKeyPath];
    }
    return nil;
}

- (NSImage*) ratioIconForCell: (ImageTextCell*) cell data: (NSObject*) data {
    if (ratioIconKeyPath) {
        return [data valueForKeyPath: ratioIconKeyPath];
    }
    return nil;
}

- (NSString*) primaryTextForCell: (ImageTextCell*) cell data: (NSObject*) data {
    if (primaryTextKeyPath) {
        return [data valueForKeyPath: primaryTextKeyPath];
    }
    return nil;
}

- (NSString*) secondaryTextForCell: (ImageTextCell*) cell data: (NSObject*) data {
    if (primaryTextKeyPath) {
        return [data valueForKeyPath: secondaryTextKeyPath];
    }
    return nil;
}

@end
