//
//  Util.m
//  tlaloc
//
//  Created by Gavin Gilmour on 18/10/2009.
//  Copyright 2009. All rights reserved.
//

#import "Util.h"
#import "Config.h"
#import "XMLRPCRequest.h"
#import "XMLRPCResponse.h"
#import "XMLRPCConnection.h"

@implementation Util

+ (id)executeXMLRPCRequest:(XMLRPCRequest *)req {
    XMLRPCResponse *userInfoResponse = [XMLRPCConnection sendSynchronousXMLRPCRequest:req];
    // NSLog(@"Response body: %@", [userInfoResponse body]);
    return [userInfoResponse object];
}

+ (void)openWebsite {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[Config productWebsite]]];
}

+ (void)showError:(NSString *)title withMessage:(NSString *)info {
    NSAlert* alert = [NSAlert new];
    [alert setMessageText: title];
    [alert setInformativeText: info];
    [alert setAlertStyle: NSCriticalAlertStyle];
    [alert runModal];
    [alert release];
}

@end
