//
//  GSE_TxnDetailCell.m
//  wallet
//
//  Created by user on 30/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_TxnDetailCell.h"

@interface GSE_TxnDetailCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@end

@implementation GSE_TxnDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x999999);
            label.font = [UIFont systemFontOfSize:12];
            label.text = @"title";
            [label sizeToFit];
            label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 20 + label.bounds.size.height / 2.0);
            label;
        });
        [self addSubview:self.titleLabel];
        
        self.valueLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont systemFontOfSize:15];
            label.text = @"value";
            label.lineBreakMode = NSLineBreakByTruncatingMiddle;
            [label sizeToFit];
            label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 40 + label.bounds.size.height / 2.0);
            label;
        });
        
        [self addSubview:self.valueLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    UILabel *label = self.titleLabel;
    label.text = title;
    [label sizeToFit];
    label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 20 + label.bounds.size.height / 2.0);
}

- (void)setValue:(NSString *)value{
    _value = value;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *label = self.valueLabel;
    [label setText:value lineSpacing:10 wordSpacing:1];
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.size.width = width - MARGIN * 2;
    label.frame = frame;
    label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 40 + label.bounds.size.height / 2.0);
}

- (void)setLargeBlue:(BOOL)largeBlue{
    
    _largeBlue = largeBlue;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *label = self.valueLabel;
    if (largeBlue) {
        label.font = [UIFont systemFontOfSize:30];
        
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        
        label.textColor = self.txn_out ? UIColorFromRGB(0xe83c3c) : UIColorFromRGB(0x47b930);
        
        if (self.value.doubleValue == 0) {
            label.textColor = GSE_Blue;
        }
        
    }else{
        label.font = [UIFont systemFontOfSize:15];
        
        if ([self.title isEqualToString:NSLocalizedString(@"TxHash",nil)]) {
            label.textColor = GSE_Blue;
        }else{
            label.textColor = UIColorFromRGB(0x333333);
        }
    }
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.size.width = width - MARGIN * 2;
    label.frame = frame;
    label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 40 + label.bounds.size.height / 2.0);
}

@end


@interface GSE_TxnDetailAmountCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@end

@implementation GSE_TxnDetailAmountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        self.titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont boldSystemFontOfSize:15];
            label.text = @"title";
            [label sizeToFit];
            label.center = CGPointMake( width / 2.0, 40 + label.bounds.size.height / 2.0); //MARGIN + label.bounds.size.width / 2.0
            label;
        });
        [self addSubview:self.titleLabel];
        
        self.valueLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont systemFontOfSize:36];
            label.text = @"value";
            label.lineBreakMode = NSLineBreakByTruncatingMiddle;
            [label sizeToFit];
            label.center = CGPointMake(width / 2.0, 70 + label.bounds.size.height / 2.0);
            label;
        });
        
        [self addSubview:self.valueLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UILabel *label = self.titleLabel;
    //label.textAlignment = NSTextAlignmentCenter;
    [label setText:title lineSpacing:0 wordSpacing:1];
    [label sizeToFit];
    
    CGRect frame = label.frame;
    frame.size.width = width - MARGIN * 2;
    label.frame = frame;
    
    label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 40 + label.bounds.size.height / 2.0);
}

- (void)setValue:(NSString *)value{
    _value = value;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;    
    UILabel *label = self.valueLabel;
    //label.textAlignment = NSTextAlignmentCenter;
    if (value.doubleValue == 0) {
        value = @"0";
    }
    [label setText:value lineSpacing:0 wordSpacing:1];
    [label sizeToFit];
    
    CGRect frame = label.frame;
    frame.size.width = width - MARGIN * 2;
    label.frame = frame;
    
    label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 70 + label.bounds.size.height / 2.0);
}

- (void)setTxn_out:(BOOL)txn_out{
    _txn_out = txn_out;
    
    UILabel *label = self.valueLabel;
    label.textColor = txn_out ? UIColorFromRGB(0xe83c3c) : UIColorFromRGB(0x47b930);
    
    if (self.value.doubleValue == 0) {
        label.textColor = GSE_Blue;
    }
}

@end
