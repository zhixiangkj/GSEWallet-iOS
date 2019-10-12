//
//  NSData+Extensions.m
//  GSEWallet
//
//  Created by user on 06/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "NSData+Extensions.h"

@implementation NSData (Extensions)

- (NSString *)UTF8String{
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

- (NSString *)ASCIIString{
    return [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
}

- (NSString *)hex{
    const unsigned char *dataBuffer = (const unsigned char *)[self bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [self length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [[NSString stringWithString:hexString] lowercaseString];
}

- (NSData *)sign{
    unsigned char bByte [] = {0x20,0x18,0x10,0x17,0x14,0x14};
    
    NSData * sec = [NSData dataWithBytes:bByte length:sizeof(bByte)];
    
    unsigned char * cByte = (unsigned char*)[self bytes];
    unsigned char * sByte = (unsigned char*) sec.bytes;
    for (int index = 0; index < [self length]; index++)
    {
        cByte[index] = cByte[index] ^ sByte[index % sec.length];
    }
    
    NSData * valueData = [NSData dataWithBytes:cByte length:self.length];
    return valueData;
}
@end
