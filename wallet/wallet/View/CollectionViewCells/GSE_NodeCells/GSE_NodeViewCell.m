//
//  GSE_NodeViewCell.m
//  GSEWallet
//
//  Created by user on 27/12/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_NodeViewCell.h"

@interface GSE_NodeViewCell ()
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) UIImageView *menuBackground;

@property (nonatomic, strong) UILabel *tipLabel1;
@property (nonatomic, strong) UILabel *tipLabel2;
@property (nonatomic, strong) UILabel *tipLabel3;

@property (nonatomic, strong) UILabel *gseLabel;
@property (nonatomic, strong) UILabel *incomeLabel;
@property (nonatomic, strong) UILabel *percentageLabel;

@property (nonatomic, strong) UILabel * tipLabel;

@property (nonatomic, strong) UIButton *detailButton;
@end

@implementation GSE_NodeViewCell

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
   
    self.menuView = ({
        UIView *view = [[UIView alloc] init];
        view;
    });
    [self.contentView addSubview:self.menuView];
    
    self.menuBackground = ({
        UIImage *image = [UIImage imageNamed:@"node_back"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView;
    });
    [self.menuView addSubview:self.menuBackground];
    
    self.tipLabel1 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:12];
        label.text = NSLocalizedString(@"总委托权益", nil);
        label;
    });
    [self.menuView addSubview:self.tipLabel1];
    
    self.tipLabel2 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:12];
        label.text = NSLocalizedString(@"总收益", nil);
        label;
    });
    [self.menuView addSubview:self.tipLabel2];
    
    self.tipLabel3 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:12];
        label.text = NSLocalizedString(@"总收益率", nil);
        label;
    });
    [self.menuView addSubview:self.tipLabel3];
    
    self.gseLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x4c78ec);
        label.font = [UIFont systemFontOfSize:26];
        label;
    });
    [self.menuView addSubview:self.gseLabel];
    
    self.incomeLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x4c78ec);
        label.font = [UIFont systemFontOfSize:26];
        label;
    });
    [self.menuView addSubview:self.incomeLabel];
    
    self.percentageLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x4c78ec);
        label.font = [UIFont systemFontOfSize:26];
        label;
    });
    [self.menuView addSubview:self.percentageLabel];
    
    self.detailButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setTitle:NSLocalizedString(@"查看详情", nil) forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"node_detail_indicator"];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.menuView addSubview:self.detailButton];
    
    self.tipLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:18];
        label.text = NSLocalizedString(@"供选择方案", nil);
        label;
    });
    [self.contentView addSubview:self.tipLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    
    self.menuView.frame = ({
        CGRect frame = self.menuView.frame;
        frame.origin.x = 10;
        frame.origin.y = 20;
        frame.size.width = width - 20;
        frame.size.height = 260 / 2.0;
        frame;
    });
    
    [self.menuBackground sizeToFit];
    self.menuBackground.frame = ({
        CGRect frame = self.menuBackground.frame;
        frame.origin.x = -5;
        frame.origin.y = -5;
        frame.size.width = width - 10;
        frame.size.height = 260 / 2.0 + 10;
        frame;
    });
    
    CGFloat menuWidth = CGRectGetWidth(self.menuView.bounds);
    
    [self.tipLabel1 sizeToFit];
    self.tipLabel1.center = ({
        CGPoint center = self.tipLabel1.center;
        center.x = menuWidth / 5.0;
        center.y = 30;
        center;
    });
    
    [self.gseLabel sizeToFit];
    self.gseLabel.center = ({
        CGPoint center = self.gseLabel.center;
        center.x = self.tipLabel1.center.x;
        center.y = self.tipLabel1.center.y + 40;
        center;
    });
    
    [self.tipLabel2 sizeToFit];
    self.tipLabel2.center = ({
        CGPoint center = self.tipLabel2.center;
        center.x = menuWidth / 2.0;
        center.y = 30;
        center;
    });
    
    [self.incomeLabel sizeToFit];
    self.incomeLabel.center = ({
        CGPoint center = self.incomeLabel.center;
        center.x = self.tipLabel2.center.x;
        center.y = self.tipLabel2.center.y + 40;
        center;
    });
    
    [self.tipLabel3 sizeToFit];
    self.tipLabel3.center = ({
        CGPoint center = self.tipLabel3.center;
        center.x = menuWidth / 5.0 * 4.0;
        center.y = 30;
        center;
    });
    
    [self.percentageLabel sizeToFit];
    self.percentageLabel.center = ({
        CGPoint center = self.percentageLabel.center;
        center.x = self.tipLabel3.center.x;
        center.y = self.tipLabel3.center.y + 40;
        center;
    });
    
    [self.detailButton sizeToFit];
    [self.detailButton alignImageToRightWithGap:10];
    self.detailButton.center = ({
        CGPoint center = self.detailButton.center;
        center.x = menuWidth - CGRectGetWidth(self.detailButton.frame) / 2.0 - 20;
        center.y = 210 / 2.0;
        center;
    });
    
    [self.tipLabel sizeToFit];
    self.tipLabel.frame = ({
        CGRect frame = self.tipLabel.frame;
        frame.origin.x = 13;
        frame.origin.y = 170;
        frame;
    });
}

#pragma mark - setter

- (void)setGse:(NSString *)gse{
    _gse = [gse copy];
    [self.gseLabel setText:_gse];
    
}
- (void)setIncome:(NSString *)income{
    _income = [income copy];
    [self.incomeLabel setText:_income];
}
- (void)setPercentage:(NSString *)percentage{
    _percentage = [percentage copy];
    [self.percentageLabel setText:_percentage];
    [self setNeedsLayout];
}

#pragma mark - action

- (void)detailAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(detailAction:)]) {
        [self.delegate detailAction:sender];
    }
}
@end
