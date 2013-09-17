//
//  DropView.m
//  DragDropApp
//
//  Created by Giancarlo Mariot on 28/02/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//

#import "DropView.h"
#import "FileHandler.h"
#import "AppDelegate.h"

@implementation DropView


- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask])
        == NSDragOperationGeneric) {
//        return NSDragOperationGeneric;
        return NSDragOperationCopy;
    }else{
        return NSDragOperationNone;
    }
}

//- (void)draggingExited:(id<NSDraggingInfo>)sender {
//    
//}

//- (void)draggingEnded:(id < NSDraggingInfo >)sender {
//    [self setImage:[NSImage imageNamed:@"RomImageDocument.icns"]];
//    //return [super draggingEnded:sender];
//}

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
    
    NSLog(@"%@", kind);
    
    //Define what to do:
//    if ([[pathExtension lowercaseString]    isEqualTo:@"png"]
//        || isDir
//        ) {
//        returnValue = NO;
//    }else{
//        returnValue = YES;
//    }

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
    
    NSPasteboard* pboard = [sender draggingPasteboard];
    NSArray* urls = [pboard propertyListForType:NSFilenamesPboardType]; 
    
//    Singleton *aSingleton = [Singleton sharedSingleton];
//    [aSingleton setPathList:urls];
    

    NSString *pathExtension = [[urls objectAtIndex:0] pathExtension];
    
    if ([[pathExtension lowercaseString]    isEqualTo:@"rom"] ) {
        [self setImage:[NSImage imageNamed:@"RomImageDocument.icns"]];
        
        FileHandler *aFileHandler = [[FileHandler alloc] init];
        [aFileHandler readRomFileFrom:[urls objectAtIndex:0]];
        
        [[NSApp delegate] setDetails:[aFileHandler fileDetails] AndComments:[aFileHandler comments]AndChecksum:[aFileHandler checksum]];
        
        [aFileHandler release];
        
    }else
    if ([[pathExtension lowercaseString]    isEqualTo:@""]    ) {
        [self setImage:[NSImage imageNamed:@"GenericQuestionMarkIcon.icns"]];
        
        FileHandler *aFileHandler = [[FileHandler alloc] init];
        [aFileHandler readRomFileFrom:[urls objectAtIndex:0]];
        
        [[NSApp delegate] setDetails:[aFileHandler fileDetails] AndComments:[aFileHandler comments] AndChecksum:[aFileHandler checksum]];
        
        [aFileHandler release];
        
    }else{
        [self setImage:[NSImage imageNamed:@"Unsupported.icns"]];
        
        [[NSApp delegate] setDetails:@"Invalid format" AndComments:@""];
        
    }

    
    
    //-----
    /*
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:@"/bin/file"];
    [task setArguments:[NSArray arrayWithObjects: [[allPaths pathList] objectAtIndex:0], nil]];
    [task launch];
    if ([task terminationStatus] != 0) {
        NSLog(@"an error occurred...");
    }
    [task release];  
    */
    
    //-----
    
    
    
//    NSLog(@"%@", [aSingleton pathList]);
//    NSLog(@"%@", [aSingleton romMessage]);

    return YES;
}

//- (void)setImage:(NSImage *)newImage {
//    //Overrides the image being defined.
//    
//    NSLog(@"%@",[newImage name]);
//    [super setImage:newImage];
//}

//- (id)initWithFrame:(NSRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
////        [self registerForDraggedTypes:[NSImage imagePasteboardTypes]];
////        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
////        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSURLPboardType, nil]];
////        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType, 
////                                       NSFilenamesPboardType, nil]];
//    }
//    
//    return self;
//}

@end
