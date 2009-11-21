//
//  ImageTextCell.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTextCell : NSTextFieldCell {
    NSObject* delegate;
    NSString* typeIconKeyPath;
    NSString* ratioIconKeyPath;
    NSString* primaryTextKeyPath;
    NSString* secondaryTextKeyPath;
    NSProgressIndicator *progressIndicator;
}

- (void) setDataDelegate: (NSObject*) aDelegate;
- (void) setTypeIconKeyPath: (NSString*) path;
- (void) setRatioIconKeyPath: (NSString*) path;
- (void) setPrimaryTextKeyPath: (NSString*) path;
- (void) setSecondaryTextKeyPath: (NSString*) path;

@end

@interface NSObject(ImageTextCellDelegate)

- (NSImage*) typeIconForCell: (ImageTextCell*) cell data: (NSObject*) data;
- (NSImage*) ratioIconForCell: (ImageTextCell*) cell data: (NSObject*) data;
- (NSString*) primaryTextForCell: (ImageTextCell*) cell data: (NSObject*) data;
- (NSString*) secondaryTextForCell: (ImageTextCell*) cell data: (NSObject*) data;
- (NSObject*) dataElementForCell: (ImageTextCell*) cell;

- (BOOL) disabledForCell: (ImageTextCell*) cell data: (NSObject*) data;

@end
