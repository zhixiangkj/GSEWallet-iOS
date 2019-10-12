//
//  GSE_TransferCell.m
//  wallet
//
//  Created by user on 30/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_TransferCell.h"

@interface GSE_TransferCell ()
@property (nonatomic, strong) UIView *separator;
@end

@implementation GSE_TransferCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separator = ({
            CGRect rect = CGRectMake(0, 0, 0, 0.5);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.backgroundColor = UIColorFromRGB(0xeaeaea);
            view;
        });
        [self addSubview:self.separator];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.separator.frame = CGRectMake(MARGIN, self.bounds.size.height - 0.5, self.bounds.size.width - MARGIN * 2, 0.5);
}

- (void)setShowSeparator:(BOOL)showSeparator{
    _showSeparator = showSeparator;
    
    self.separator.hidden = !showSeparator;
}

@end

@interface GSE_TransferTextFieldCell ()
@property (nonatomic, strong) UIView *separator;
@end

@implementation GSE_TransferTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = 158 / 2.0 - 104 / 2.0;
        self.textField = ({
            CGRect rect = CGRectMake(MARGIN, 5, width - MARGIN * 2, height);
            UITextField *textField = [[UITextField alloc] initWithFrame:rect];
            textField.font = [UIFont systemFontOfSize:15];
            textField.textColor = UIColorFromRGB(0x333333);
            textField.returnKeyType = UIReturnKeyNext;
            textField;
        });
        [self addSubview:self.textField];
        
        self.separator = ({
            CGRect rect = CGRectMake(0, 0, 0, 0.5);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.backgroundColor = UIColorFromRGB(0xeaeaea);
            view;
        });
        [self addSubview:self.separator];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.textField.frame;
    frame.origin.y = self.bounds.size.height - frame.size.height - 10;
    self.textField.frame = frame;
    //self.textField.backgroundColor = [UIColor yellowColor];
    self.separator.frame = CGRectMake(MARGIN, self.bounds.size.height - 0.5, self.bounds.size.width - MARGIN * 2, 0.5);
}

@end

@interface GSE_TransferTextFieldQRCell ()
@property (nonatomic, strong) UIView *separator;
@end

@implementation GSE_TransferTextFieldQRCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = 158 / 2.0 - 104 / 2.0;
        self.balanceLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0xdbdbdb);
            label.font = [UIFont systemFontOfSize:12];
            [label setText:@"Balance 0.0000" lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 15);
            label;
        });
        [self addSubview:self.balanceLabel];
        
        self.textField = ({
            CGRect rect = CGRectMake(MARGIN, 40, width - MARGIN * 2, height);
            UITextField *textField = [[UITextField alloc] initWithFrame:rect];
            textField.font = [UIFont systemFontOfSize:15];
            textField.textColor = UIColorFromRGB(0x333333);
            textField.rightViewMode = UITextFieldViewModeAlways;
            textField.rightView = ({
                CGRect rect = CGRectMake(0, 0, 30, 44);
                UIButton * button = [[UIButton alloc] initWithFrame:rect];
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                [button setImage:[UIImage imageNamed:@"qr_small"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(qrCodeAction:) forControlEvents:UIControlEventTouchUpInside];
                button;
            });
            textField.returnKeyType = UIReturnKeyNext;
            textField;
        });
        [self addSubview:self.textField];
        
        self.separator = ({
            CGRect rect = CGRectMake(0, 0, 0, 0.5);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.backgroundColor = UIColorFromRGB(0xeaeaea);
            view;
        });
        [self addSubview:self.separator];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect frame = self.textField.frame;
    frame.origin.y = self.bounds.size.height - frame.size.height - 8;
    self.textField.frame = frame;
    //self.textField.backgroundColor = [UIColor yellowColor];
    self.separator.frame = CGRectMake(MARGIN, self.bounds.size.height - 0.5, self.bounds.size.width - MARGIN * 2, 0.5);
}

- (void)qrCodeAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(qrCodeAction:)]) {
        [self.delegate qrCodeAction:sender];
    }
}

- (void)setBalance:(NSString *)balance{
    
    _balance = balance;
    UILabel *label = self.balanceLabel;
    
    [label setText:[NSString stringWithFormat:NSLocalizedString(@"Balance %@",nil),balance] lineSpacing:0 wordSpacing:1];
    [label sizeToFit];
    label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 15);
}

@end

@interface GSE_TransferSliderCell ()

@property (nonatomic, strong) UILabel  *value_label;
@property (nonatomic, strong) UIButton *slow_btn;
@property (nonatomic, strong) UIButton *fast_btn;
@end

@implementation GSE_TransferSliderCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;        
        CGFloat padding = -20;
        
        {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x666666);
            label.font = [UIFont systemFontOfSize:12];
            [label setText:NSLocalizedString(@"Current market price",nil) lineSpacing:5 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake(width / 2.0, label.bounds.size.height / 2.0); //
            [self addSubview:label];
        }
        
        self.gasSlider = ({
            CGRect rect = CGRectMake(MARGIN + 40, 0, width - (MARGIN + 40) * 2, 44);
            UISlider * slider = [[UISlider alloc] initWithFrame:rect];
            slider.center = CGPointMake(width / 2.0, 65 + padding );
            slider.minimumTrackTintColor = UIColorFromRGB(0x4480db); //UIColorFromRGB(0x7dc6ff);
            slider.maximumTrackTintColor = UIColorFromRGB(0xbdbdbd);
            [slider setThumbImage:[UIImage imageNamed:@"gas_slider"] forState:UIControlStateNormal];
            [slider addTarget:self action:@selector(sliderDidChangeAction:) forControlEvents:UIControlEventValueChanged];
            slider.maximumValue = 100;
            slider.minimumValue = 0;
            slider.value = 50;
            slider;
        });
        [self addSubview:self.gasSlider];
        
        self.slow_btn = ({
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[UIImage imageNamed:@"gas_baby"] forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"Slow",nil) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:9]];
            [button sizeToFit];[button centerVertically];
            [button setCenter:CGPointMake(MARGIN + 15, self.gasSlider.center.y + 13 )];
            button;
        });
        
        [self addSubview:self.slow_btn];
        
        self.fast_btn = ({
            UIButton *button = [[UIButton alloc] init];
            [button setImage:[UIImage imageNamed:@"gas_rocket"] forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"Fast",nil) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:9]];
            [button sizeToFit];[button centerVertically];
            [button setCenter:CGPointMake(width - MARGIN  - 15, self.gasSlider.center.y + 15)];
            button;
        });
        
        [self addSubview:self.fast_btn];
        
        self.value_label = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x999999);
            label.font = [UIFont systemFontOfSize:15];
            [label setText:NSLocalizedString(@"loading...",nil) lineSpacing:5 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake(width / 2.0, self.gasSlider.center.y + 34);
            label;
        });
        [self addSubview:self.value_label];
    }
    self.hidden = YES;
    self.alpha = 0;
    return self;
}

- (void)sliderDidChangeAction:(UISlider *)slider{
    
    NSString *text = [NSString stringWithFormat:@"%.2f Gwei", slider.value];
    
    UILabel *label = self.value_label;
    [label setText:text lineSpacing:5 wordSpacing:1];
    [label sizeToFit];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    label.center = CGPointMake(width / 2.0, self.gasSlider.center.y + 34);
    
    if ([self.delegate respondsToSelector:@selector(sliderDidChangeAction:)]) {
        [self.delegate sliderDidChangeAction:slider  ];
    }
}

- (void)setEtherchainData:(NSDictionary *)dic{
    
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    self.hidden = NO;
    NSString *safeLow = dic[@"safeLow"];
    NSString *fastest = dic[@"fastest"];
    NSString *fast = dic[@"standard"];
    
    [self.gasSlider setMinimumValue:safeLow.floatValue];
    [self.gasSlider setMaximumValue:fastest.floatValue];
    [self.gasSlider setValue:fast.floatValue];
    [self sliderDidChangeAction:self.gasSlider];
    
    if (self.alpha == 0) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}
@end

@interface GSE_TransferGasCell ()

@end

@implementation GSE_TransferGasCell

- (void)rebateAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(rebateAction:)]) {
        [self.delegate rebateAction:self];
    }
}

@end
