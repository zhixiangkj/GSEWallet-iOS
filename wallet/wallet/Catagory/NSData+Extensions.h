//
//  NSData+Extensions.h
//  GSEWallet
//
//  Created by user on 06/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extensions)
- (NSString *)UTF8String;
- (NSString *)ASCIIString;
- (NSString *)hex;
- (NSData *)sign;
@end
