//
//  NSString+Extensions.m
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "NSString+Extensions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extensions)

+ (BOOL) range:(NSArray*) _termArray Password:(NSString*) _password{
    NSRange range;
    BOOL result = NO;
    for(int i=0; i<[_termArray count]; i++){
        range = [_password rangeOfString:[_termArray objectAtIndex:i]];
        if(range.location != NSNotFound){
            result =YES;
        }
    }
    return result;
}

- (NSInteger) passwordStrength{
    
    NSArray* termArray1 = [[NSArray alloc] initWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    NSArray* termArray2 = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0", nil];
    NSArray* termArray3 = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    NSArray* termArray4 = [[NSArray alloc] initWithObjects:@"~",@"`",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",@"-",@"_",@"+",@"=",@"{",@"}",@"[",@"]",@"|",@":",@";",@"“",@"'",@"‘",@"<",@",",@".",@">",@"?",@"/",@"、", nil];
    
    NSArray *results = @[
      @([NSString range:termArray1 Password:self]),
      @([NSString range:termArray2 Password:self]),
      @([NSString range:termArray3 Password:self]),
      @([NSString range:termArray4 Password:self]),
    ];
    
    int intResult = 0;
    for (int j=0; j<[results count]; j++){
        if ([[results objectAtIndex:j] boolValue]){
            intResult++;
        }
    }
    return intResult;
}

-(UIImage *)qrCodeImage:(CGFloat)size{
    return [self qrCodeImage:size height:size scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}
- (UIImage *)qrCodeImageForSave:(CGFloat)size{
    return [self qrCodeImage:size height:size];
}

-(UIImage *)qrCodeImage:(CGFloat)width height:(CGFloat)height scale:(CGFloat)scale orientation:(UIImageOrientation)orientation
{
    NSData *stringData = [self dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = width / qrImage.extent.size.width;
    float scaleY = height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:qrImage scale:scale orientation:orientation];
}

-(UIImage *)qrCodeImage:(CGFloat)width height:(CGFloat)height
{
    NSData *stringData = [self dataUsingEncoding: NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    float scaleX = width / qrImage.extent.size.width;
    float scaleY = height / qrImage.extent.size.height;
    
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    return [UIImage makeUIImageFromCIImage:qrImage];
}

- (NSData *)hexStringToData
{
    NSString *string = [self lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    NSInteger length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    return data;
}

- (NSString *)md5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}
- (NSString *)separateNumberUseComma{
    return [self commaWithPrefix:nil];
}
- (NSString *)commaWithPrefix:(NSString *)prefix{
    
    NSString *number = self;
    
    if (!prefix) {
        prefix = @"$ ";
    }
    // suffix
    NSString *suffix = @"";
    // separator
    NSString *divide = @",";
    
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([number containsString:@"."]) {
        contains = YES;
        // if float in，separate numbers after dot
        NSArray *comArray = [number componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = number;
    }
    // split in to integer array
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // add comma with 3 chars from behind 
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    if (![prefix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",prefix,newNumber];
    }
    if (![suffix isEqualToString:@""]) {
        newNumber = [NSString stringWithFormat:@"%@%@",newNumber,suffix];
    }
    
    return newNumber;
}

- (NSString *)localizeWithBlank{
    NSArray *components = [self componentsSeparatedByString:@" "];
    NSMutableString *string = [NSMutableString string];
    for (NSString *component in components) {
        [string appendString: NSLocalizedString(component, nil)];
        [string appendString: @" "];
    }
    if ([string rangeOfString:@"前"].location != NSNotFound) {
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""].mutableCopy;
    }
    return string;
}
@end


