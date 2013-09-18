//
//  FileHandler.m
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

#import "FileHandler.h"

@implementation FileHandler

@synthesize fileDetails, comments, checksum;
@synthesize vMac, BasiliskII, Sheepshaver, processor68000, processor68020, processor68030, processor68040, processorPPC;

- (void) readRomFileFrom:(NSString*)filePath {
    
    NSString *romPath = [[NSString alloc] initWithFormat:filePath];
    
    NSData * data = [NSData dataWithContentsOfFile:romPath];
    NSUInteger len = [data length];
    Byte * byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    
    NSNumber * size = [[NSNumber alloc] initWithUnsignedLong:len/2^20];
    
    checksum       = [NSString stringWithFormat: @"%X", ntohl(*(uint32 *)byteData)];
    vMac           = NO;
    BasiliskII     = NO;
    Sheepshaver    = NO;
    processor68000 = NO;
    processor68020 = NO;
    processor68030 = NO;
    processor68040 = NO;
    processorPPC   = NO;
    
    switch( ntohl(*(uint32 *)byteData) ) {
            
            // 64 KB
        case 0x28BA61CE:
            fileDetails = @"Identified as Mac 128";
            comments = @"First Macintosh ever made";
            processor68000 = YES;
            break;
        case 0x28BA4E50:
            fileDetails = @"Identified as Mac 512K";
            comments = @"Second Macintosh ever made";
            processor68000 = YES;
            break;
            // no basilisk
            
            // 128 KB
        case 0x4D1EEEE1:
            fileDetails = @"Identified as Mac Plus v1 Lonely Hearts";
            comments = @"This ROM was buggy and had 2 revisions\nv3 is more recommended";
            processor68000 = YES;
            break;
        case 0x4D1EEAE1:
            fileDetails = @"Identified as Mac Plus v2 Lonely Heifers";
            comments = @"This ROM was the second revision and still had some bugs\nv3 is more recommended";
            processor68000 = YES;
            break;
        case 0x4D1F8172:
            fileDetails = @"Identified as Mac Plus v3 Loud Harmonicas";
            comments = @"Best Mac Plus ROM, second revision from the original";
            vMac = YES;
            processor68000 = YES;
            break;
            // no basilisk
            
            // 256 KB
        case 0x97851DB6:
            fileDetails = @"Identified as Mac II v1";
            comments = @"First Mac II ROM, had a memory problem\nThis one is rare!";
            processor68020 = YES;
            break;
        case 0xB2E362A8:
            fileDetails = @"Identified as Mac SE";
            comments = @"";
            processor68000 = YES;
            break;
        case 0x9779D2C4:
            fileDetails = @"Identified as Mac II v2";
            comments = @"Mac II ROM's revision";
            processor68020 = YES;
            break;
        case 0xB306E171:
            fileDetails = @"Identified as Mac SE FDHD";
            comments = @"FDHD stands for 'Floppy Disk High Density'\nThis mac was later called Macintosh SE Superdrive";
            processor68000 = YES;
            break;
        case 0x97221136:
            fileDetails = @"Identified as Mac IIx or IIcx or SE/30"; //Identified as Mac IIcx
            //IIx = 16 MHz Motorola 68020 CPU and 68881 FPU of the II with a 68030 CPU and 68882 FPU (running at the same clock speed)
            //Spock / Stratos
            //IIcx = c for compact
            comments = @"'32-bit dirty' ROM, since it has code using 24-bit addressing.\n'x' stands for the 68030 processor family, 'c' stands for 'compact'\nApple used 'SE/30' to avoid the acronym 'SEx'";
            processor68020 = YES;
            processor68030 = YES;
            break;
            // no basilisk
        case 0x96CA3846:
            fileDetails = @"Identified as Macintosh Portable";
            comments = @"One of the first 'laptops'!";
            processor68000 = YES;
            break;
        case 0xA49F9914:
            fileDetails = @"Identified as Macintosh Classic (XO)";
            comments = @"From Mac Classic with XO ROMDisk: It has the ability to boot from ROM by holding down cmd+opt+x+o at startup.\nLimited support in Basilisk II.";//Classic emulation is broken on Basilisk
            vMac = YES;
            processor68000 = YES;
            break;
        case 0x96645F9C:
            fileDetails = @"Identified as Macintosh PowerBook 100";
            comments = @"";
            processor68030 = YES;
            processor68040 = YES;
            break;

            // 512 KB
        case 0x4147DD77:
            fileDetails = @"Identified as Mac IIfx";
            comments = @"Known as Stealth, Blackbird, F-16, F-19, Four Square, IIxi, Zone 5 and Weed-Whacker.\nEmulation requires FPU and AppleTalk is not supported.";
            BasiliskII = YES;
            processor68030 = YES;
            break;
        case 0x350EACF0:
            fileDetails = @"Identified as Mac LC (Pizza box)";
            comments = @"AppleTalk is not supported in Basilisk.";
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            break;
        case 0x3193670E:
            //            if (512k) {
            
            fileDetails = @"Identified as Mac Classic II";
            comments = @"Emulation may require the FPU and AppleTalk may not be supported.";
            comments = [NSString stringWithFormat: @"Size is %ul", [size intValue]]; //3193670E
            
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            
            //            } else if(1024k) {
            
            //            }
            
            break;            
        case 0x368CADFE:
            fileDetails = @"Identified as Mac IIci";
            comments = @"In Basilisk, FPU must be enabled and appleTalk is not supported.\nThis is a 32-bit clean ROM.";
            BasiliskII = YES;
//            processor68020 = YES;
            processor68030 = YES;
//            processor68040 = YES;
            break;
        case 0x36B7FB6C:
            fileDetails = @"Identified as Mac IIsi";
            comments = @"In Basilisk, AppleTalk is not supported.";
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            break;
        case 0x35C28F5F:
            fileDetails = @"Mac LC II (Pizza box) or Performa 400/405/410/430"; //IIci?
            comments = @"In Basilisk, AppleTalk is not supported.";
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            break;
            //------------------------------------------------
        case 0x35C28C8F: //very strange didn't find it, called IIxi
            fileDetails = @"Identified as Mac IIx";
            comments = @"AppleTalk may not be supported.";
            BasiliskII = YES;
            break;
        case 0x4957EB49: 
            fileDetails = @"Identified as Mac IIvx (Brazil) or IIvi/Performa 600";
            comments = @"Mac IIvx was the last of Mac II series.\nAppleTalk may not be supported for emulation.";
            BasiliskII = YES;
            processor68030 = YES;
            break;

            
            //------------------------------------------------
            // Things get messy here
            // 1024 KB
        case 0x420DBFF3:
            fileDetails = @"Identified as Quadra 700/900 or PowerBook 140/170";
            comments = @"AppleTalk is not supported on Basilisk II.\nThis is the worst known 1MB ROM.";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        case 0x3DC27823:
            fileDetails = @"Identified as Macintosh Quadra 950";
            comments = @"AppleTalk is not supported on Basilisk II.";
            BasiliskII = YES;
            processor68040 = YES;
            break;
            //====
        case 0x49579803: //very strange didn't find it, called IIvx //49579803
            fileDetails = @"Identified as Mac IIvx ?"; //Again? Brazil?
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            break;
        case 0xE33B2724:
            fileDetails = @"Identified as Powerbook 160/165/165c/180/180c";
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            break;
        case 0xECFA989B:
            fileDetails = @"Identified as Powerbook 210/230/250";
            processor68030 = YES;
            break;
        case 0xEC904829:
            fileDetails = @"Identified as Mac LC III";
            BasiliskII = YES;
            processor68030 = YES;
            break;
        case 0xECBBC41C:
            fileDetails = @"Identified as Mac LCIII/LCIII+ or Performa 460";
            BasiliskII = YES;
            processor68030 = YES;
            break;
        case 0xECD99DC0:
            fileDetails = @"Identified as Mac Color Classic / Performa 250";
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            break;
        case 0xF1A6F343:
            fileDetails = @"Identified as Quadra/Centris 610 or 650";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        case 0xF1ACAD13:	// Mac Quadra 650
            fileDetails = @"Identified as Quadra/Centris 610 or 650 or 800";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        case 0x0024D346:
            fileDetails = @"Identified as Powerbook Duo 270C";
            processor68030 = YES;
            break;
        case 0xEDE66CBD:
            fileDetails = @"Color Classic II, LC 550, Performa 275/550/560, Mac TV";//Maybe Performa 450-550";
            BasiliskII = YES;
            processor68030 = YES;
            break;
        case 0xFF7439EE:
            fileDetails = @"LC 475/575 Quadra 605 Performa 475/476/575/577/578";
            comments = @"Codename Aladdin";
            BasiliskII = YES;
            processor68040 = YES; //FPU?
            break;
        case 0x015621D7:
            fileDetails = @"Identified as Powerbook Duo 280 or 280C";
            processor68030 = YES;
            break;
        case 0x06684214:
            fileDetails = @"Identified as LC/Quadra/Performa 630";
            comments = @"Codename Crusader";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        case 0xFDA22562:
            fileDetails = @"Identified as Powerbook 150";
            processor68030 = YES;
            break;
        case 0x064DC91D:
            fileDetails = @"Identified as LC/Performa 580/588";
            comments = @"AppleTalk is reported to work in Basilisk II.";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        //------------------------------------------------
        // 2MB and 3MB ROMs
        // 2048 KB
        case 0xB6909089:
            fileDetails = @"PowerBook 520 520c 540 540c";
            comments = @"2MB ROM image. =D";
            //68LC040
            break;
        case 0x5BF10FD1:
            fileDetails = @"Macintosh Quadra 660av or 840av";
            processor68040 = YES;
            processorPPC   = YES;
            break;
        case 0x4D27039C:
            fileDetails = @"PowerBook 190 or 190cs";
            comments = @"2MB ROM image. =D";
//            BasiliskII = YES;
//            processor68040 = YES; processor: 68LC040
            break;
            
            
        //------------------------------------------------
        // 4MB
        case 0x96CD923D:
            fileDetails = @"Probably PPC Quadra Power Mac 7200&7500&8500&9500 v1";
            comments = @"Runs on Sheepshaver";
            Sheepshaver = YES;
            break;
//            1994-03 - 9FEB69B3 - Power Mac 6100 & 7100 & 8100.ROM            
//            1994-04 - 9C7C98F7 - Workgroup Server 9150 80MHz.ROM
//            1995-01 - 9B7A3AAD - Power Mac 7100 (newer).ROM
//            1995-04 - 63ABFD3F - Power Mac & Performa 5200,5300,6200,6300.ROM
//            1995-04 - 9B037F6F - Workgroup Server 9150 120MHz.ROM
//            1995-08 - 83C54F75 - Powerbook 2300 & PB5x0 PPC Upgrade.ROM
//            1995-08 - 9630C68B - Power Mac 7200&7500&8500&9500 v2.ROM
//            1995-08 - 96CD923D - Power Mac 7200&7500&8500&9500 v1.ROM
//            1996-08 - 6F5724C0 - PowerMac, Performa 6400.ROM
//            1996-10 - 83A21950 - PowerBook 1400, 1400cs.ROM
//            1997-02 - 6E92FE08 - Power Mac 6500.ROM
//            1997-02 - 960E4BE9 - Power Mac 7300 & 7600 & 8600 & 9600 (v1).ROM
//            1997-02 - 960FC647 - Power Mac 8600 & 9600 (v2).ROM
//            1997-11 - 78F57389 - Power Mac G3 (v3).ROM
//            1997-11 - 79D68D63 - Power Mac G3 desktop.ROM
//            1998-03 - CBB01212 - PowerBook G3 Wallstreet.ROM
//            1998-08 - B46FFB63 - PowerBook G3 Wallstreet PDQ.ROM
            
            
            
        case 0x3C434852:
            fileDetails = @"The famous New World ROM from Apple's update";
            comments = @"Runs on Sheepshaver";
            Sheepshaver = YES;
            break;
            
        default:            
            
            fileDetails = @"Unknown ROM";
            switch([size intValue]) {
                case 1048576:
                    break;
                case 524288:
                    fileDetails = @"AppleTalk is not supported.";
                    break;
                case 262144:
                    break;

//                case 2097172:
//                    
//                    if (sheepshaverEnabled) {
//                        fileDetails  = @"Power Mac (Old World ROM)";
//                        romCondition = PerfectSheepOld;
//                    }else{
//                        fileDetails = @"Unsupported ROM size";
//                        comments = [NSString stringWithFormat: @"%d", [size intValue]];
//                    }
//                    
//                    break;                   
                    
                default:
                    fileDetails = @"Unsupported ROM size.";
                    comments = [NSString stringWithFormat: @"%d", [size intValue]];
                break;
            }
            break;
    }
    //http://www.jagshouse.com/rom.html
    //http://mess.redump.net/mess/driver_info/mac_technical_notes
    //http://minivmac.sourceforge.net/mac68k.html
    //http://www.emulators.com/softmac.htm
    //http://www.theoldcomputer.com/roms/index.php?folder=BIOS-System-Boot/Apple
    
    //http://support.apple.com/kb/TA29027?viewlocale=en_US&locale=en_US
    //http://macintoshgarden.org/forum/project-looking-mac-roms
    //http://minivmac.sourceforge.net/extras/egretrom.html
    //https://en.wikipedia.org/wiki/Macintosh_Performa
    //https://en.wikipedia.org/wiki/Timeline_of_Apple_Macintosh_models
    
    
    [size release];
    
    [romPath release];
}

@end
