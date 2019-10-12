//
//  UITextView+Extensions.m
//  wallet
//
//  Created by user on 25/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "UITextView+Extensions.h"

@implementation UITextView (Extensions)
- (void)addPlaceHolder:(NSString *)placeHolderString{
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = UIColorFromRGB(0xbdbdbd);
    //placeHolderLabel.textAlignment = NSTextAlignmentCenter;
    placeHolderLabel.font = [UIFont systemFontOfSize:15.f];
    [placeHolderLabel setText:placeHolderString lineSpacing:0 wordSpacing:1];
    [placeHolderLabel sizeToFit];
    [self addSubview:placeHolderLabel];
    [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
}
@end
