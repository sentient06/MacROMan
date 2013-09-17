//
//  FileDetails.h
//  ROMan
//
//  Created by Giancarlo Mariot on 12/03/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileObject : NSObject {
@private
    NSString *path;
    NSString *model;
    NSString *bytes;
    //BOOL recongnised;
    NSImage *icon;
}

@property (copy) NSString *path, *model, *bytes;
@property (assign) NSImage *icon;
//@property BOOL recognised;

// NSImage *iconImage = [[NSWorkspace sharedWorkspace] iconForFile: [urls objectAtIndex:i]];

@end
