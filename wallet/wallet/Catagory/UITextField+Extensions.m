//
//  UITextField+Extensions.m
//  wallet
//
//  Created by user on 28/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "UITextField+Extensions.h"

@implementation UITextField (Extensions)

-(void)setText:(NSString*)text color:(UIColor *)color wordSpacing:(CGFloat)wordSpacing {
    if (!text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    if (color) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
    }
    [attributedString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0, [text length])];
    self.attributedText = attributedString;
}

-(void)setPlaceholder:(NSString*)text color:(UIColor *)color wordSpacing:(CGFloat)wordSpacing {
    if (!text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    if (color) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, [text length])];
    }
    [attributedString addAttribute:NSKernAttributeName value:@(wordSpacing) range:NSMakeRange(0, [text length])];
    self.attributedPlaceholder = attributedString;
}

@end
