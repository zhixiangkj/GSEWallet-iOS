//
//  GSE_NodePlanDetailCell.m
//  GSEWallet
//
//  Created by user on 07/01/2019.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

#import "GSE_NodePlanDetailCell.h"

#import <FSLineChart/FSLineChart.h>

@interface GSE_NodePlanDetailCell ()
@property (nonatomic, strong) UILabel *tipLabel1;
@property (nonatomic, strong) UILabel *tipLabel2;
@property (nonatomic, strong) UILabel *tipLabel3;

@property (nonatomic, strong) UILabel *valueLabel1;
@property (nonatomic, strong) UILabel *valueLabel2;
@property (nonatomic, strong) UILabel *valueLabel3;

@property (nonatomic, strong) UIButton *detailButton;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *tipLabel_BTC;
@property (nonatomic, strong) UILabel *tipLabel_ETH;
@property (nonatomic, strong) UILabel *tipLabel_GSE;

@property (nonatomic, strong) UILabel *percentageLabel_BTC;
@property (nonatomic, strong) UILabel *percentageLabel_ETH;
@property (nonatomic, strong) UILabel *percentageLabel_GSE;

@property (nonatomic, strong) FSLineChart *lineChart_BTC;
@property (nonatomic, strong) FSLineChart *lineChart_ETH;
@property (nonatomic, strong) FSLineChart *lineChart_GSE;

@property (nonatomic, strong) UIButton *getRewardButton;
@property (nonatomic, strong) UILabel *tipLabel_rewardLeft;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *tipLabel_rewardRight;

@end

@implementation GSE_NodePlanDetailCell

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
    
    self.tipLabel1 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:13];
        label.text = NSLocalizedString(@"总委托权益", nil);
        label;
    });
    [self.contentView addSubview:self.tipLabel1];
    
    self.tipLabel2 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:13];
        label.text = NSLocalizedString(@"委托时间", nil);
        label;
    });
    [self.contentView addSubview:self.tipLabel2];
    
    self.tipLabel3 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:13];
        label.text = NSLocalizedString(@"委托收益", nil);
        label;
    });
    [self.contentView addSubview:self.tipLabel3];
    
    
    self.valueLabel1 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"-";
        label;
    });
    [self.contentView addSubview:self.valueLabel1];
    
    self.valueLabel2 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"-";
        label;
    });
    [self.contentView addSubview:self.valueLabel2];
    
    self.valueLabel3 = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:18];
        label.text = @"-";
        label;
    });
    [self.contentView addSubview:self.valueLabel3];
    
    self.detailButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:UIColorFromRGB(0x4475f4) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setTitle:NSLocalizedString(@"更多详情", nil) forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"node_detail_indicator_blue"];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.contentView addSubview:self.detailButton];
    
    self.tipLabel = ({
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:13];
        label.text = NSLocalizedString(@"最近10日价格变化", nil);
        label;
    });
    [self.contentView addSubview:self.tipLabel];
    
    self.tipLabel_BTC = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:11];
        label.text = NSLocalizedString(@"BTC:", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.tipLabel_BTC];
    
    self.tipLabel_ETH = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:11];
        label.text = NSLocalizedString(@"ETH:", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.tipLabel_ETH];
    
    self.tipLabel_GSE = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:11];
        label.text = NSLocalizedString(@"GSE:", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.tipLabel_GSE];
    
    self.percentageLabel_BTC = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:11];
        label.text = NSLocalizedString(@"0%", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.percentageLabel_BTC];
    
    self.percentageLabel_ETH = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:11];
        label.text = NSLocalizedString(@"0%", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.percentageLabel_ETH];
    
    self.percentageLabel_GSE = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:11];
        label.text = NSLocalizedString(@"0%", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.percentageLabel_GSE];
    
    self.lineChart_BTC = ({
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect rect = CGRectMake(0, 0, width - 180, 50);
        FSLineChart* chart = [[FSLineChart alloc] initWithFrame:rect];
        chart.drawInnerGrid = NO;
        chart.axisLineWidth = 0;
        chart.fillColor = [UIColor clearColor];
        chart;
    });
    [self.contentView addSubview:self.lineChart_BTC];
    
    self.lineChart_ETH = ({
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect rect = CGRectMake(0, 0, width - 180, 50);
        FSLineChart* chart = [[FSLineChart alloc] initWithFrame:rect];
        chart.drawInnerGrid = NO;
        chart.axisLineWidth = 0;
        chart.fillColor = [UIColor clearColor];
        chart;
    });
    [self.contentView addSubview:self.lineChart_ETH];
    
    self.lineChart_GSE = ({
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect rect = CGRectMake(0, 0, width - 180, 50);
        FSLineChart* chart = [[FSLineChart alloc] initWithFrame:rect];
        chart.drawInnerGrid = NO;
        chart.axisLineWidth = 0;
        chart.fillColor = [UIColor clearColor];
        chart;
    });
    [self.contentView addSubview:self.lineChart_GSE];
    
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        
        for(int i=0;i<20;i++) {
            [array addObject:[NSNumber numberWithInt:rand()]];
        }
        [self.lineChart_BTC setChartData:array];
    }
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        
        for(int i=0;i<20;i++) {
            [array addObject:[NSNumber numberWithInt:rand()]];
        }
        [self.lineChart_ETH setChartData:array];
    }
    {
        NSMutableArray* array = [[NSMutableArray alloc] init];
        
        for(int i=0;i<20;i++) {
            [array addObject:[NSNumber numberWithInt:rand()]];
        }
        [self.lineChart_GSE setChartData:array];
    }
    
    self.getRewardButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [button setTitle:NSLocalizedString(@"获得节点奖励", nil) forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0x4475f4) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(transferAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.contentView addSubview:self.getRewardButton];
    
    self.tipLabel_rewardLeft = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:10];
        label.text = NSLocalizedString(@"委托收益由", nil);
        label;
    });
    [self.contentView addSubview:self.tipLabel_rewardLeft];
    
    self.tipLabel_rewardRight = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:10];
        label.text = NSLocalizedString(@"提供并担保", nil);
        label;
    });
    [self.contentView addSubview:self.tipLabel_rewardRight];
    
    self.logoImageView = ({
        UIImage *image = [UIImage imageNamed:@"node_detail_logo"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView;
    });
    [self.contentView addSubview:self.logoImageView];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    
    [self.tipLabel1 sizeToFit];
    self.tipLabel1.frame = ({
        CGRect frame = self.tipLabel1.frame;
        frame.origin.x = 30;
        frame.origin.y = 30;
        frame;
    });
    
    [self.valueLabel1 sizeToFit];
    self.valueLabel1.frame = ({
        CGRect frame = self.valueLabel1.frame;
        frame.origin.x = 30;
        frame.origin.y = 20 + CGRectGetMaxY(self.tipLabel1.frame);
        frame;
    });
    
    [self.tipLabel2 sizeToFit];
    self.tipLabel2.frame = ({
        CGRect frame = self.tipLabel2.frame;
        frame.origin.x = 30;
        frame.origin.y = 20 + CGRectGetMaxY(self.valueLabel1.frame);
        frame;
    });
    
    [self.valueLabel2 sizeToFit];
    self.valueLabel2.frame = ({
        CGRect frame = self.valueLabel2.frame;
        frame.origin.x = 30;
        frame.origin.y = 20 + CGRectGetMaxY(self.tipLabel2.frame);
        frame;
    });
    
    [self.tipLabel3 sizeToFit];
    self.tipLabel3.frame = ({
        CGRect frame = self.tipLabel3.frame;
        frame.origin.x = 30;
        frame.origin.y = 20 + CGRectGetMaxY(self.valueLabel2.frame);
        frame;
    });
    
    [self.valueLabel3 sizeToFit];
    self.valueLabel3.frame = ({
        CGRect frame = self.valueLabel3.frame;
        frame.origin.x = 30;
        frame.origin.y = 20 + CGRectGetMaxY(self.tipLabel3.frame);
        frame;
    });
    
    [self.detailButton sizeToFit];
    [self.detailButton alignImageToRightWithGap:5];
    self.detailButton.center = ({
        CGPoint center = self.detailButton.center;
        center.x = width - CGRectGetWidth(self.detailButton.frame) / 2.0 - 30;
        center.y = self.valueLabel3.center.y;
        center;
    });
    
    [self.tipLabel sizeToFit];
    self.tipLabel.frame = ({
        CGRect frame = self.tipLabel.frame;
        frame.origin.x = 30;
        frame.origin.y = 20 + CGRectGetMaxY(self.valueLabel3.frame);
        frame;
    });
    
    self.lineChart_BTC.frame = ({
        CGRect frame = self.lineChart_BTC.frame;
        frame.origin.x = 90;
        frame.origin.y = 20 + CGRectGetMaxY(self.tipLabel.frame);
        frame;
    });
    
    self.lineChart_ETH.frame = ({
        CGRect frame = self.lineChart_ETH.frame;
        frame.origin.x = 90;
        frame.origin.y = 20 + CGRectGetMaxY(self.lineChart_BTC.frame);
        frame;
    });
    
    self.lineChart_GSE.frame = ({
        CGRect frame = self.lineChart_GSE.frame;
        frame.origin.x = 90;
        frame.origin.y = 20 + CGRectGetMaxY(self.lineChart_ETH.frame);
        frame;
    });
    
    [self.tipLabel_BTC sizeToFit];
    self.tipLabel_BTC.frame = ({
        CGRect frame = self.tipLabel_BTC.frame;
        frame.origin.x = 30;
        frame.size.width = 60;
        frame.origin.y = CGRectGetMinY(self.lineChart_BTC.frame);
        frame.size.height = CGRectGetHeight(self.lineChart_BTC.frame);
        frame;
    });
    
    [self.tipLabel_ETH sizeToFit];
    self.tipLabel_ETH.frame = ({
        CGRect frame = self.tipLabel_ETH.frame;
        frame.origin.x = 30;
        frame.origin.y = CGRectGetMinY(self.lineChart_ETH.frame);
        frame.size.width = 60;
        frame.size.height = CGRectGetHeight(self.lineChart_ETH.frame);
        frame;
    });
    
    [self.tipLabel_GSE sizeToFit];
    self.tipLabel_GSE.frame = ({
        CGRect frame = self.tipLabel_GSE.frame;
        frame.origin.x = 30;
        frame.size.width = 60;
        frame.origin.y = CGRectGetMinY(self.lineChart_GSE.frame);
        frame.size.height = CGRectGetHeight(self.lineChart_GSE.frame);
        frame;
    });
    
    self.percentageLabel_BTC.frame = ({
        CGRect frame = self.tipLabel_BTC.frame;
        frame.origin.x = width - 90;
        frame.size.width = 60;
        frame;
    });
    
    self.percentageLabel_ETH.frame = ({
        CGRect frame = self.tipLabel_ETH.frame;
        frame.origin.x = width - 90;
        frame.size.width = 60;
        frame;
    });
    
    self.percentageLabel_GSE.frame = ({
        CGRect frame = self.tipLabel_GSE.frame;
        frame.origin.x = width - 90;
        frame.size.width = 60;
        frame;
    });
    
    self.getRewardButton.layer.masksToBounds = YES;
    self.getRewardButton.layer.cornerRadius = 25;
    
    self.getRewardButton.frame = ({
        CGRect frame = self.getRewardButton.frame;
        frame.origin.x = 45;
        frame.origin.y = 60 + CGRectGetMaxY(self.percentageLabel_GSE.frame);
        frame.size.width = width - 90;
        frame.size.height = 50;
        frame;
    });
    
    self.logoImageView.center = ({
        CGPoint center = self.logoImageView.center;
        center.x = width / 2.0;
        center.y = CGRectGetMaxY(self.getRewardButton.frame) + 20;
        center;
    });
    
    [self.tipLabel_rewardLeft sizeToFit];
    self.tipLabel_rewardLeft.frame = ({
        CGRect frame = self.tipLabel_rewardLeft.frame;
        frame.origin.x = CGRectGetMinX(self.logoImageView.frame) - CGRectGetWidth(self.tipLabel_rewardLeft.frame) - 5;
        frame;
    });
    self.tipLabel_rewardLeft.center = ({
        CGPoint center = self.tipLabel_rewardLeft.center;
        center.y = self.logoImageView.center.y;
        center;
    });
    
    [self.tipLabel_rewardRight sizeToFit];
    self.tipLabel_rewardRight.frame = ({
        CGRect frame = self.tipLabel_rewardRight.frame;
        frame.origin.x = CGRectGetMaxX(self.logoImageView.frame) + 5;
        frame;
    });
    self.tipLabel_rewardRight.center = ({
        CGPoint center = self.tipLabel_rewardRight.center;
        center.y = self.logoImageView.center.y;
        center;
    });
}

- (void)detailAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(detailAction:)]) {
        [self.delegate detailAction:sender];
    }
}

- (void)transferAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(transferAction:)]) {
        [self.delegate transferAction:sender];
    }
}
@end
