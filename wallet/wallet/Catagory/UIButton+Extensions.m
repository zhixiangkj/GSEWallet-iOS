//
//  UIButton+Extensions.m
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "UIButton+Extensions.h"

@implementation UIButton (Extensions)

- (void)centerVerticallyWithPadding:(float)padding {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGFloat totalHeight = (imageSize.height + titleSize.height + padding);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height),
                                            0.0f,
                                            0.0f,
                                            - titleSize.width);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0f,
                                            - imageSize.width,
                                            - (totalHeight - titleSize.height),
                                            0.0f);
    
    self.contentEdgeInsets = UIEdgeInsetsMake(0.0f,
                                              0.0f,
                                              titleSize.height,
                                              0.0f);
}

- (void)centerVertically {
    const CGFloat kDefaultPadding = 6.0f;
    [self centerVerticallyWithPadding:kDefaultPadding];
}

- (void)alignImageToLeftWithGap:(CGFloat)gap {
    
    CGRect frame = self.frame;
    frame.size.width += gap;
    self.frame = frame;
    
    CGFloat titleGap = gap / 2.f;
    CGFloat imageGap = gap / 2.f;
    if (UIControlContentHorizontalAlignmentLeft == self.contentHorizontalAlignment) {
        imageGap = gap;
        titleGap = 0;
    }
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, titleGap, 0, -titleGap);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -imageGap, 0, imageGap);
}

- (void)alignImageToRightWithGap:(CGFloat)gap {
    
    CGRect frame = self.frame;
    frame.size.width += gap;
    self.frame = frame;
    
    CGFloat titleGap = gap / 2.f;
    CGFloat imageGap = gap / 2.f;
    if (UIControlContentHorizontalAlignmentRight == self.contentHorizontalAlignment) {
        titleGap = gap;
        imageGap = 0;
    }
    
    titleGap += self.imageView.frame.size.width;
    imageGap += self.titleLabel.frame.size.width;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -titleGap, 0, titleGap);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, imageGap, 0, -imageGap);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageFromColorCached:backgroundColor] forState:state];
}

@end
