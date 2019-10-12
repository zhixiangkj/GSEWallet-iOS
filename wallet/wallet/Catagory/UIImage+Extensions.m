//
//  UIImage+Extensions.m
//  wallet
//
//  Created by user on 25/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "UIImage+Extensions.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (Extensions)

+ (NSString *)hexString:(UIColor *)color{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

+ (UIImage *)imageFromColorCached:(UIColor *)color{

    static NSMutableDictionary * dic = nil;
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
    
    NSString *key = [self hexString:color];
    
    if (!dic[ key ]) {
        UIImage *image = [UIImage imageFromColor:color];
        [dic setObject:image forKey:key];
        return image;
    }
    
    NSLog(@"color: %@,%@,%@", key, color, dic[key] );
    
    return dic[ key ];
}

+ (UIImage *)imageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage {
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:ciImage fromRect:[ciImage extent]];
    
    UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    return uiImage;
}
@end
