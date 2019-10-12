//
//  UITextField+Extensions.h
//  wallet
//
//  Created by user on 28/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extensions)
- (void)setText:(NSString*)text color:(UIColor *)color wordSpacing:(CGFloat)wordSpacing;
- (void)setPlaceholder:(NSString*)text color:(UIColor *)color wordSpacing:(CGFloat)wordSpacing;
@end
