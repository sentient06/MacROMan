//
//  EmulatorNameValueTransformer.m
//  Mac ROMan
//
//  Created by Giancarlo Mariot on 23/09/2013.
//  Updated by Em Adespoton on 30/10/2018.
//  Copyright (c) 2013 Giancarlo Mariot. All rights reserved.
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

#import "EmulatorNameValueTransformer.h"
#import "RomFileController.h"

@implementation EmulatorNameValueTransformer

+ (Class)transformedValueClass {
    return [NSString class]; 
}

+ (BOOL)allowsReverseTransformation { 
    return NO; 
}

- (id)transformedValue:(id)value {

    int iconValue = [value intValue];

    switch (iconValue) {
        case vMacNormal:
            return @"Mini vMac (standard)";
        case vMacSpecial:
            return @"Mini vMac (model-compiled)";
        case BasiliskII:
            return @"Basilisk II";
        case vMacBasilisk:
            return @"Mini vMac & Basilisk II";
        case Sheepshaver:
            return @"Sheepshaver";
        case QEMU:
            return @"QEMU";
        case SheepshaverQEMU:
            return @"Sheepshaver & QEMU";
        case Unsupported:
            return @"Unsupported";
            
    }
    
    return nil;

}

@end
