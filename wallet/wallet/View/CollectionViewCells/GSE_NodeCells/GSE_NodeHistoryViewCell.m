//
//  GSE_NodeHistoryViewCell.m
//  GSEWallet
//
//  Created by user on 09/01/2019.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

#import "GSE_NodeHistoryViewCell.h"

@interface GSE_NodeHistoryMenuCell ()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UIView *separator;
@end

@implementation GSE_NodeHistoryMenuCell
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
        label.text = NSLocalizedString(@"委托权益", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.label1];
    
    self.label2 = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor= UIColorFromRGB(0x666666);
        label.text = NSLocalizedString(@"收益", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.label2];
    
    self.label3 = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor= UIColorFromRGB(0x666666);
        label.text = NSLocalizedString(@"发放日期", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    [self.contentView addSubview:self.label3];
    
    self.label4 = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor= UIColorFromRGB(0x666666);
        label.text = @"状态";
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

@implementation GSE_NodeHistoryInfoCell

@end
