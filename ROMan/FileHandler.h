//
//  FileHandler.h
//  ROMan
//
//  Created by Giancarlo Mariot on 27/02/2012.
//  Copyright (c) 2012 Giancarlo Mariot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHandler : NSObject {
@private

}

@property (copy) NSString * fileDetails, * comments, * checksum;

- (void) readRomFileFrom:(NSString*)filePath;

@end
