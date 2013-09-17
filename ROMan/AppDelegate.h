//
//  AppDelegate.h
//  ROMan
//
//  Created by Giancarlo Mariot on 27/02/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DropView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSMutableArray * listOfFiles;
//    IBOutlet DropView *dropViewObject;
//    NSString * details;
//    NSString * comments;
//    NSString * checksum;
//    IBOutlet NSMenuItem *menuMainWindow;
}

@property (assign) IBOutlet NSWindow * window;
@property (copy) NSMutableArray * listOfFiles;
@property (copy) NSString * details, * comments, * checksum;

- (void)setDetails:(NSString*)newDetails AndComments:(NSString *)newComments;
- (void)setDetails:(NSString*)newDetails AndComments:(NSString *)newComments AndChecksum:(NSString *)newChecksum;
//- (IBAction)showMainWindow:(id)sender;

@end
