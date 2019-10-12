//
//  GSE_MenuReferral.m
//  GSEWallet
//
//  Created by user on 05/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_MenuReferral.h"

@interface GSE_MenuReferral () <UITextFieldDelegate>
@property (nonatomic, strong) UIView *background_mask;
@property (nonatomic, strong) UIView *background_menu;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *close_btn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIButton *continue_btn;

@end

@implementation GSE_MenuReferral

- (instancetype)init
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.background_mask = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.3;
            view;
        });
        [self addSubview:self.background_mask];
        
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction:)];
            [self.background_mask addGestureRecognizer:tap];
        }
        
        CGRect frame = rect;
        
        UIImage *image = [UIImage imageNamed:@"blue_back"];
        
        CGFloat ratio =  self.bounds.size.width / image.size.width;
        
        frame.origin.y = 84 * ratio / 5.0 * 4;
        frame.size.height -= frame.origin.y;
        
        self.background_menu = ({
            UIView *view = [[UIView alloc] initWithFrame:frame];
            //view.backgroundColor = UIColorFromRGB(0xf9f9f9);
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 5;
            view;
        });
        [self addSubview:self.background_menu];
        
        self.close_btn = ({
            CGRect rect = CGRectMake(0, 0, 44, 44);
            UIButton *button = [[UIButton alloc] initWithFrame:rect];
            UIImage *image = [UIImage imageNamed:@"menu_wallet_close"];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateHighlighted];
            //[button sizeToFit];
            button.center = CGPointMake(self.bounds.size.width / 2.0 , 20);
            [button addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self.background_menu addSubview:self.close_btn];
        
        self.titleLabel = ({
            CGRect rect = CGRectMake(0, 0, self.bounds.size.width - 50, 0);
            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            label.textColor = UIColorFromRGB(0x666666);
            label.text = NSLocalizedString(@"Have a referral code?", nil);
            label.font = [UIFont systemFontOfSize:52 / 2.0];
            [label setText:label.text lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            [label setCenter:CGPointMake(25 + label.bounds.size.width / 2.0, 90)];
            label;
        });
        
        [self.background_menu addSubview:self.titleLabel];

        self.detailLabel = ({
            CGRect rect = CGRectMake(0, 0, self.bounds.size.width - 50, 0);
            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            label.font = [UIFont systemFontOfSize:30 / 2.0];
            label.textColor = UIColorFromRGB(0x666666);
            label.numberOfLines = 0;
            label.text = NSLocalizedString(@"Enter it below to enjoy more free transfer\nand gas rebate!", nil);
            [label setText:label.text lineSpacing:8 wordSpacing:0.5];
            [label sizeToFit];
            [label setCenter:CGPointMake( 25 + label.bounds.size.width / 2.0 , 312 / 2.0)];
            label;
        });
        
        [self.background_menu addSubview:self.detailLabel];
        
        
        self.separator = ({
            CGRect frame = CGRectMake(25, 0, self.bounds.size.width - 50, 1.0 / [UIScreen mainScreen].scale);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = UIColorFromRGB(0xdedede);
            view.center = CGPointMake(self.bounds.size.width / 2.0, 456 / 2.0);
            view;
        });
        [self.background_menu addSubview:self.separator];
        
        self.textField = ({
            CGRect rect = CGRectMake(25, 0, self.bounds.size.width - 50, 30);
            UITextField *textField = [[UITextField alloc] initWithFrame:rect];
            textField.textColor = UIColorFromRGB(0x333333);
            textField.font = [UIFont systemFontOfSize:15];
            textField.returnKeyType = UIReturnKeyDone;
            textField.delegate = self;
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            //textField.backgroundColor = [UIColor yellowColor];
            textField.center = CGPointMake(self.separator.center.x, CGRectGetMinY(self.separator.frame) - CGRectGetHeight(textField.bounds) / 2.0);
            textField;
        });
        [self.background_menu addSubview:self.textField];
        
        self.referalTipLabel = ({
            CGRect rect = CGRectMake(25, 0, self.bounds.size.width - 50, 0);
            UILabel *label = [[UILabel alloc] initWithFrame:rect];
            label.font = [UIFont systemFontOfSize:11];
            label.textColor = UIColorFromRGB(0xe83c3c);
            label.numberOfLines = 0;
            label.text = NSLocalizedString(@"Invalid Referral Code", nil);
            [label sizeToFit];
            label.center = CGPointMake( 25 + label.bounds.size.width / 2.0, CGRectGetMaxY(self.separator.frame) + label.bounds.size.height / 2.0 + 15);
            label;
        });
        self.referalTipLabel.hidden = YES;
        [self.background_menu addSubview:self.referalTipLabel];
        
        self.continue_btn = ({
            CGFloat origin = 0;
            //NSLog(@"%@",NSStringFromCGRect(rect));
            CGRect rect = CGRectMake(MARGIN_2, origin, self.bounds.size.width - 90, 50);
            UIButton *button = [[UIButton alloc] initWithFrame:rect];
            [button.layer setCornerRadius:25];
            [button.layer setMasksToBounds:NO];
            [button setClipsToBounds:YES];
            [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
            [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle: NSLocalizedString( @"Unlock Free Transfer" , nil) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
            button.center = CGPointMake(self.bounds.size.width / 2.0, self.separator.center.y + 230 / 2.0);
            button;
        });
        [self.background_menu addSubview:self.continue_btn];
    }
    return self;
}

#pragma mark - delegate

- (void)nextAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(nextAction:)]) {
        [self.delegate nextAction:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self nextAction:textField];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (!self.referalTipLabel.hidden) {
        self.referalTipLabel.hidden = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (!self.referalTipLabel.hidden) {
        self.referalTipLabel.hidden = YES;
    }
    return YES;
}

#pragma mark - action

- (void)toggle:(void(^)(void))finish{
    if (self.background_menu.frame.origin.y ==
        [UIScreen mainScreen].bounds.size.height) {
        [self open:finish];
    }else{
        [self close:finish];
    }
}

- (void)open:(void(^)(void))finish{
    self.hidden = NO;
    self.background_mask.hidden = NO;
    
    [self.textField becomeFirstResponder];
    
    UIImage *image = [UIImage imageNamed:@"blue_back"];
    
    CGFloat ratio =  self.bounds.size.width / image.size.width;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.background_menu.frame;
        frame.origin.y = 84 * ratio / 5.0 * 4;
        self.background_menu.frame = frame;
        self.background_mask.alpha = 0.3;
        self.viewIsAnimating = YES;
    } completion:^(BOOL finished) {
        self.viewIsAnimating = NO;
        if (finish) {
            finish();
        }
    }];
}

- (void)open{
    [self open:nil];
}

- (void)close{
    
    self.background_mask.alpha = 0;
    self.background_mask.hidden = YES;
    self.hidden = YES;
    
    CGRect frame = self.background_menu.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.background_menu.frame = frame;
    
    [self.textField resignFirstResponder];
}

- (void)close:(void(^)(void))finish{
    
    //[GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.background_menu.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.background_menu.frame = frame;
        self.background_mask.alpha = 0;
        self.viewIsAnimating = YES;
    } completion:^(BOOL finished) {
        self.background_mask.hidden = YES;
        self.hidden = YES;
        self.viewIsAnimating = NO;
        
        if(finish){
            finish();
        }
    }];
}

- (void)closeAction:(UITapGestureRecognizer *)tap{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textField resignFirstResponder];
    });
    [self close:^{
        if ([self.delegate respondsToSelector:@selector(closeAction:)]) {
            [self.delegate closeAction:tap];
        }
    }];
}

@end
