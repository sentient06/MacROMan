//
//  RomFileController.h
//  Mac ROMan
//
//  Created by Giancarlo Mariot on 25/10/2013.
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

#import <Foundation/Foundation.h>

enum EmulatorTypes {
    vMacNormal   = 1
  , vMacSpecial  = 2
  , BasiliskII   = 3
  , vMacBasilisk = 4
  , Sheepshaver  = 5
  , Unsupported  = 6
};

@interface RomFileController : NSObject {
    /// 32-bit compatibility -------    
    id macModel;
    id comments;
    id checksum;
    int emulator;
    int fileSize;
    /// ----------------------------
}

@property (assign) int emulator;
@property (assign) int fileSize;
@property (copy) NSString * macModel;
@property (copy) NSString * comments;
@property (copy) NSString * checksum;

+ (BOOL)validateFile:(NSString *)filePath;

- (void)parseFile:(NSString *)filePath;

//- (void)readRomFileFrom:(NSString *)filePath;

@end
