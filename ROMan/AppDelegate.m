//
//  AppDelegate.m
//  ROMan
//
//  Created by Giancarlo Mariot on 27/02/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//
//------------------------------------------------------------------------------
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
//------------------------------------------------------------------------------

#import "AppDelegate.h"
#import "RomFileController.h"

//------------------------------------------------------------------------------

@implementation AppDelegate

//------------------------------------------------------------------------------
// Application synthesisers.

@synthesize window = _window;

//------------------------------------------------------------------------------
// Standard variables synthesisers.

@synthesize fileIcon = _fileIcon;

@synthesize emulator;
@synthesize fileSize;
@synthesize macModel;
@synthesize comments;
@synthesize checksum;

//------------------------------------------------------------------------------
// Methods.

#pragma mark – Dealloc

- (void)setFileIconPlaceholder:(NSImage *)newIcon {
    [_fileIcon setImage:newIcon];
}

- (void)setVariablesFromRomController:(RomFileController *)romFileController {
    [self setMacModel:[romFileController macModel]];
    [self setComments:[romFileController comments]];
    [self setChecksum:[romFileController checksum]];
    [self setEmulator:[romFileController emulator]];
    [self setFileSize:[romFileController fileSize]];
    [self setFileIconPlaceholder:[NSImage imageNamed:@"RomImageDocument.icns"]];
}

//------------------------------------------------------------------------------
// Rewritten methods.

#pragma mark – Rewritten methods

///*!
// * @abstract Reopens closed window from Dock icon.
// * @link     Check XCode quick help.
// */
//- (BOOL)applicationShouldHandleReopen:(NSApplication *)app hasVisibleWindows:(BOOL)flag {
//    if (!flag) {
//        [_window makeKeyAndOrderFront:self];
//        return NO;
//    } else {
//        return YES;
//    }
//}

/*!
 * @abstract Quits application when window is closed.
 * @link     Check XCode quick help.
 */
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
    return YES;
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename {

    RomFileController * romFileController = [[RomFileController alloc] init];
    [romFileController parseFile:filename];
    [self setVariablesFromRomController:romFileController];
    [romFileController release];
    
    [_window makeKeyAndOrderFront:self];
    
    return YES;
}

//------------------------------------------------------------------------------
// Standard methods.

#pragma mark – Standard methods

- (id)init {
    self = [super init];
    if (self) {
        fileSize = -1;
    }
    return self;
}

/*!
 * @link Check XCode quick help.
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setMacModel:@"No ROM file detected"];
    [self setComments:@""];
}

@end
