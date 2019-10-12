//
//  GSE_TxnsCell.m
//  wallet
//
//  Created by user on 29/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_TxnsCell.h"

@interface GSE_TxnsCell ()
@property (nonatomic, strong) UILabel *label_from;
@property (nonatomic, strong) UILabel *label_to;
@property (nonatomic, strong) UILabel *label_timestamp;
@property (nonatomic, strong) UILabel *label_address;
@property (nonatomic, strong) UILabel *label_value;
@property (nonatomic, strong) UILabel *label_status;
@end

@implementation GSE_TxnsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
       
        self.label_from = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = UIColorFromRGB(0x333333);
            [label setText:NSLocalizedString(@"From ",nil) lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake( MARGIN + label.bounds.size.width / 2.0 , 32);
            label;
        });
        [self addSubview:self.label_from];
        
        self.label_to = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = UIColorFromRGB(0x333333);
            [label setText:NSLocalizedString(@"To ",nil) lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake( MARGIN + label.bounds.size.width / 2.0 , 32);
            label.hidden = YES;
            label;
        });
        [self addSubview:self.label_to];
        
        self.label_timestamp = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = UIColorFromRGB(0x999999);
            [label setText:NSLocalizedString(@"Timestamp",nil) lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake( MARGIN + label.bounds.size.width / 2.0 , 53);
            label;
        });
        [self addSubview:self.label_timestamp];
        
        self.label_address = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = UIColorFromRGB(0x333333);
            label.lineBreakMode = NSLineBreakByTruncatingMiddle;
            [label setText:@"Address" lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            CGRect frame = label.frame;
            frame.size.width = 150;
            label.frame = frame;
            label.center = CGPointMake(width / 2.0 - 20, self.label_from.center.y);
            label;
        });
        [self addSubview:self.label_address];
        
        self.label_value = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:18];
            label.textColor = GSE_Blue;
            [label setText:@"Value" lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake(width - MARGIN - label.bounds.size.width / 2.0, self.label_from.center.y);
            label;
        });
        [self addSubview:self.label_value];
        
        self.label_status = ({
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = UIColorFromRGB(0x999999);
            [label setText:@"Status" lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake(width - MARGIN - label.bounds.size.width / 2.0, self.label_timestamp.center.y);
            label;
        });
        [self addSubview:self.label_status];
    }
    return self;
}

- (void)setTxn_out:(BOOL)txn_out{
    _txn_out = txn_out;
    self.label_from.hidden = txn_out;
    self.label_to.hidden = !txn_out;
    
    if (txn_out) {
        self.label_value.textColor = UIColorFromRGB(0xe83c3c);
    }else{
        self.label_value.textColor = UIColorFromRGB(0x47b930);
    }
    if (![self.status isEqualToString: NSLocalizedString(@"Success", nil) ]) {
        self.label_value.textColor = self.label_status.textColor;
    }
}

- (void)setAddress:(NSString *)address{
    _address = address;
    
    [self.label_address setText:address lineSpacing:0 wordSpacing:1];
    //[self.label_address sizeToFit];
    //CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //self.label_address.center = CGPointMake(width / 2.0, self.label_from.center.y);
}

- (void)setValue:(NSString *)value{
    _value = value;
    if (value.doubleValue == 0) {
        value = @"0";
        self.label_value.textColor = GSE_Blue;
    }
    [self.label_value setText:value lineSpacing:0 wordSpacing:1];
    [self.label_value sizeToFit];
    if (self.label_value.frame.size.width > 100) {
        CGRect frame = self.label_value.frame;
        frame.size.width = 100;
        self.label_value.frame = frame;
    }
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.label_value.center = CGPointMake(width - MARGIN - self.label_value.bounds.size.width / 2.0, self.label_value.center.y);
}

- (void)setTimestamp:(NSString *)timestamp{
    _timestamp = timestamp;
    
    [self.label_timestamp setText:timestamp lineSpacing:0 wordSpacing:1];
    [self.label_timestamp sizeToFit];
    
    self.label_timestamp.center = CGPointMake(MARGIN + self.label_timestamp.bounds.size.width / 2.0, self.label_timestamp.center.y);
}

- (void)setStatus:(NSString *)status{
    _status = status;
    
    [self.label_status setText:status lineSpacing:0 wordSpacing:1];
    [self.label_status sizeToFit];

    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.label_status.center = CGPointMake(width - MARGIN - self.label_status.bounds.size.width / 2.0, self.label_status.center.y);
}

@end
