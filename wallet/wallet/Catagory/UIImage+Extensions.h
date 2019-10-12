//
//  UIImage+Extensions.h
//  wallet
//
//  Created by user on 25/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensions)
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIImage *)imageFromColorCached:(UIColor *)color;
+ (UIImage *)makeUIImageFromCIImage:(CIImage *)ciImage;
@end
