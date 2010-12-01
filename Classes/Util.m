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

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>

@implementation Util

+ (void)doGrowl:(NSString *)title withMessage:(NSString *)message {

    NSBundle *myBundle = [NSBundle bundleForClass:[Util class]];
    NSString *growlPath = [[myBundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
    NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];

    if (growlBundle && [growlBundle load]) {
        [GrowlApplicationBridge setGrowlDelegate:self];
        [GrowlApplicationBridge notifyWithTitle:title
                                    description:message
                               notificationName:@"Rogerian"
                                       iconData:nil
                                       priority:0
                                       isSticky:NO
                                   clickContext:[NSDate date]];
    } else {
        NSLog(@"ERROR: Could not load Growl.framework");
    }
}

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
