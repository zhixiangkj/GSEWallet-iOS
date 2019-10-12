//
//  UIButton+Extensions.h
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extensions)

- (void)centerVerticallyWithPadding:(float)padding;
- (void)centerVertically;

- (void)alignImageToLeftWithGap:(CGFloat)gap;
- (void)alignImageToRightWithGap:(CGFloat)gap;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
