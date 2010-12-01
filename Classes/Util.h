//
//  Util.h
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLRPCRequest.h"

@interface Util : NSObject {
}

+ (void)doGrowl:(NSString *)title withMessage:(NSString *)message;
+ (id)executeXMLRPCRequest:(XMLRPCRequest *)req;
+ (void)openWebsite;
+ (void)showError:(NSString *)info withMessage:(NSString *)message;

@end
