//
//  GSE_AboutCell.m
//  GSEWallet
//
//  Created by user on 02/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_AboutCell.h"

@interface GSE_AboutCell ()

@end

@implementation GSE_AboutCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.image = ({
            UIImage *image = [UIImage imageNamed:@"about_official"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.center = CGPointMake(MARGIN + imageView.bounds.size.width / 2.0, MARGIN + imageView.bounds.size.height / 2.0);
            imageView;
        });
        [self addSubview:self.image];
        
        CGFloat originX = self.image.frame.origin.x + self.image.frame.size.width + MARGIN / 2.0;
        
        self.titleLabel = ({
            CGRect frame = CGRectMake( originX + MARGIN / 2.0, MARGIN, width - MARGIN * 2 - originX, 20);
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.textColor = UIColorFromRGB(0x999999);
            label.font = [UIFont boldSystemFontOfSize:13];
            label;
        });
        [self addSubview:self.titleLabel];
    }
    return self;
}

@end
