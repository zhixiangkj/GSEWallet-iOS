//
//  GSE_FAQCell
//  GSEWallet
//
//  Created by user on 01/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_FAQCell.h"

@interface GSE_FAQCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *image;
@end

@implementation GSE_FAQCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.image = ({
            UIImage *image = [UIImage imageNamed:@"wallet_faq"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.center = CGPointMake(MARGIN + imageView.bounds.size.width / 2.0, MARGIN + imageView.bounds.size.height / 2.0);
            imageView;
        });
        [self addSubview:self.image];
        
        CGFloat originX = self.image.frame.origin.x + self.image.frame.size.width + MARGIN / 2.0;
        
        self.titleLabel = ({
            
            CGRect frame = CGRectMake( originX, 0, width - MARGIN * 2 - originX, 0);
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont boldSystemFontOfSize:12];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label;
        });
        [self addSubview:self.titleLabel];
        
        self.subTitleLabel = ({
            CGRect frame = CGRectMake(originX, 0, width - MARGIN * 2 - originX, 0);
            UILabel *label = [[UILabel alloc] initWithFrame:frame];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont systemFontOfSize:12];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label;
        });
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

- (void)setQuestion:(NSString *)question{
    _question = question;
    
    CGRect frame = self.titleLabel.frame;
    [self.titleLabel setText:question lineSpacing:5 wordSpacing:1];
    [self.titleLabel sizeToFit];
    frame.origin.y = self.image.frame.origin.y;
    frame.size.height = self.titleLabel.bounds.size.height;
    self.titleLabel.frame = frame;
}

- (void)setAnswer:(NSString *)answer{
    _answer = answer;
    
    CGFloat originY = 20 + self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;
    CGRect frame = self.subTitleLabel.frame;
    //[self.subTitleLabel setText:answer lineSpacing:0 wordSpacing:0.5];
    [self.subTitleLabel setText:answer lineSpacing:10 wordSpacing:0.5];
    [self.subTitleLabel sizeToFit];
    frame.origin.y = originY;
    frame.size.height = self.subTitleLabel.bounds.size.height;
    self.subTitleLabel.frame = frame;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    frame.size.height = self.subTitleLabel.frame.origin.y + self.subTitleLabel.frame.size.height + 20;
    self.frame = frame;
}

@end
