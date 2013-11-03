//
//  RomFileController.m
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

#import "RomFileController.h"
#import "AppDelegate.h"

@implementation RomFileController

@synthesize emulator;
@synthesize fileSize;
@synthesize madeTest;
@synthesize macModel;
@synthesize comments;
@synthesize checksum;

/*!
 * @abstract Checks if file is of a valid format.
 */
+ (BOOL)validateFile:(NSString *)filePath {
    
    if (![[[filePath pathExtension] lowercaseString] isEqualTo:@"rom"])
        return NO;
    
    NSString * kind = nil;
    NSURL    * url = [NSURL fileURLWithPath:[filePath stringByExpandingTildeInPath]];

    LSCopyKindStringForURL((CFURLRef)url, (CFStringRef *)&kind);
    
    NSArray * fileKinds = [[[NSArray alloc]
        initWithObjects:
            @"Unix Executable File"
          , @"Document"
          , @"ROM Image"
          , nil
    ] autorelease];
    
    if ([fileKinds containsObject:kind])
         return YES;
    else return NO;
}

/*!
 * @abstract Parses ROM file.
 * @link     http://www.jagshouse.com/rom.html
 * @link     http://mess.redump.net/mess/driver_info/mac_technical_notes
 * @link     http://minivmac.sourceforge.net/mac68k.html
 * @link     http://www.emulators.com/softmac.htm
 * @link     http://www.theoldcomputer.com/roms/index.php?folder=BIOS-System-Boot/Apple
 * @link     http://support.apple.com/kb/TA29027?viewlocale=en_US&locale=en_US
 * @link     http://macintoshgarden.org/forum/project-looking-mac-roms
 * @link     http://minivmac.sourceforge.net/extras/egretrom.html
 * @link     https://en.wikipedia.org/wiki/Macintosh_Performa
 * @link     https://en.wikipedia.org/wiki/Timeline_of_Apple_Macintosh_models
 */
- (void)parseFile:(NSString *)filePath {
    
    if (![RomFileController validateFile:filePath]) {
        NSLog(@"File is not valid!");
        return;
    }
    
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    fileSize = (int) [data length];
    Byte * byteData = (Byte *)malloc(fileSize);
    memcpy(byteData, [data bytes], fileSize);

    checksum = [NSString stringWithFormat: @"%X", ntohl(*(uint32 *)byteData)];
    madeTest = NO;
    
    switch( ntohl(*(uint32 *)byteData) ) {
            
            // 64 KB
        case 0x28BA61CE:
            macModel = @"Macintosh 128";
            comments = @"First Macintosh ever made.\nThis ROM can't be used on emulation.";
            // processor68000 = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x28BA4E50:
            macModel = @"Macintosh 512K";
            comments = @"Second Macintosh ever made.\nThis ROM can't be used on emulation.";
            // processor68000 = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
            // no basilisk
            
            // 128 KB
        case 0x4D1EEEE1:
            macModel = @"Macintosh Plus v1 Lonely Hearts";
            comments = @"This ROM was buggy and had 2 revisions!\nvMac can't boot from it.\nThe second revision (v3) is more recommended.";
            // processor68000 = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x4D1EEAE1:
            macModel = @"Macintosh Plus v2 Lonely Heifers";
            comments = @"This ROM was the first revision and still had some bugs.\nv3 is more recommended.";
            emulator = vMacNormal;
            // processor68000 = YES;
            madeTest = YES;
            break;
        case 0x4D1F8172:
            macModel = @"Macintosh Plus v3 Loud Harmonicas";
            comments = @"Best Mac Plus ROM, second revision from the original.\nGood for vMac.";
            emulator = vMacNormal;
            // processor68000 = YES;
            madeTest = YES;
            break;
            // no basilisk
            
            // 256 KB
        case 0x97851DB6:
            macModel = @"Macintosh II v1";
            comments = @"First Mac II ROM, had a memory problem\nThis one is rare!\nvMac won't boot it.";//bug
            // processor68020 = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0xB2E362A8:
            macModel = @"Macintosh SE"; //no checksum
            comments = @"";
            // processor68000 = YES;
            break;
        case 0x9779D2C4:
            macModel = @"Macintosh II v2"; //no checksum
            comments = @"Mac II ROM's revision";
            // processor68020 = YES;
            break;
        case 0xB306E171:
            macModel = @"Macintosh SE FDHD"; //no checksum
            comments = @"FDHD stands for 'Floppy Disk High Density'\nThis mac was later called Macintosh SE Superdrive";
            // processor68000 = YES;
            break;
        case 0x97221136:
            macModel = @"Macintosh IIx or IIcx or SE/30"; //Mac IIcx
            //IIx = 16 MHz Motorola 68020 CPU and 68881 FPU of the II with a 68030 CPU and 68882 FPU (running at the same clock speed)
            //Spock / Stratos
            //IIcx = c for compact
            comments = @"'32-bit dirty' ROM, since it has code using 24-bit addressing.\n'x' stands for the 68030 processor family, 'c' stands for 'compact'\nApple used 'SE/30' to avoid the acronym 'SEx'";
            // processor68020 = YES;
            // processor68030 = YES;
            break;
            // no basilisk
        case 0x96CA3846:
            macModel = @"Macintosh Portable"; //vmac no checksum
            comments = @"One of the first 'laptops'!";
            // processor68000 = YES;
            break;
        case 0xA49F9914:
            macModel = @"Macintosh Classic (XO)";
            comments = @"From Mac Classic with XO ROMDisk: It has the ability to boot from ROM by holding down cmd+opt+x+o at startup.\nLimited support in Basilisk II.";//Classic emulation is broken on Basilisk
            emulator = vMacSpecial;
            // processor68000 = YES;
            break;
        case 0x96645F9C:
            macModel = @"Macintosh PowerBook 100";
            comments = @"";
            // processor68030 = YES;
            // processor68040 = YES;
            break;
            
            // 512 KB
        case 0x4147DD77:
            macModel = @"Macintosh IIfx";
            comments = @"Known as Stealth, Blackbird, F-16, F-19, Four Square, IIxi, Zone 5 and Weed-Whacker.\nEmulation requires FPU and AppleTalk is not supported.";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
        case 0x350EACF0:
            macModel = @"Macintosh LC";
            comments = @"AppleTalk is not supported in Basilisk.";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
        case 0x3193670E: //Mysterious 1024KB version?
            macModel = @"Macintosh Classic II";
            comments = @"Emulation may require the FPU and AppleTalk may not be supported.";         
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;            
            break;            
        case 0x368CADFE:
            macModel = @"Macintosh IIci";
            comments = @"In Basilisk, FPU must be enabled and appleTalk is not supported.\nThis is a 32-bit clean ROM.";
            emulator = BasiliskII;
            //            // processor68020 = YES;
            // processor68030 = YES;
            //            // processor68040 = YES;
            break;
        case 0x36B7FB6C:
            macModel = @"Macintosh IIsi";
            comments = @"In Basilisk, AppleTalk is not supported.";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
        case 0x35C28F5F:
            macModel = @"Mac LC II or Performa 400/405/410/430"; //IIci?
            comments = @"In Basilisk, AppleTalk is not supported.";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
            //------------------------------------------------
        case 0x35C28C8F: //very strange didn't find it, called IIxi
            macModel = @"Macintosh IIx";
            comments = @"AppleTalk may not be supported.";
            emulator = BasiliskII;
            break;
        case 0x4957EB49: 
            macModel = @"Mac IIvx (Brazil) or IIvi/Performa 600";
            comments = @"Mac IIvx was the last of Mac II series.\nAppleTalk may not be supported for emulation.";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
            
            
            //------------------------------------------------
            // Things get messy here
            // 1024 KB
        case 0x420DBFF3:
            macModel = @"Quadra 700/900 or PowerBook 140/170";
            comments = @"AppleTalk is not supported on Basilisk II.\nThis is the worst known 1MB ROM.";
            emulator = BasiliskII;
            // processor68040 = YES;
            madeTest = YES;
            break;
        case 0x3DC27823:
            macModel = @"Macintosh Quadra 950";
            comments = @"AppleTalk is not supported on Basilisk II.";
            emulator = BasiliskII;
            // processor68040 = YES;
            madeTest = YES;
            break;
            //====
        case 0x49579803: //very strange didn't find it, called IIvx //49579803
            macModel = @"Macintosh IIvx ?"; //Again? Brazil?
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            break;
        case 0xE33B2724:
            macModel = @"Powerbook 160/165/165c/180/180c";
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
        case 0xECFA989B:
            macModel = @"Powerbook 210/230/250";
            // processor68030 = YES;
            break;
        case 0xEC904829:
            macModel = @"Macintosh LC III";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
        case 0xECBBC41C:
            macModel = @"Macintosh LCIII/LCIII+ or Performa 460";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
        case 0xECD99DC0:
            macModel = @"Macintosh Color Classic / Performa 250";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
        case 0xF1A6F343:
            macModel = @"Quadra/Centris 610 or 650";
            emulator = BasiliskII;
            // processor68040 = YES;
            break;
        case 0xF1ACAD13:	// Mac Quadra 650
            macModel = @"Quadra/Centris 610 or 650 or 800";
            emulator = BasiliskII;
            // processor68040 = YES;
            madeTest = YES;
            break;
        case 0x0024D346:
            macModel = @"Powerbook Duo 270C";
            // processor68030 = YES;
            break;
        case 0xEDE66CBD:
            macModel = @"Color Classic II, LC 550, Performa 275/550/560 & Mac TV";//Maybe Performa 450-550";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
        case 0xFF7439EE:
            macModel = @"LC 475/575, Quadra 605 & Performa 475/476/575/577/578";
            comments = @"Codename Aladdin";
            emulator = BasiliskII;
            // processor68040 = YES; //FPU?
            madeTest = YES;
            break;
        case 0x015621D7:
            macModel = @"Powerbook Duo 280 or 280C";
            // processor68030 = YES;
            break;
        case 0x06684214:
            macModel = @"LC/Quadra/Performa 630";
            comments = @"Codename Crusader";
            emulator = BasiliskII;
            // processor68040 = YES;
            madeTest = YES;
            break;
        case 0xFDA22562:
            macModel = @"Powerbook 150";
            // processor68030 = YES;
            break;
        case 0x064DC91D:
            macModel = @"LC/Performa 580/588";
            comments = @"AppleTalk is reported to work in Basilisk II.";
            emulator = BasiliskII;
            // processor68040 = YES;
            break;
            //------------------------------------------------
            // 2MB and 3MB ROMs
            // 2048 KB
        case 0xB6909089:
            macModel = @"PowerBook 520/520c/540/540c";
            comments = @"2MB ROM image. (There are two known others)";
            //68LC040
            break;
        case 0x5BF10FD1:
            macModel = @"Macintosh Quadra 660av or 840av";
            // processor68040 = YES;
            // processorPPC   = YES;
            break;
        case 0x4D27039C:
            macModel = @"PowerBook 190 or 190cs";
            comments = @"2MB ROM image. (There are two known others)";
            //            emulator = BasiliskII;
            //            // processor68040 = YES; processor: 68LC040
            break;
            
            
            //------------------------------------------------
            // 4MB
        case 0x9FEB69B3:
            macModel = @"Power Mac 6100/7100/8100";
            // processorPPC   = YES;
            break;
        case 0x9C7C98F7:
            macModel = @"Workgroup Server 9150 80MHz";
            // processorPPC   = YES;
            break;
        case 0x9B7A3AAD:
            macModel = @"Power Mac 7100 (newer)";
            // processorPPC   = YES;
            break;
        case 0x63ABFD3F:
            macModel = @"Power Mac & Performa 5200/5300/6200/6300";
            // processorPPC   = YES;
            break;
        case 0x9B037F6F:
            macModel = @"Workgroup Server 9150 120MHz";
            // processorPPC   = YES;
            break;
        case 0x83C54F75:
            macModel = @"PowerBook 2300 & PB5x0 PPC Upgrade";
            // processorPPC   = YES;
            break;
        case 0x9630C68B:
            macModel = @"Power Mac 7200/7500/8500/9500 v2";
            // processorPPC   = YES;
            break;
        case 0x96CD923D:
            macModel = @"Power Mac 7200/7500/8500/9500 v1"; //Probably PPC Quadra
            comments = @"";
            emulator = Sheepshaver;
            // processorPPC   = YES;
            madeTest = YES;
            break;
        case 0x6F5724C0:
            macModel = @"PowerMac/Performa 6400";
            // processorPPC   = YES;
            break;
        case 0x83A21950:
            macModel = @"PowerBook 1400 or 1400cs";
            // processorPPC   = YES;
            break;
        case 0x6E92FE08:
            macModel = @"Power Mac 6500";
            // processorPPC   = YES;
            break;
        case 0x960E4BE9:
            macModel = @"Power Mac 7300/7600/8600/9600 (v1)";
            // processorPPC   = YES;
            break;
        case 0x960FC647:
            macModel = @"Power Mac 8600 or 9600 (v2)";
            // processorPPC   = YES;
            break;
        case 0x78F57389:
            macModel = @"Power Mac G3 (v3)";
            // processorPPC   = YES;
            break;
        case 0x79D68D63:
            macModel = @"Power Mac G3 desktop";
            // processorPPC   = YES;
            break;
        case 0xCBB01212:
            macModel = @"PowerBook G3 Wallstreet";
            // processorPPC   = YES;
            break;
        case 0xB46FFB63:
            macModel = @"PowerBook G3 Wallstreet PDQ";
            // processorPPC   = YES;
            break;

            //------------------------------------------------
            // New world
        case 0x3C434852:
            macModel = @"Mac OS ROM 1.6";
            comments = @"The famous New World ROM from Apple's update";
            emulator = Sheepshaver;
            madeTest = YES;
            break;
            
        default:            
            // Unknown
            macModel = @"Unknown ROM";
            switch(fileSize) {
                case 65536: //64KB
                case 131072: //128KB
                case 262144: //256KB
                    break;
                case 524288: //512KB
                    comments = @"Try running on Basilisk II, without AppleTalk";
                    break;
                case 1048576: //1MB
                    comments = @"Maybe it runs on Basilisk II";
                    break;
                case 2097152: //2MB
                case 3145728: //3MB
                case 4194304: //4MB
                    comments = @"Maybe it runs on Sheepshaver";
                    break;
                default:
                    macModel = @"Unsupported ROM size.";
                    comments = @"Size should be 64KB, 128KB, 256KB, 512KB, 1MB, 2MB, 3MB or 4MB.";
                    emulator = Unsupported;
                    break;
                    
            }
            break;
    }

}

@end
