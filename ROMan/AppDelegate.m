//
//  AppDelegate.m
//  ROMan
//
//  Created by Giancarlo Mariot on 27/02/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize listOfFiles;
@synthesize details, comments, checksum;

- (void)dealloc {
    [listOfFiles release];
    [super dealloc];
}
	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    listOfFiles = [[NSMutableArray alloc] initWithCapacity:1];
    [self setDetails:@"No ROM file detected"];
    [self setComments:@""];
}

- (void)setDetails:(NSString*)newDetails AndComments:(NSString *)newComments {
    [self setDetails:newDetails];
    [self setComments:newComments];
}

- (void)setDetails:(NSString *)newDetails AndComments:(NSString *)newComments AndChecksum:(NSString *)newChecksum {
    [self setDetails:newDetails];
    [self setComments:newComments];
    [self setChecksum:newChecksum];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)app hasVisibleWindows:(BOOL)flag {
    if (!flag) {
        [_window makeKeyAndOrderFront:self];
        return NO;
    } else {
        return YES;
    }
}

//- (IBAction)showMainWindow:(id)sender {
//    [_window makeKeyAndOrderFront:self];
//}

@end
