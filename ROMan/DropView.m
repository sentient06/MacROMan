//
//  DropView.m
//  DragDropApp
//
//  Created by Giancarlo Mariot on 28/02/2012.
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

#import "DropView.h"
#import "FileHandler.h"
#import "AppDelegate.h"

@implementation DropView


- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask])
        == NSDragOperationGeneric) {
        return NSDragOperationCopy;
    }else{
        return NSDragOperationNone;
    }
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    
    BOOL returnValue;
    
    //All pasteboard:
    NSPasteboard* pboard = [sender draggingPasteboard];
    NSArray* urls = [pboard propertyListForType:NSFilenamesPboardType];
    //First element only:
    NSString* firstElement = [[NSString alloc] initWithFormat:[urls objectAtIndex:0]];
    NSString *pathExtension = [[NSString alloc] initWithFormat:[firstElement pathExtension]];
    
    //Check if is a folder:
    BOOL isDir;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    [fileManager fileExistsAtPath:firstElement isDirectory:&isDir];
    
    NSString *kind = nil;
    NSURL *url = [NSURL fileURLWithPath:[firstElement stringByExpandingTildeInPath]];
    LSCopyKindStringForURL((CFURLRef)url, (CFStringRef *)&kind);

    if (
        [kind isEqualToString:@"Unix Executable File"] ||
        [kind isEqualToString:@"Document"]
        ) {
        returnValue = YES;
    }else{
        returnValue = NO;
    }
        
    
    [fileManager release];
    [pathExtension release];
    [firstElement release];
    
    return returnValue;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    
    NSPasteboard * pboard = [sender draggingPasteboard];
    NSArray  * urls = [pboard propertyListForType:NSFilenamesPboardType];
    NSString * pathExtension = [[urls objectAtIndex:0] pathExtension];
    
    if ([[pathExtension lowercaseString] isEqualTo:@"rom"] ) {
        [self setImage:[NSImage imageNamed:@"RomImageDocument.icns"]];
        
        FileHandler * aFileHandler = [[FileHandler alloc] init];
        [aFileHandler readRomFileFrom:[urls objectAtIndex:0]];
        
        [[NSApp delegate] setDetails:[aFileHandler fileDetails]];
        [[NSApp delegate] setComments:[aFileHandler comments]];
        [[NSApp delegate] setChecksum:[aFileHandler checksum]];
        [[NSApp delegate] setRomSize:[aFileHandler romSize]];
        
        int emulatorValue = 0;
        
        if ([aFileHandler vMac] && [aFileHandler BasiliskII] ) emulatorValue = 3;
        else if ([aFileHandler vMac]       ) emulatorValue = 1;
        else if ([aFileHandler BasiliskII] ) emulatorValue = 2;
        else if ([aFileHandler Sheepshaver]) emulatorValue = 4;
        else if ([aFileHandler unsupported]) emulatorValue = 5;

        [[NSApp delegate] setSupportedEmulators:[NSNumber numberWithInt:emulatorValue]];
        [[NSApp delegate] setMoreInfo:[aFileHandler moreInfo]];
            
        
        [aFileHandler release];
        
    } else if ([[pathExtension lowercaseString] isEqualTo:@""] ) {
        
        FileHandler * aFileHandler = [[FileHandler alloc] init];
        [aFileHandler readRomFileFrom:[urls objectAtIndex:0]];
        
        [[NSApp delegate] setDetails:[aFileHandler fileDetails]];
        [[NSApp delegate] setComments:[aFileHandler comments]];
        [[NSApp delegate] setChecksum:[aFileHandler checksum]];
        [[NSApp delegate] setRomSize:[aFileHandler romSize]];
        [self setImage:[NSImage imageNamed:@"GenericQuestionMarkIcon.icns"]];
        
        [aFileHandler release];
        
    } else {
        
        [self setImage:[NSImage imageNamed:@"Unsupported.icns"]];        
        [[NSApp delegate] setDetails:@"Invalid format" AndComments:@""];
        
    }

    return YES;
}

@end
