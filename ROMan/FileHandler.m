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

@synthesize fileDetails, comments, checksum, moreInfo;
@synthesize vMac, BasiliskII, Sheepshaver, processor68000, processor68020, processor68030, processor68040, processorPPC;

- (void) readRomFileFrom:(NSString*)filePath {
    
    NSString *romPath = [[NSString alloc] initWithFormat:filePath];
    
    NSData * data = [NSData dataWithContentsOfFile:romPath];
    NSUInteger len = [data length];
    Byte * byteData = (Byte*)malloc(len);
    memcpy(byteData, [data bytes], len);
    
    NSNumber * size = [[NSNumber alloc] initWithUnsignedLong:len/2^20];
    
    checksum       = [NSString stringWithFormat: @"Checksum: %X", ntohl(*(uint32 *)byteData)];
    vMac           = NO;
    BasiliskII     = NO;
    Sheepshaver    = NO;
    processor68000 = NO;
    processor68020 = NO;
    processor68030 = NO;
    processor68040 = NO;
    processorPPC   = NO;
    moreInfo       = @"";
    
    switch( ntohl(*(uint32 *)byteData) ) {
            
            // 64 KB
        case 0x28BA61CE:
            fileDetails = @"Macintosh 128";
            comments = @"First Macintosh ever made.\nThis ROM can't be used on emulation.";
            processor68000 = YES;
            break;
        case 0x28BA4E50:
            fileDetails = @"Macintosh 512K";
            comments = @"Second Macintosh ever made.\nThis ROM can't be used on emulation.";
            processor68000 = YES;
            break;
            // no basilisk
            
            // 128 KB
        case 0x4D1EEEE1:
            fileDetails = @"Macintosh Plus v1 Lonely Hearts";
            comments = @"This ROM was buggy and had 2 revisions!\nvMac can't boot from it.\nThe second revision (v3) is more recommended.";
            processor68000 = YES;
            break;
        case 0x4D1EEAE1:
            fileDetails = @"Macintosh Plus v2 Lonely Heifers";
            comments = @"This ROM was the first revision and still had some bugs.\nv3 is more recommended.";
            vMac = YES;
            processor68000 = YES;
            break;
        case 0x4D1F8172:
            fileDetails = @"Macintosh Plus v3 Loud Harmonicas";
            comments = @"Best Mac Plus ROM, second revision from the original.\nGood for vMac.";
            vMac = YES;
            processor68000 = YES;
            break;
            // no basilisk
            
            // 256 KB
        case 0x97851DB6:
            fileDetails = @"Macintosh II v1";
            comments = @"First Mac II ROM, had a memory problem\nThis one is rare!\nvMac won't boot it.";//bug
            processor68020 = YES;
            break;
        case 0xB2E362A8:
            fileDetails = @"Macintosh SE"; //no checksum
            comments = @"";
            processor68000 = YES;
            break;
        case 0x9779D2C4:
            fileDetails = @"Macintosh II v2"; //no checksum
            comments = @"Mac II ROM's revision";
            processor68020 = YES;
            break;
        case 0xB306E171:
            fileDetails = @"Macintosh SE FDHD"; //no checksum
            comments = @"FDHD stands for 'Floppy Disk High Density'\nThis mac was later called Macintosh SE Superdrive";
            processor68000 = YES;
            break;
        case 0x97221136:
            fileDetails = @"Macintosh IIx or IIcx or SE/30"; //Mac IIcx
            //IIx = 16 MHz Motorola 68020 CPU and 68881 FPU of the II with a 68030 CPU and 68882 FPU (running at the same clock speed)
            //Spock / Stratos
            //IIcx = c for compact
            comments = @"'32-bit dirty' ROM, since it has code using 24-bit addressing.\n'x' stands for the 68030 processor family, 'c' stands for 'compact'\nApple used 'SE/30' to avoid the acronym 'SEx'";
            processor68020 = YES;
            processor68030 = YES;
            break;
            // no basilisk
        case 0x96CA3846:
            fileDetails = @"Macintosh Portable"; //vmac no checksum
            comments = @"One of the first 'laptops'!";
            processor68000 = YES;
            break;
        case 0xA49F9914:
            fileDetails = @"Macintosh Classic (XO)";
            comments = @"From Mac Classic with XO ROMDisk: It has the ability to boot from ROM by holding down cmd+opt+x+o at startup.\nLimited support in Basilisk II.";//Classic emulation is broken on Basilisk
            vMac = YES;
            processor68000 = YES;
            break;
        case 0x96645F9C:
            fileDetails = @"Macintosh PowerBook 100";
            comments = @"";
            processor68030 = YES;
            processor68040 = YES;
            break;

            // 512 KB
        case 0x4147DD77:
            fileDetails = @"Macintosh IIfx";
            comments = @"Known as Stealth, Blackbird, F-16, F-19, Four Square, IIxi, Zone 5 and Weed-Whacker.\nEmulation requires FPU and AppleTalk is not supported.";
            BasiliskII = YES;
            processor68030 = YES;
            break;
        case 0x350EACF0:
            fileDetails = @"Macintosh LC (Pizza box)";
            comments = @"AppleTalk is not supported in Basilisk.";
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            break;
        case 0x3193670E:
            //            if (512k) {
            
            fileDetails = @"Macintosh Classic II";
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
            fileDetails = @"Macintosh IIci";
            comments = @"In Basilisk, FPU must be enabled and appleTalk is not supported.\nThis is a 32-bit clean ROM.";
            BasiliskII = YES;
//            processor68020 = YES;
            processor68030 = YES;
//            processor68040 = YES;
            break;
        case 0x36B7FB6C:
            fileDetails = @"Macintosh IIsi";
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
            fileDetails = @"Macintosh IIx";
            comments = @"AppleTalk may not be supported.";
            BasiliskII = YES;
            break;
        case 0x4957EB49: 
            fileDetails = @"Mac IIvx (Brazil) or IIvi/Performa 600";
            comments = @"Mac IIvx was the last of Mac II series.\nAppleTalk may not be supported for emulation.";
            BasiliskII = YES;
            processor68030 = YES;
            break;

            
            //------------------------------------------------
            // Things get messy here
            // 1024 KB
        case 0x420DBFF3:
            fileDetails = @"Quadra 700/900 or PowerBook 140/170";
            comments = @"AppleTalk is not supported on Basilisk II.\nThis is the worst known 1MB ROM.";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        case 0x3DC27823:
            fileDetails = @"Macintosh Quadra 950";
            comments = @"AppleTalk is not supported on Basilisk II.";
            BasiliskII = YES;
            processor68040 = YES;
            break;
            //====
        case 0x49579803: //very strange didn't find it, called IIvx //49579803
            fileDetails = @"Macintosh IIvx ?"; //Again? Brazil?
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            break;
        case 0xE33B2724:
            fileDetails = @"Powerbook 160/165/165c/180/180c";
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            break;
        case 0xECFA989B:
            fileDetails = @"Powerbook 210/230/250";
            processor68030 = YES;
            break;
        case 0xEC904829:
            fileDetails = @"Macintosh LC III";
            BasiliskII = YES;
            processor68030 = YES;
            break;
        case 0xECBBC41C:
            fileDetails = @"Macintosh LCIII/LCIII+ or Performa 460";
            BasiliskII = YES;
            processor68030 = YES;
            break;
        case 0xECD99DC0:
            fileDetails = @"Macintosh Color Classic / Performa 250";
            BasiliskII = YES;
            processor68020 = YES;
            processor68030 = YES;
            processor68040 = YES;
            break;
        case 0xF1A6F343:
            fileDetails = @"Quadra/Centris 610 or 650";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        case 0xF1ACAD13:	// Mac Quadra 650
            fileDetails = @"Quadra/Centris 610 or 650 or 800";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        case 0x0024D346:
            fileDetails = @"Powerbook Duo 270C";
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
            fileDetails = @"Powerbook Duo 280 or 280C";
            processor68030 = YES;
            break;
        case 0x06684214:
            fileDetails = @"LC/Quadra/Performa 630";
            comments = @"Codename Crusader";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        case 0xFDA22562:
            fileDetails = @"Powerbook 150";
            processor68030 = YES;
            break;
        case 0x064DC91D:
            fileDetails = @"LC/Performa 580/588";
            comments = @"AppleTalk is reported to work in Basilisk II.";
            BasiliskII = YES;
            processor68040 = YES;
            break;
        //------------------------------------------------
        // 2MB and 3MB ROMs
        // 2048 KB
        case 0xB6909089:
            fileDetails = @"PowerBook 520/520c/540/540c";
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
        case 0x9FEB69B3:
            fileDetails = @"Power Mac 6100/7100/8100";
            processorPPC   = YES;
            break;
        case 0x9C7C98F7:
            fileDetails = @"Workgroup Server 9150 80MHz";
            processorPPC   = YES;
            break;
        case 0x9B7A3AAD:
            fileDetails = @"Power Mac 7100 (newer)";
            processorPPC   = YES;
            break;
        case 0x63ABFD3F:
            fileDetails = @"Power Mac & Performa 5200/5300/6200/6300";
            processorPPC   = YES;
            break;
        case 0x9B037F6F:
            fileDetails = @"Workgroup Server 9150 120MHz";
            processorPPC   = YES;
            break;
        case 0x83C54F75:
            fileDetails = @"PowerBook 2300 & PB5x0 PPC Upgrade";
            processorPPC   = YES;
            break;
        case 0x9630C68B:
            fileDetails = @"Power Mac 7200/7500/8500/9500 v2";
            processorPPC   = YES;
            break;
        case 0x96CD923D:
            fileDetails = @"Power Mac 7200/7500/8500/9500 v1"; //Probably PPC Quadra
            comments = @"Runs on Sheepshaver";
            Sheepshaver = YES;
            processorPPC   = YES;
            break;
        case 0x6F5724C0:
            fileDetails = @"PowerM ac/Performa 6400";
            processorPPC   = YES;
            break;
        case 0x83A21950:
            fileDetails = @"PowerBook 1400, 1400cs";
            processorPPC   = YES;
            break;
        case 0x6E92FE08:
            fileDetails = @"Power Mac 6500";
            processorPPC   = YES;
            break;
        case 0x960E4BE9:
            fileDetails = @"Power Mac 7300/7600/8600/9600 (v1)";
            processorPPC   = YES;
            break;
        case 0x960FC647:
            fileDetails = @"Power Mac 8600 or 9600 (v2)";
            processorPPC   = YES;
            break;
        case 0x78F57389:
            fileDetails = @"Power Mac G3 (v3)";
            processorPPC   = YES;
            break;
        case 0x79D68D63:
            fileDetails = @"Power Mac G3 desktop";
            processorPPC   = YES;
            break;
        case 0xCBB01212:
            fileDetails = @"PowerBook G3 Wallstreet";
            processorPPC   = YES;
            break;
        case 0xB46FFB63:
            fileDetails = @"PowerBook G3 Wallstreet PDQ";
            processorPPC   = YES;
            break;
      
            
            
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
