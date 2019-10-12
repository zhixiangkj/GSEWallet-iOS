//
//  NSString+Extensions.h
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extensions)
- (NSInteger) passwordStrength;

- (UIImage *)qrCodeImage:(CGFloat)size;
- (UIImage *)qrCodeImageForSave:(CGFloat)size;
- (NSData *)hexStringToData;

- (NSString *)md5;
- (NSString *)separateNumberUseComma;
- (NSString *)commaWithPrefix:(NSString *)prefix;
- (NSString *)localizeWithBlank;
@end
