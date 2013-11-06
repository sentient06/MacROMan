//
//  AppDelegate.h
//  Mac ROMan
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

#import <Cocoa/Cocoa.h>
#import "DropView.h"

@class RomFileController;

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    BOOL loadedFile;
    /// 32-bit compatibility -------    
    id _window;
    id _fileIcon;
    id macModel;
    id comments;
    id checksum;
    id codeName;
    int emulator;
    int fileSize;
    int madeTest;
    /// ----------------------------
}

@property (assign) IBOutlet NSWindow    * window;
@property (assign) IBOutlet NSImageView * fileIcon;

@property (assign) int emulator;
@property (assign) int fileSize;
@property (assign) int madeTest;
@property (copy) NSString * macModel;
@property (copy) NSString * comments;
@property (copy) NSString * checksum;
@property (copy) NSString * codeName;

- (void)setFileIconPlaceholder:(NSImage *)newIcon;
- (void)setVariablesFromRomController:(RomFileController *)romFileController;

@end
