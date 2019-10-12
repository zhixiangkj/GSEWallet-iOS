//
//  UIColor+RGB.h
//  GSEWallet
//
//  Created by 付金亮 on 2019/1/2.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RGB)
-(UIColor *)initWithRGB: (int)r G: (int)g B: (int)b;
-(UIColor *)initWithHex: (NSInteger) hex;
-(UIColor *)initWithRGBA: (int)r G: (int)g B: (int)b A: (float)a;
-(UIColor *)initWithHex: (NSInteger)hex A: (float)a;
@end

NS_ASSUME_NONNULL_END
