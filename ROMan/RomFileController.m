//
//  RomFileController.m
//  Mac ROMan
//
//  Created by Giancarlo Mariot on 25/10/2013.
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

#import "RomFileController.h"
#import "AppDelegate.h"
#import "NSData+MD5.h"

@implementation RomFileController

@synthesize emulator;
@synthesize fileSize;
@synthesize madeTest;
@synthesize macModel;
@synthesize comments;
@synthesize checksum;
@synthesize codeName;

/*!
 * @abstract Checks if file is of a valid format.
 */
+ (BOOL)validateFile:(NSString *)filePath {

    
//    NSArray * fileKinds = [[[NSArray alloc]
//        initWithObjects:
//          @"Unix Executable File"
//          , @"Document"
//          , @"ROM Image"
//          , nil
//    ] autorelease];
    
//    if (![[[filePath pathExtension] lowercaseString] isEqualTo:@"rom"])
//        return NO;
    
    if (![[[filePath pathExtension] lowercaseString] isEqualTo:@"rom"])
        return YES;
    
    NSString * kind = (NSString *)UTTypeCopyDescription((CFStringRef)@"public.rom");
    
    
    if ([kind isEqualToString:@"ROM Image"])
        return YES;
    
    if ([kind isEqualToString:@"Unix Executable File"])
        return YES;
    
    return NO;
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
 * @link     http://support.apple.com/kb/TA22055
 * @link     https://www.princeton.edu/~achaney/tmve/wiki100k/docs/Power_Macintosh.html
 * @link     https://docs.google.com/spreadsheets/d/1wB2HnysPp63fezUzfgpk0JX_b7bXvmAg6-Dk7QDyKPY
 * @link     https://apple.wikia.com/wiki/List_of_Mac_OS_versions
 */
- (void)parseFile:(NSString *)filePath {
    
    if (![RomFileController validateFile:filePath]) {
        NSLog(@"File is not valid!");
        return;
    }
    
    BOOL newWorldRom = NO;
    NSData * data = [NSData dataWithContentsOfFile:filePath];
    NSString * md5Hash = [data MD5];
    fileSize = (int) [data length];
    Byte * byteData = (Byte *)malloc(fileSize);
    memcpy(byteData, [data bytes], fileSize);
    
    checksum = [NSString stringWithFormat: @"%X", ntohl(*(uint32 *)byteData)];
    madeTest = NO;
    emulator = Unknown;

    switch( ntohl(*(uint32 *)byteData) ) {
            //------------------------------------------------
            // 64 KB
        case 0x28BA61CE:
            macModel = @"Macintosh 128";
            codeName = @"Macintosh";
            comments = @"First Macintosh ever made.\nThis ROM can be used with Mini vMac 128k.";
            // processor68000 = YES;
            emulator = vMacSpecial;
            madeTest = YES;
            break;
        case 0x28BA4E50:
            macModel = @"Macintosh 512K";
            codeName = @"Fat Mac";
            comments = @"Second Macintosh ever made.\nThis ROM can be used with Mini vMac  512k.";
            // processor68000 = YES;
            emulator = vMacSpecial;
            madeTest = YES;
            break;
            // no basilisk
            //------------------------------------------------
            // 128 KB
        case 0x4D1EEEE1:
            macModel = @"Macintosh Plus / 512Ke v1 (Lonely Hearts)";
            codeName = @"Mr. T";
            comments = @"This ROM was buggy and had 2 revisions!\nvMac can't boot from it.\nThe second revision (v3) is more recommended.";
            // processor68000 = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x4D1EEAE1:
            macModel = @"Macintosh Plus / 512Ke v2 (Lonely Heifers)";
            codeName = @"Mr. T";
            comments = @"This ROM was the first revision and still had some bugs.\nv3 is more recommended.";
            emulator = vMacNormal;
            // processor68000 = YES;
            madeTest = YES;
            break;
        case 0x4D1F8172:
            macModel = @"Macintosh Plus / 512Ke v3 (Loud Harmonicas)";
            codeName = @"Mr. T";
            comments = @"Best Mac Plus ROM, second revision from the original.\nGood for vMac.";
            emulator = vMacNormal;
            // processor68000 = YES;
            madeTest = YES;
            break;
            // no basilisk
            //------------------------------------------------
            // 256 KB
        case 0xB2E362A8:
            macModel = @"Macintosh SE"; //no checksum
            codeName = @"Mac ±, PlusPlus, Aladdin, Freeport, Maui, Chablis, Midnight Run";
            comments = @"This ROM can be used with Mini vMac SE.";
            emulator = vMacSpecial;
            // processor68000 = YES;
            break;
        case 0xB306E171:
            macModel = @"Macintosh SE FDHD"; //no checksum
            comments = @"FDHD stands for 'Floppy Disk High Density'\nThis mac was later called Macintosh SE Superdrive";
            emulator = vMacSpecial;
            // processor68000 = YES;
            break;
        case 0x97851DB6:
            macModel = @"Macintosh II v1";
            codeName = @"Little Big Mac, Milwaukee, Ikki, Cabernet, Reno, Becks, Paris, Uzi";
            comments = @"First Mac II ROM, had a memory problem\nThis one is rare!\nvMac won't boot it.";//bug
            // processor68020 = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x9779D2C4:
            macModel = @"Macintosh II v2"; //no checksum
            codeName = @"Little Big Mac, Milwaukee, Ikki, Cabernet, Reno, Becks, Paris, Uzi";
            comments = @"Mac II ROM's revision";
            // processor68020 = YES;
            break;
        case 0x97221136:
            macModel = @"Macintosh IIx or IIcx or SE/30"; //Mac IIcx
            codeName = @"Spock, Stratos - Aurora, Cobra, Atlantic - Green Jade, Fafnir";
            //IIx = 16 MHz Motorola 68020 CPU and 68881 FPU of the II with a 68030 CPU and 68882 FPU (running at the same clock speed)
            comments = @"'32-bit dirty' ROM, since it has code using 24-bit addressing.\n'x' stands for the 68030 processor family, 'c' stands for 'compact'\nApple used 'SE/30' to avoid the acronym 'SEx'";
            emulator = vMacSpecial;
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
            macModel = @"Macintosh Classic";
            codeName = @"XO";
            comments = @"From Mac Classic with XO ROMDisk: It has the ability to boot from ROM by holding down cmd+opt+x+o at startup.\nLimited support in Basilisk II.";//Classic emulation is broken on Basilisk
            emulator = vMacSpecial;
            // processor68000 = YES;
            break;
        case 0x96645F9C:
            macModel = @"Macintosh Portable (Backlit), PowerBook 100";
            comments = @"";
            // processor68030 = YES;
            // processor68040 = YES;
            break;
            //------------------------------------------------
            // 512 KB
        case 0x4147DD77:
            macModel = @"Macintosh IIfx";
            codeName = @"Stealth, Blackbird, F-16, F-19, Four Square, IIxi, Zone 5, Weed-Whacker";
            comments = @"Emulation requires FPU and AppleTalk is not supported.";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
        case 0x368CADFE:
            macModel = @"Macintosh IIci";
            codeName = @"Aurora II, Cobra II, Pacific, Stingray";
            comments = @"In Basilisk, FPU must be enabled and appleTalk is not supported.\nThis is a 32-bit clean ROM.";
            emulator = BasiliskII;
            //            // processor68020 = YES;
            // processor68030 = YES;
            //            // processor68040 = YES;
            break;
        case 0x36B7FB6C:
            macModel = @"Macintosh IIsi";
            codeName = @"Oceanic, Ray Ban, Erickson, Raffica, Raffika";//sunglasses
            comments = @"In Basilisk, AppleTalk is not supported.";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
        case 0x3193670E: //Mysterious 1024KB version?
            macModel = @"Classic II, LC 550 TV, Performa 200, Performa 275, Performa 550, Performa 560";
            codeName = @"Montana, Apollo";
            comments = @"Emulation may require the FPU and AppleTalk may not be supported.";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
        case 0x350EACF0:
            macModel = @"Macintosh LC";
            codeName = @"Pinball, Elsie (L-C), Prism";
            comments = @"AppleTalk is not supported in Basilisk.";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
        case 0x35C28F5F:
            macModel = @"Mac LC II or Performa 400/405/410/430"; //IIci?
            codeName = @"LC II: Foster Farms";
            comments = @"In Basilisk, AppleTalk is not supported.";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
            //------------------------------------------------
        case 0x35C28C8F: //very strange didn't find it, called IIxi
            macModel = @"Macintosh IIx";
            codeName = @"Spock, Stratos";
            comments = @"AppleTalk may not be supported.";
            emulator = BasiliskII;
            break;
        case 0x4957EB49:
            macModel = @"Mac IIvx or IIvi/Performa 600";
            codeName = @"Mac IIvx: Brazil";
            comments = @"Mac IIvx was the last of Mac II series.\nAppleTalk may not be supported for emulation.";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
            
            
            //------------------------------------------------
            // Things get messy here
            // 1024 KB
        case 0x420DBFF3:
            macModel = @"Quadra 700/900 or PowerBook 140/170";
            codeName = @"Quadra 700: Shadow, Spike, IIce, Evo 200\nQuadra 900: Darwin, Eclipse, IIex, Premise 500\nPB 140: Tim LC, Tim Lite, Leary, Replacements\nPB 170: Road Warrior, Tim";
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
            macModel = @"Macintosh LC III (v1)";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
        case 0xECBBC41C:
            macModel = @"Macintosh LC III, LC III+, LC 520, Performa 460, Performa 520 (v2)";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
        case 0xECD99DC0:
            macModel = @"Macintosh Color Classic or Performa 250";
            emulator = BasiliskII;
            // processor68020 = YES;
            // processor68030 = YES;
            // processor68040 = YES;
            break;
        case 0xF1A6F343:
            macModel = @"Quadra/Centris 610, Quadra 610 CD, Quadra 610 with DOS";
            emulator = BasiliskII;
            // processor68040 = YES;
            break;
        case 0xF1ACAD13:	// Mac Quadra 650
            macModel = @"Quadra/Centris 650, Quadra 800";
            emulator = BasiliskIIQEMU;
            // processor68040 = YES;
            madeTest = YES;
            break;
        case 0x0024D346:
            macModel = @"PowerBook Duo 270, PowerBook Duo 270c";
            // processor68030 = YES;
            break;
        case 0xEDE66CBD:
            macModel = @"Color Classic II, LC 550, Performa 275/550/560 & Mac TV";//Maybe Performa 450-550";
            emulator = BasiliskII;
            // processor68030 = YES;
            break;
        case 0xFF7439EE:
            macModel = @"LC 475/575, Quadra 605 & Performa 475/476/575/577/578";
            codeName = @"Aladdin";
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
            codeName = @"Crusader";
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
            //68LC040
            break;
        case 0x5BF10FD1:
            macModel = @"Macintosh Quadra 660av or 840av (v1)";
            // processor68040 = YES;
            // processorPPC   = YES;
            break;
        case 0x87D3C814:
            macModel = @"Macintosh Quadra 660av or 840av (v2)";
            // processor68040 = YES;
            // processorPPC   = YES;
            break;
        case 0xB57687A5:
            macModel = @"PowerBook 550c";
            // processor68040 = YES;
            // processorPPC   = YES;
            break;
        case 0x4D27039C:
            macModel = @"PowerBook 190 or 190cs";
            //            emulator = BasiliskII;
            //            // processor68040 = YES; processor: 68LC040
            break;
            
            
            //------------------------------------------------
            // 4MB
        case 0x9FEB69B3:
            macModel = @"Power Mac 6100/7100/8100 (v1)";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x9C7C98F7:
            macModel = @"Workgroup Server 9150 80MHz";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x9B7A3AAD:
            macModel = @"Power Mac 6100/7100/8100 (v2)";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x63ABFD3F:
            macModel = @"Power Mac & Performa 5200/5300/6200/6300";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x9B037F6F:
            macModel = @"Workgroup Server 9150 120MHz";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x852CFBDF:
            macModel = @"PowerBook 5300 and Assistive Technology Freestyle";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x83C54F75:
            macModel = @"PowerBook Duo 2300 & PB5x0 PPC Upgrade"; //double-check
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x9630C68B:
            macModel = @"Power Macintosh 7200/90, Power Macintosh 7500/100, Some Clones (v2)";
            comments = @"This ROM is unstable when used with some versions of SheepShaver. Try turning on the 'ignoresegv' option and JIT if you run into problems.";
            emulator = Sheepshaver;
            // processorPPC   = YES;
            madeTest = YES;
            break;
        case 0x96CD923D:
            macModel = @"Power Mac 7200/7500/8500/9500 (v1)"; //unstable
            comments = @"This ROM is unstable when used with SheepShaver. Try turning on the 'ignoresegv' option and/or disabling JIT if you run into problems.";
            emulator = Sheepshaver;
            // processorPPC   = YES;
            madeTest = YES;
            break;
        case 0x6F5724C0:
            macModel = @"PowerMac/Performa 6400, Performa 6410, Performa 6420";
            // processorPPC   = YES;
            break;
        case 0x575BE6BB:
            macModel = @"Umax C500/600, Motorola Starmax 3000/4000/5500";
            // processorPPC   = YES;
            break;
        case 0x276EC1F1:
            macModel = @"PowerBook 2400, 3400, 3400c (Hooper)";
            // processorPPC   = YES;
            break;
        case 0x83A21950:
            macModel = @"PowerBook 1400 or 1400cs";
            // processorPPC   = YES;
            break;
        case 0x6E92FE08:
            macModel = @"Power Mac 6500";
            // processorPPC   = YES;
            emulator = Sheepshaver;
            madeTest = YES;
            break;
        case 0x58F03416:
            macModel = @"Motorola 4400 “Cupid”/7220 ”Tanzania”";
            // processorPPC   = YES;
            emulator = Sheepshaver;
            madeTest = YES;
            break;
        case 0x960E4BE9:
            macModel = @"Power Mac 7300/7600/8600/9600 (v1)";
            // processorPPC   = YES;
            emulator = Sheepshaver;
            madeTest = YES;
            break;
        case 0x960FC647:
            macModel = @"Power Mac 8600 or 9600 (v2)";
            // processorPPC   = YES;
            emulator = Sheepshaver;
            madeTest = YES;
            break;
        case 0x78F57389:
            macModel = @"Power Macintosh G3 (v3)";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x46001F1B:
            macModel = @"Power Macintosh 9700 Prototype (bad dump)";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0x79D68D63:
            macModel = @"Power Macintosh G3 Desktop (Gossamer) (v1)";
            // processorPPC   = YES;
            break;
        case 0x78EB4234:
            macModel = @"Power Macintosh G3 (v2)";
            // processorPPC   = YES;
            break;
        case 0x2560F229:
            macModel = @"PowerBook G3 (Kanga)";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0xCBB01212:
            macModel = @"PowerBook G3 (Wallstreet)";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
        case 0xB46FFB63:
            macModel = @"PowerBook G3 (Wallstreet PDQ)";
            // processorPPC   = YES;
            emulator = Unsupported;
            madeTest = YES;
            break;
            
            //------------------------------------------------
            // New world
//        case 0x3C434852:
//            macModel = @"Mac OS ROM 1.6";
//            comments = @"The famous New World ROM from Apple's update";
//            emulator = Sheepshaver;
//            madeTest = YES;
//            break;
            
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
                    
                    newWorldRom = YES;

                    if ([md5Hash isEqualToString:@"e0fc03faa589ee066c411b4603e0ac89"]) {
                        macModel = @"Mac OS ROM 1.1";
                        comments = @"From Mac OS 8.1 bundled on iMac, Rev A";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"17b134a0d837518498c06579aa4ff053"]) {
                        macModel = @"Mac OS ROM 1.1.2";
                        comments = @"From Mac OS 8.5 Retail CD, iMac Update 1.0";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"133ef27acf2f360341870f212c7207d7"]) {
                        macModel = @"Mac OS ROM 1.1.5";
                        comments = @"Mac OS 8.5 bundled on iMac, Rev B";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"3756f699eadaabf0abf8d3322bed70e5"]) {
                        macModel = @"Mac OS ROM 1.2";
                        comments = @"From Mac OS 8.5.1 Bundle:\nPower Macintosh G3 (Blue and White) or..\nMacintosh Server G3 (Blue and White).";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"483233f45e8ca33fd2fbe5201f06ac18"]) {
                        macModel = @"Mac OS ROM 1.2.1";
                        comments = @"Version from the iMac Update 1.1.\nAlso bundled on Mac OS 8.5.1 (Colors iMac 266 MHz Bundle).";
                        emulator = Sheepshaver;
                        madeTest = YES;
                    } else
                    if ([md5Hash isEqualToString:@"1bf445c27513dba473cca51219184b07"]) {
                        macModel = @"Mac OS ROM 1.4";
                        comments = @"Rom extracted from Mac OS 8.6\nor Colors iMac 333 MHz Bundle\nor Power Macintosh G3 (Blue and White) Mac OS 8.6 Bundle";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"be65e1c4f04a3f2881d6e8de47d66454"]) {
                        macModel = @"Mac OS ROM 1.6";
                        comments = @"Very popular ROM extracted from the Mac OS ROM Update 1.0.\nAlso available on the Macintosh PowerBook G3 Series 8.6 Bundle.";
                        emulator = Sheepshaver;
                        madeTest = YES;
                    } else
                    if ([md5Hash isEqualToString:@"dd26176882d14c39219aca668d7e97cb"]) {
                        macModel = @"Mac OS ROM 1.7.1";
                        comments = @"From Mac OS 8.6 bundled on Power Mac G4 (PCI)";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"02350bfe27c4dea1d2c13008efb3a036"]) {
                        macModel = @"Mac OS ROM 1.8.1";
                        comments = @"From Mac OS 8.6 Power Mac G4 ROM 1.8.1 Update CD";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"722fe6481b4d5c04e005e5ba000eb00e"]) {
                        macModel = @"Mac OS ROM 2.3.1";
                        comments = @"From Mac OS 8.6 bundled on iMac (Slot Loading), iBook";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"4bb3e019c5d7bfd5f3a296c13ad7f08f"]) {
                        macModel = @"Mac OS ROM 2.5.1";
                        comments = @"ROM from the Mac OS 8.6 bundled on Power Mac G4 (AGP).";
                        emulator = Sheepshaver;
                        madeTest = YES;
                    } else
                    if ([md5Hash isEqualToString:@"d387acd4503ce24e941f1131433bbc0f"]) {
                        macModel = @"Mac OS ROM 3.0";
                        comments = @"Mac OS 9.0 Retail CD, bundled on Power Macintosh G3 (Blue and White), iMac, PowerBook G3 Bronze";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"9e990cde6c30a3ab916c1390b29786c7"]) {
                        macModel = @"Mac OS ROM 3.1.1";
                        comments = @"Mac OS 9.0 Retail CD, bundled on Power Macintosh G3 (Blue and White), iMac, PowerBook G3 Bronze";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"bbfbb4c884741dd75e03f3de67bf9370"]) {
                        macModel = @"Mac OS ROM 3.2.1";
                        comments = @"";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"386ea1c81730f9b06bfc2e6c36be8d59"]) {
                        macModel = @"Mac OS ROM 3.5";
                        comments = @"From Mac OS 9.0.2 bundled on Power Mac G4 (AGP), iBook, PowerBook (FireWire)";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"71d3bd057139e3b0fb152ab905a12d2a"]) {
                        macModel = @"Mac OS ROM 3.6";
                        comments = @"From Mac OS 9.0.3 bundled on iMac (Slot Loading)";
                        emulator = Sheepshaver;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"8f388ccf6f96c58bda5ae83d207ca85a"]) {
                        macModel = @"Mac OS ROM 3.7";
                        comments = @"Mac OS 9.0.4 Retail/Software Update or\nMac OS 9.0.4 installed on PowerBook";
                        emulator = SheepshaverQEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"3f182e059a60546f93114ed3798d5751"]) {
                        macModel = @"Mac OS ROM 3.8";
                        comments = @"Extracted from Ethernet Update 1.0.\nVery clever!";
                        emulator = SheepshaverQEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"bf9f186ba2dcaaa0bc2b9762a4bf0c4a"]) {
                        macModel = @"Mac OS ROM 4.6.1";
                        comments = @"Mac OS 9.0.4 installed on iMac (2000)";
                        emulator = SheepshaverQEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"f66558f3c9416a6bb8d062c0343b3e69"]) {
                        macModel = @"Mac OS ROM 4.9.1";
                        comments = @"From Mac OS 9.0.4 bundled on Power Mac G4 MP (Summer 2000) (CPU software 2.3), Power Mac G4 (Gigabit Ethernet)";
                        emulator = SheepshaverQEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"52ea9e30d59796ce8c4822eeeb0f543e"]) {
                        macModel = @"Mac OS ROM 5.2.1";
                        comments = @"Mac OS 9.0.4 installed on Power Mac G4 Cube";
                        emulator = SheepshaverQEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"ea03ebbfdff4febbff3a667deb921996"]) {
                        macModel = @"Mac OS ROM 5.3.1";
                        comments = @"From Mac OS 9.0.4 bundled on iBook (Summer 2000) (CPU software 2.5)";
                        emulator = SheepshaverQEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"52ea9e30d59796ce8c4822eeeb0f543e"]) {
                        macModel = @"Mac OS ROM 5.5.1";
                        comments = @"Mac OS 9.0.4 International bundled on Power Mac G4 Cube (CPU software 2.6)";
                        emulator = SheepshaverQEMU;
                        madeTest = NO;
                        } else
                    if ([md5Hash isEqualToString:@"????????????????????????????????"]) {
                        macModel = @"Mac OS ROM 5.5.1";
                        comments = @"From Mac OS 9.0.4 bundled on Power Mac G4 (with Radeon) (CPU software 2.6)";
                        emulator = SheepshaverQEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"5e9a959067e1261d19427f983dd10162"]) {
                        macModel = @"Mac OS ROM 6.1";
                        comments = @"Mac OS 9.1 Update CD";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"19d596fc3028612edb1553e4d2e0f345"]) {
                        macModel = @"Mac OS ROM 6.7.1";
                        comments = @"Mac OS 9.1 bundled on Power Mac G4 (Digital Audio)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"14cd0b3d8a7e022620b815f4983269ce"]) {
                        macModel = @"Mac OS ROM 7.5.1";
                        comments = @"Mac OS 9.1 bundled on iMac (Early 2001), iMac (Summer 2001), PowerBook G4";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"28a08b4d5d5e4ab113c5fc1b25955a7c"]) {
                        macModel = @"Mac OS ROM 7.8.1";
                        comments = @"Mac OS 9.1 bundled on iBook (Dual USB) (CPU Software 3.5)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"1486fe0b293e23125c00b9209435365c"]) {
                        macModel = @"Mac OS ROM 7.9.1";
                        comments = @"Mac OS 9.1 bundled on PowerBook G4";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"6fc4679862b2106055b1ce301822ffeb"]) {
                        macModel = @"Mac OS ROM 8.3.1";
                        comments = @"Mac OS 9.2 bundled on iMac (Summer 2001), Power Mac G4 (QuickSilver)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"f97d43821fea307578697a64b1705f8b"]) {
                        macModel = @"Mac OS ROM 8.4";
                        comments = @"Mac OS 9.2.1 Retail CD, bundled on Power Mac G4 (QuickSilver)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"d81574f35e97a658eab99df52529251e"]) {
                        macModel = @"Mac OS ROM 8.6.1";
                        comments = @"Mac OS 9.2.1 bundled on iBook G3 (Late 2001)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"97db5e70d05ab7568d8a1f7ddd3b901a"]) {
                        macModel = @"Mac OS ROM 8.7";
                        comments = @"Mac OS 9.2.2 Update SMI";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"fed4f785146d859d3c1b7fca42c07d9a"]) {
                        macModel = @"Mac OS ROM 8.8";
                        comments = @"Mac OS 9.2.2 Update CD";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"65e3bc1fee886bbe1aabe0faa4b8cda2"]) {
                        macModel = @"Mac OS ROM 8.9.1";
                        comments = @"Mac OS 9.2.2 bundled on iBook (CPU Software 4.4)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"66210b4f71df8a580eb175f52b9d0f88"]) {
                        macModel = @"Mac OS ROM 9.0.1";
                        comments = @"Mac OS 9.2.2 bundled on iMac (Summer 2001), iMac (Flat Panel), Power Mac G4 (QuickSilver 2002) (CPU Software 4.5)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"c5f7aaaf28d7c7eac746e9f26b183816"]) {
                        macModel = @"Mac OS ROM 9.1.1";
                        comments = @"Mac OS 9.2.2 bundled on iMac G4 (CPU Software 4.8)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"13889037360fe1567c7e7f89807453b0"]) {
                        macModel = @"Mac OS ROM 9.2.1";
                        comments = @"Mac OS 9.2.2 bundled on eMac (CPU Software 4.9)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"e0a643f2cb441955c46b098c8fd1b21f"]) {
                        macModel = @"Mac OS ROM 9.3.1";
                        comments = @"Mac OS 9.2.2 bundled on PowerBook G4 (CPU Software 5.0)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"b36a5f1d814291a22457adfa2331b379"]) {
                        macModel = @"Mac OS ROM 9.5.1";
                        comments = @"Mac OS 9.2.2 bundled on iMac (17-inch Flat Panel)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"3c08de22aeaa7d7fdb14df848fbaa90d"]) {
                        macModel = @"Mac OS ROM 9.6.1";
                        comments = @"Mac OS 9.2.2 Update CD (CPU Software 5.4)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"e74f8c6bb52a641b856d821be7a65275"]) {
                        macModel = @"Mac OS ROM 9.7.1";
                        comments = @"Mac OS 9.2.2 bundled on PowerBook (Titanium) (CPU Software 5.6)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"4e8d07f8e0d4af6d06336688013972c3"]) {
                        macModel = @"Mac OS ROM 9.8.1";
                        comments = @"Mac OS 9.2.2 (Unknown)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"1fb3de4d87889c26068dd88779dc20e2"]) {
                        macModel = @"Mac OS ROM 10.1.1";
                        comments = @"Mac OS 9.2.2 bundled on eMac 800MHz (CPU Software 5.7)";
                        emulator = QEMU;
                        madeTest = NO;
                    } else
                    if ([md5Hash isEqualToString:@"48fd7a428aaebeaec2dea347795a4910"]) {
                        macModel = @"Mac OS ROM 10.2.1";
                        comments = @"Mac OS 9.2.2 Retail International CD";
                        emulator = QEMU;
                        madeTest = NO;
                    } else {
                        macModel = @"Unsupported ROM.";
                        comments = @"Size should be 64KB, 128KB, 256KB, 512KB, 1MB, 2MB, 3MB or 4MB.";
                        emulator = QEMU;
                        newWorldRom = NO;
                    }
                    break;
                    
            }
            break;
    }
    if (newWorldRom) {
        checksum = md5Hash;
    }
    
}

@end
