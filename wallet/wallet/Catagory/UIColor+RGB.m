//
//  UIColor+RGB.m
//  GSEWallet
//
//  Created by 付金亮 on 2019/1/2.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)
-(UIColor *)initWithRGB: (int)r G: (int)g B: (int)b{
    return [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha: 1.0];
}
-(UIColor *)initWithHex: (NSInteger)hex{
    return [[UIColor alloc]initWithRGB: hex & 0xFF0000 >> 16 G:hex & 0xFF00 >> 8 B:hex & 0xFF];
}
-(UIColor *)initWithRGBA: (int)r G: (int)g B: (int)b A: (float)a{
    return [UIColor colorWithRed:(float)r/255.0 green:(float)g/255.0 blue:(float)b/255.0 alpha:a];
}
-(UIColor *)initWithHex: (NSInteger)hex A: (float)a{
    return [[UIColor alloc]initWithRGBA: hex & 0xFF0000 >> 16 G:hex & 0xFF00 >> 8 B:hex & 0xFF A:a];
}

@end
