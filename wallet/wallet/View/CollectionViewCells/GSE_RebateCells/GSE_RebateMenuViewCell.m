//
//  GSE_RebateMenuViewCell.m
//  GSEWallet
//
//  Created by user on 01/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_RebateMenuViewCell.h"

@interface GSE_RebateMenuViewCell ()
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UILabel *quantityLabel;
@property (nonatomic, strong) UIButton *withdrawButton;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UIButton *historyButton;
@end

@implementation GSE_RebateMenuViewCell

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
    //self.contentView.backgroundColor = [UIColor redColor];
    self.menuView = ({
        UIView *view = [[UIView alloc] init];
        view.layer.cornerRadius = 5;
        view.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        view.layer.borderWidth = 0.5;
        view;
    });
    [self.contentView addSubview:self.menuView];
    
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont boldSystemFontOfSize:12];
        label.text = NSLocalizedString(@"GSE from Rebate", nil);
        [label sizeToFit];
        label.center = CGPointMake(15 + CGRectGetWidth(label.bounds) / 2.0, 20 + CGRectGetHeight(label.bounds) / 2.0);
        [self.menuView addSubview:label];
    }
    self.quantityLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont boldSystemFontOfSize:15];
        label.text = @"0.0000";
        label;
    });
    [self.menuView addSubview:self.quantityLabel];
    
    self.withdrawButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:NSLocalizedString(@"WITHDRAW", nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x4775f4) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button addTarget:self action:@selector(withdrawAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.menuView addSubview:self.withdrawButton];
    
    self.separatorView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xdedede);
        view;
    });
    [self.menuView addSubview:self.separatorView];
    
    self.historyButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:NSLocalizedString(@"History", nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setImage:[UIImage imageNamed:@"rebate_history"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(historyAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.menuView addSubview:self.historyButton];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    
    
    self.menuView.frame = CGRectMake(10, 20, width - 20, 230 / 2.0);
    
    [self.quantityLabel sizeToFit];
    self.quantityLabel.frame = ({
        CGRect frame = self.quantityLabel.frame;
        frame.origin.x = 15;
        frame.origin.y = 42;
        frame.size.width = width / 2.0 - 15;
        frame;
    });
    
    self.separatorView.frame = ({
        CGRect frame = self.separatorView.frame;
        frame.origin.x = 15;
        frame.origin.y = 74;
        frame.size.width = CGRectGetWidth(self.menuView.bounds) - 30;
        frame.size.height = 1.0 / [UIScreen mainScreen].scale;
        frame;
    });
    [self.withdrawButton sizeToFit];
    self.withdrawButton.center = ({
        CGPoint center = self.withdrawButton.center;
        center.x = CGRectGetWidth(self.menuView.bounds) - 15 - CGRectGetWidth(self.withdrawButton.bounds) / 2.0;
        center.y = self.quantityLabel.center.y;
        center;
    });
    
    [self.historyButton sizeToFit];
    [self.historyButton alignImageToRightWithGap:10];
    self.historyButton.center = ({
        CGPoint center = self.historyButton.center;
        center.x = CGRectGetWidth(self.menuView.bounds) - 15 - CGRectGetWidth(self.historyButton.bounds) / 2.0;
        center.y = ( CGRectGetHeight(self.menuView.bounds) + CGRectGetMaxY(self.separatorView.frame)) / 2.0;
        center;
    });
}

- (void)setQuantity:(NSString *)quantity{
    _quantity = [quantity copy];
    [self.quantityLabel setText:_quantity];
}

- (void)withdrawAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(withdrawAction:)]) {
        [self.delegate withdrawAction:sender];
    }
}

- (void)historyAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(historyAction:)]) {
        [self.delegate historyAction:sender];
    }
}

@end
