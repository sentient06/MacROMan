//
//  DropView.m
//  Mac ROMan
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
#import "RomFileController.h"
#import "AppDelegate.h"

@implementation DropView

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    int dragOperationType = NSDragOperationGeneric & [sender draggingSourceOperationMask];
    if (dragOperationType == NSDragOperationGeneric)
         return NSDragOperationCopy;
    else return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    // All pasteboard:
    NSPasteboard * pboard = [sender draggingPasteboard];
    NSArray      * urls   = [pboard propertyListForType:NSFilenamesPboardType];
    // First element only:
    NSString * firstElement  = [[[NSString alloc] initWithFormat:[urls objectAtIndex:0]] autorelease];
    BOOL validFile = [RomFileController validateFile:[firstElement stringByExpandingTildeInPath]];
    if (validFile) return YES;
    return NO;
}

- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender {
    NSPasteboard      * pboard            = [sender draggingPasteboard];
    NSArray           * urls              = [pboard propertyListForType:NSFilenamesPboardType];
    RomFileController * romFileController = [[RomFileController alloc] init];
    [romFileController parseFile:[urls objectAtIndex:0]];
    [[NSApp delegate] setVariablesFromRomController:romFileController];
    [romFileController release];
    return YES;
}

@end
