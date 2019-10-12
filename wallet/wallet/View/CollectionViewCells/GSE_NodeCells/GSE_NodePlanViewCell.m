//
//  GSE_NodePlanViewCell.m
//  GSEWallet
//
//  Created by user on 29/12/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_NodePlanViewCell.h"

@interface GSE_NodePlanViewCell ()
@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, strong) UILabel *tipLabel1;
@property (nonatomic, strong) UILabel *tipLabel2;
@property (nonatomic, strong) UILabel *tipLabel3;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *percentageLabel;
@property (nonatomic, strong) UILabel *dayLabel;

@property (nonatomic, strong) UIButton *detailButton;

@property (nonatomic, strong) UIView *separator1;
@property (nonatomic, strong) UIView *separator2;

@end

@implementation GSE_NodePlanViewCell

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
        view.layer.cornerRadius = 5;
        view.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        view.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        view.clipsToBounds = YES;
        {
            UIView *blue = [[UIView alloc] init];
            blue.tag = 1000;
            blue.backgroundColor = UIColorFromRGB(0x4c78ec);
            [view addSubview:blue];
        }
        {
            UIView *white = [[UIView alloc] init];
            white.tag = 1001;
            white.backgroundColor = [UIColor whiteColor];
            [view addSubview:white];
        }
        view;
    });
    [self.contentView addSubview:self.menuView];
    
    self.tipLabel1 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12];
        label.text = NSLocalizedString(@"委托权益", nil);
        label;
    });
    [self.menuView addSubview:self.tipLabel1];
    
    self.tipLabel2 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12];
        label.text = NSLocalizedString(@"委托期限", nil);
        label;
    });
    [self.menuView addSubview:self.tipLabel2];
    
    self.tipLabel3 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:10];
        label.text = NSLocalizedString(@"最低委托额度：10,000GSE", nil);
        label;
    });
    [self.menuView addSubview:self.tipLabel3];
    
    self.titleLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"GSE节点计划";
        label;
    });
    [self.menuView addSubview:self.titleLabel];
    
    self.percentageLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:24];
        label.text = @"10%";
        label;
    });
    [self.menuView addSubview:self.percentageLabel];
    
    self.dayLabel =({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x4c78ec);
        label.font = [UIFont systemFontOfSize:24];
        label.text = NSLocalizedString(@"30天", nil);
        label;
    });
    [self.menuView addSubview:self.dayLabel];
    
    self.detailButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitle:NSLocalizedString(@"查看", nil) forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"node_detail_back"];
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.menuView addSubview:self.detailButton];
    
    self.separator1 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xdedede);
        view;
    });
    [self.menuView addSubview:self.separator1];
    
    self.separator2 = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xdedede);
        view;
    });
    [self.menuView addSubview:self.separator2];
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
        frame.size.height = 308 / 2.0;
        frame;
    });
    
    {
        CGRect rect  = CGRectMake(0, 0, 14, CGRectGetHeight(self.menuView.bounds));
        UIView *blue = [self.menuView viewWithTag:1000];
        blue.frame = rect;
    }
    CGFloat menuWidth = CGRectGetWidth(self.menuView.bounds);
    CGFloat menuHeight = CGRectGetHeight(self.menuView.bounds);
    {
        
        CGRect rect  = CGRectMake(7, 0, menuWidth - 14, menuHeight);
        UIView *white = [self.menuView viewWithTag:1001];
        white.frame = rect;
    }
    
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = ({
        CGRect frame = self.titleLabel.frame;
        frame.origin.x = 20;
        frame.size.width = menuWidth - 40;
        frame;
    });
    self.titleLabel.center = ({
        CGPoint center = self.titleLabel.center;
        center.y = 21;
        center;
    });
    
    self.separator1.frame = ({
        CGRect frame = self.separator1.frame;
        frame.origin.x = 10;
        frame.origin.y = 36;
        frame.size.width = menuWidth - 20;
        frame.size.height = 1.0 / [UIScreen mainScreen].scale;
        frame;
    });
    
    self.separator2.frame = ({
        CGRect frame = self.separator2.frame;
        frame.origin.x = menuWidth / 2.0 + 35;
        frame.origin.y = 20 + CGRectGetMaxY(self.separator1.frame);
        frame.size.width = 1.0 / [UIScreen mainScreen].scale;
        frame.size.height = 154 / 2.0;
        frame;
    });
    
    [self.tipLabel1 sizeToFit];
    self.tipLabel1.frame = ({
        CGRect frame = self.tipLabel1.frame;
        frame.origin.x = 20;
        frame.origin.y = 20 + CGRectGetMaxY(self.separator1.frame);
        frame;
    });
    
    [self.tipLabel2 sizeToFit];
    self.tipLabel2.frame = ({
        CGRect frame = self.tipLabel2.frame;
        frame.origin.x = CGRectGetMinX(self.separator2.frame) - 40 - CGRectGetWidth(self.tipLabel2.bounds);
        frame.origin.y = 20 + CGRectGetMaxY(self.separator1.frame);
        frame;
    });
    
    [self.tipLabel3 sizeToFit];
    self.tipLabel3.frame = ({
        CGRect frame = self.tipLabel3.frame;
        frame.origin.x = 20;
        frame.origin.y = 85 + CGRectGetMaxY(self.separator1.frame);
        frame;
    });
    
    [self.percentageLabel sizeToFit];
    self.percentageLabel.frame = ({
        CGRect frame = self.percentageLabel.frame;
        frame.origin.x = 20;
        frame.origin.y = 45 + CGRectGetMaxY(self.separator1.frame);
        frame;
    });
    
    [self.dayLabel sizeToFit];
    self.dayLabel.frame = ({
        CGRect frame = self.dayLabel.frame;
        frame.origin.x = CGRectGetMinX(self.tipLabel2.frame);
        frame.origin.y = CGRectGetMinY(self.percentageLabel.frame);
        frame;
    });
    
    [self.detailButton sizeToFit];
    self.detailButton.center = ({
        CGPoint center = self.detailButton.center;
        center.x = CGRectGetMaxX(self.separator2.frame) + (menuWidth - CGRectGetMinX(self.separator2.frame)) / 2.0 ;
        center.y = self.dayLabel.center.y;
        center;
    });
}

#pragma mark - setters

- (void)setName:(NSString *)name{
    _name = [name copy];
    self.titleLabel.text = _name;
}

- (void)setPercentage:(NSString *)percentage{
    _percentage = [percentage copy];
    self.percentageLabel.text = _percentage;
}

- (void)setDays:(NSString *)days{
    _days = [days copy];
    self.dayLabel.text = [NSString stringWithFormat:@"%@ 天",_days];
}

- (void)setGse:(NSString *)gse{
    _gse = [gse copy];
    self.tipLabel3.text = [NSString stringWithFormat:@"最低委托额度：%@ GSE",[_gse commaWithPrefix:@""]];
    [self setNeedsLayout];
}

#pragma mark - action

- (void)detailAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(detailAction:)]) {
        [self.delegate detailAction:sender];
    }
}

@end
