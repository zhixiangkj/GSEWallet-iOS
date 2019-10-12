//
//  RebateShareViewCell.m
//  GSEWallet
//
//  Created by user on 01/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_RebateShareViewCell.h"

@interface GSE_RebateShareViewCell ()
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *howitworksButton;
@property (nonatomic, strong) UIImageView *presentImageView;
@property (nonatomic, strong) UILabel *shareTipLabel;
@property (nonatomic, strong) UIView *codeView;
@property (nonatomic, strong) UIButton *codeCopyButton;
@property (nonatomic, strong) UIButton *codeShareButton;
@end

@implementation GSE_RebateShareViewCell

- (instancetype)init {
    if (self = [super init]) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    //self.contentView.backgroundColor = [UIColor blueColor];
    self.menuView = ({
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 5;
        view.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        view.layer.borderWidth = 0.5;
        view;
    });
    [self.contentView addSubview:self.menuView];
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont boldSystemFontOfSize:18];
        label.text = NSLocalizedString(@"Send Your Friends Gas Rebate", nil);
        label;
    });
    [self.menuView addSubview:self.titleLabel];
    
    self.detailLabel = ({
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect frame = CGRectMake(0, 0, width - 50, 0);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.text = NSLocalizedString(@"Invite 2 friends, get 2 gas rebates everyday!\n(0/2)", nil);
        [label setText:label.text lineSpacing:8 wordSpacing:0.5];
        [label sizeToFit];
        label;
    });
    [self.menuView addSubview:self.detailLabel];
    
    self.howitworksButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:NSLocalizedString(@"How it works", nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x4775f4) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button sizeToFit];
        [button addTarget:self action:@selector(howAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.menuView addSubview:self.howitworksButton];
    
    self.presentImageView = ({
        UIImage *image = [UIImage imageNamed:@"rebate_box"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView;
    });
    [self.menuView addSubview:self.presentImageView];
    
    self.shareTipLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:12];
        label.text = NSLocalizedString(@"Share Your Invitation Code", nil);
        label;
    });
    [self.menuView addSubview:self.shareTipLabel];
    
    self.codeView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xf2f2f2);
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 0.5f;
        view.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        view;
    });
    [self.menuView addSubview:self.codeView];
    
    self.codeCopyButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitle:@"SOY8EA72" forState:UIControlStateNormal];
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [button addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.codeView addSubview:self.codeCopyButton];
    
    self.codeShareButton = ({
        UIButton *button = [[UIButton alloc] init];
        UIImage *image = [UIImage imageNamed:@"rebate_share"];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.codeView addSubview:self.codeShareButton];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds) - 5 - 20;
    
    self.menuView.frame = CGRectMake(10, 5, width - 20, height);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = ({
        CGPoint center = self.titleLabel.center;
        center.x = (15 + CGRectGetWidth(self.titleLabel.bounds) / 2.0);
        center.y = (15 + CGRectGetHeight(self.titleLabel.bounds) / 2.0);
        center;
    });
    
    //[self.detailLabel sizeToFit];
    self.detailLabel.center = ({
        CGPoint center = self.detailLabel.center;
        center.x = (15 + CGRectGetWidth(self.detailLabel.bounds) / 2.0);
        center.y = (20 + CGRectGetMaxY(self.titleLabel.frame) + CGRectGetHeight(self.detailLabel.bounds) / 2.0);
        center;
    });
    
    self.howitworksButton.center = ({
        CGPoint center = self.howitworksButton.center;
        center.x = (15 + CGRectGetWidth(self.howitworksButton.bounds) / 2.0);
        center.y = (10 + CGRectGetMaxY(self.detailLabel.frame) + CGRectGetHeight(self.howitworksButton.bounds) / 2.0);
        center;
    });
    
    self.codeView.frame = ({
        CGRect frame = self.codeView.frame;
        frame.origin.x = 14;
        //frame.origin.y = (14 + CGRectGetMaxY(self.shareTipLabel.frame));
        frame.origin.y = height - 40 - 22;
        frame.size.width = CGRectGetWidth(self.menuView.bounds) - 28;
        frame.size.height = 40;
        frame;
    });
    
    CGFloat ratio = height / (490  - 10 - 20);
    
    [self.shareTipLabel sizeToFit];
    self.shareTipLabel.center = ({
        CGPoint center = self.shareTipLabel.center;
        center.x = (15 + CGRectGetWidth(self.shareTipLabel.bounds) / 2.0);
        center.y = (CGRectGetMinY(self.codeView.frame) - 20 * ratio - CGRectGetHeight(self.shareTipLabel.bounds) / 2.0);
        center;
    });
    
    self.presentImageView.transform = CGAffineTransformMakeScale(ratio, ratio);
    
    self.presentImageView.center = ({
        CGPoint center = self.presentImageView.center;
        center.x = CGRectGetWidth(self.menuView.bounds) - CGRectGetWidth(self.presentImageView.frame) / 2.0 - 40;
        center.y = (CGRectGetMaxY(self.detailLabel.frame) + CGRectGetMinY(self.shareTipLabel.frame)) / 2.0;
        center;
    });
    
    height = CGRectGetHeight(self.codeView.frame);
    
    [self.codeCopyButton sizeToFit];
    self.codeCopyButton.frame = ({
        CGRect frame = self.codeCopyButton.frame;
        frame.origin.x = 10;
        frame.origin.y = 0;
        frame.size.height = height;
        frame;
    });
    
    [self.codeShareButton sizeToFit];
    self.codeShareButton.frame = ({
        CGRect frame = self.codeShareButton.frame;
        frame.size.width = height;
        frame.size.height = height;
        frame;
    });
    self.codeShareButton.center = ({
        CGPoint center = self.codeShareButton.center;
        center.x = CGRectGetWidth(self.codeView.bounds) - CGRectGetWidth(self.codeShareButton.bounds) / 2.0;
        center.y = self.codeCopyButton.center.y;
        center;
    });
}

- (void)reloadData{
    
    [self.codeCopyButton setTitle:_code forState:UIControlStateNormal];
    
    if ([_code isEqualToString:NSLocalizedString(@"Network Error", nil)]) {
        self.codeShareButton.hidden = YES;
    }else{
        self.codeShareButton.hidden = NO;
    }
    
    if (!self.require || !self.acquire || !self.invited) {
        return;
    }
    
    if (self.invited.integerValue >= self.require.integerValue) {
        NSString * string = NSLocalizedString(@"Gas Rebates Unlocked", nil);
        [self.titleLabel setText:string];
        
        NSString *string1 = [NSString stringWithFormat:NSLocalizedString(@"Congratulations, you have %@ gas rebates everyday!", nil),self.acquire];
        [self.detailLabel setText:string1 lineSpacing:8 wordSpacing:0.5];
        
    }else{
        NSString *string = NSLocalizedString(@"Send Your Friends Gas Rebate", nil);
        [self.titleLabel setText:string];
        
        NSString *string1 = [NSString stringWithFormat:NSLocalizedString(@"Invite %@ friends, get %@ gas rebates everyday!\n(%@/%@)", nil),self.require,self.acquire,self.invited,self.require];
        [self.detailLabel setText:string1 lineSpacing:8 wordSpacing:0.5];
    }
    
    [self setNeedsLayout];
}


#pragma mark - action

- (void)copyAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(copyAction:)]) {
        [self.delegate copyAction:sender];
    }
}

- (void)shareAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(shareAction:)]) {
        [self.delegate shareAction:self.codeCopyButton];
    }
}

- (void)howAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(howAction:)]) {
        [self.delegate howAction:sender];
    }
}

@end
