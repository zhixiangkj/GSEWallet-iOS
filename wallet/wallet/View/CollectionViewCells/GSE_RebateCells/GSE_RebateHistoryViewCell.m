//
//  RebateHistoryViewCell.m
//  GSEWallet
//
//  Created by user on 06/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_RebateHistoryViewCell.h"
@interface GSE_RebateHistoryMenuCell()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UIView *separator;
@end
@implementation GSE_RebateHistoryMenuCell
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
    self.label1 = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0x666666);
        label.text = NSLocalizedString(@"TxHash", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.label1];
    
    self.label2 = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor= UIColorFromRGB(0x666666);
        label.text = NSLocalizedString(@"Date", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.label2];
    
    self.label3 = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor= UIColorFromRGB(0x666666);
        label.text = NSLocalizedString(@"Source", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.label3];
    
    self.label4 = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor= UIColorFromRGB(0x666666);
        label.text = @"GSE";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.label4];
    
    self.separator = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xdedede);
        view;
    });
    [self.contentView addSubview:self.separator];
    
    //self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    
    self.label1.frame = ({
        CGRect frame = self.label1.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size.width = width / 4.0;
        frame.size.height = height;
        frame;
    });
    
    self.label2.frame = ({
        CGRect frame = self.label2.frame;
        frame.origin.x = width / 4.0;
        frame.origin.y = 0;
        frame.size.width = width / 4.0;
        frame.size.height = height;
        frame;
    });
    
    self.label3.frame = ({
        CGRect frame = self.label3.frame;
        frame.origin.x = width / 4.0 * 2;
        frame.origin.y = 0;
        frame.size.width = width / 4.0;
        frame.size.height = height;
        frame;
    });
    
    self.label4.frame = ({
        CGRect frame = self.label4.frame;
        frame.origin.x = width / 4.0 * 3;
        frame.origin.y = 0;
        frame.size.width = width / 4.0;
        frame.size.height = height;
        frame;
    });
    
    self.separator.frame = ({
        CGRect frame = self.separator.frame;
        frame.origin.x = 0;
        frame.size.width = width;
        frame.size.height = 1.0 / [UIScreen mainScreen].scale;
        frame.origin.y = height - frame.size.height;
        frame;
    });
}
@end

@interface GSE_RebateHistoryInfoCell ()

@end

@implementation GSE_RebateHistoryInfoCell

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
    [super setupSubviews];
    self.selectedBackgroundView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xdbdbdb);
        view;
    });
    self.label1.font = [UIFont systemFontOfSize:13];
    self.label2.font = [UIFont systemFontOfSize:13];
    self.label3.font = [UIFont systemFontOfSize:13];
    self.label4.font = [UIFont systemFontOfSize:13];
    self.label1.textColor = UIColorFromRGB(0x4775f4);
    self.label2.textColor = UIColorFromRGB(0x333333);
    self.label3.textColor = UIColorFromRGB(0x333333);
    self.label4.textColor = UIColorFromRGB(0x333333);
    
    self.label1.textAlignment = NSTextAlignmentLeft;
    //self.label4.textAlignment = NSTextAlignmentRight;
    self.label1.lineBreakMode = NSLineBreakByTruncatingMiddle;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    
    self.label1.frame = ({
        CGRect frame = self.label1.frame;
        frame.origin.x = 20;
        frame.origin.y = 0;
        frame.size.width = width / 4.0 - 20;
        frame;
    });
    self.label4.frame = ({
        CGRect frame = self.label4.frame;
        frame.origin.x = CGRectGetMaxX(self.label3.frame) + 10;
        frame.size.width = width / 4.0 - 30;
        frame;
    });
    
}

- (void)setTxhash:(NSString *)txhash{
    _txhash = [txhash copy];
    [self.label1 setText:NSLocalizedString(_txhash, nil)];
}

- (void)setDate:(NSString *)date{
    _date = [date copy];
    [self.label2 setText:_date];
}

- (void)setSource:(NSString *)source{
    _source = [source copy];
    [self.label3 setText: NSLocalizedString(_source, nil)];
    
    if ([_source isEqualToString:@"Rebate"]) {
        self.label4.textColor = UIColorFromRGB(0x68b547);
    }else if ([_source isEqualToString:@"Withdraw"]){
        self.label4.textColor = UIColorFromRGB(0xd74b44);
    }else{
        self.label4.textColor = UIColorFromRGB(0x333333);
    }
}

- (void)setGse:(NSString *)gse{
    _gse = [gse copy];
    
    {
        if ([_source isEqualToString:@"Rebate"]) {
            [self.label4 setText: [NSString stringWithFormat:@"+%@",_gse]];
        }else if ([_source isEqualToString:@"Withdraw"]){
            [self.label4 setText: [NSString stringWithFormat:@"-%@",_gse]];
        }else{
            [self.label4 setText: _gse];
        }
    }
}
@end
