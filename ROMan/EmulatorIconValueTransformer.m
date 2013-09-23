//
//  EmulatorIconValueTransformer.m
//  ROMan
//
//  Created by Giancarlo Mariot on 19/09/2013.
//  Copyright (c) 2013 Giancarlo Mariot. All rights reserved.
//

#import "EmulatorIconValueTransformer.h"

@implementation EmulatorIconValueTransformer

+ (Class)transformedValueClass {
    return [NSImage class]; 
}
+ (BOOL)allowsReverseTransformation { 
    return NO; 
}

- (id)transformedValue:(id)value {
    
    long iconValue = [value integerValue];
    
    // 0 = None
    // 1 = vMac
    // 2 = BasiliskII
    // 3 = vMacBasilisk
    // 4 = Sheepshaver
    // 5 = Unsupported
    
    NSLog(@"Icon Value Transformer - value: %@ -- %ld", value, iconValue);
    
    switch (iconValue) {
        case 1:
            return [NSImage imageNamed:@"vMac.png"];
        case 2:
            return [NSImage imageNamed:@"BasiliskII.png"];
        case 3:
            return [NSImage imageNamed:@"Basilisk.png"];
        case 4:
            return [NSImage imageNamed:@"Sheepshaver.png"];
        case 5:
            return [NSImage imageNamed:@"None.png"];
            
    }
    
    return nil;//[NSImage imageNamed:@"None.png"];
}

@end
