//
//  UIScreen+Extensions.m
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "UIScreen+Extensions.h"

@implementation UIScreen (Extensions)

+ (BOOL)iPhone4s {
    return [self isMainScreenEqualToSize:CGSizeMake(320, 480)];
}

+ (BOOL)iPhone5 {
    return [self isMainScreenEqualToSize:CGSizeMake(320, 568)];
}

+ (BOOL)iPhone6 {
    return [self isMainScreenEqualToSize:CGSizeMake(375, 667)];
}

+ (BOOL)iPhone678Plus {
    return [self isMainScreenEqualToSize:CGSizeMake(414, 736)];
}

+ (BOOL)iPhonePlus {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    return screenFrame.size.width >= 414;
}

+ (BOOL)iPhoneX {
    return [self isMainScreenEqualToSize:CGSizeMake(375, 812)];
}

+ (BOOL)isMainScreenEqualToSize:(CGSize)size {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    BOOL equal = (screenFrame.size.height == size.height && screenFrame.size.width == size.width) || (screenFrame.size.height == size.width && screenFrame.size.width == size.height);
    return equal;
}

@end
