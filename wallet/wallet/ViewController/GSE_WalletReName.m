//
//  GSE_WalletReName.m
//  GSEWallet
//
//  Created by user on 30/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletReName.h"

@interface GSE_WalletReName () <UITextFieldDelegate>
@property (nonatomic, strong) UIButton *continue_btn;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation GSE_WalletReName

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Rename Wallet",nil);
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;    
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:13];
        [label setText:NSLocalizedString(@"Current Wallet Name",nil) lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 136 / 2.0);
        [self.contentView addSubview:label];
    }
    
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:24];
        NSString *current = self.wallet;
        [label setText:current lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        if (label.bounds.size.width > width - MARGIN * 2) {
            CGRect frame = label.frame;
            frame.size.width = width - MARGIN * 2;
            label.frame = frame;
        }
        label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 216 / 2.0);
        [self.contentView addSubview:label];
    }
    
    {
        CGRect rect = CGRectMake(MARGIN, 270 / 2.0, width - MARGIN * 2, 0.5f);
        UIView *separator = [[UIView alloc] initWithFrame:rect];
        separator.backgroundColor = UIColorFromRGB(0xdedede);
        [self.contentView addSubview:separator];
    }
    
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:13];
        [label setText:NSLocalizedString(@"Enter New Name",nil) lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 365 / 2.0);
        [self.contentView addSubview:label];
    }
    
    {
        CGRect rect = CGRectMake(MARGIN, 270 / 2.0, width - MARGIN * 2, 0.5f);
        UIView *separator = [[UIView alloc] initWithFrame:rect];
        separator.backgroundColor = UIColorFromRGB(0xdedede);
        [self.contentView addSubview:separator];
    }
    
    {
        CGRect rect = CGRectMake(MARGIN, 500 / 2.0, width - MARGIN * 2, 0.5f);
        UIView *separator = [[UIView alloc] initWithFrame:rect];
        separator.backgroundColor = UIColorFromRGB(0xdedede);
        [self.contentView addSubview:separator];
    }
    
    self.textField  = ({
        CGRect rect = CGRectMake(MARGIN, 200, width - MARGIN * 2, 40);
        UITextField *textField = [[UITextField alloc] initWithFrame:rect];
        textField.textColor = UIColorFromRGB(0x333333);
        textField.font = [UIFont systemFontOfSize:24];
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        //[textField setPlaceholder:@"Input new wallet name" color:UIColorFromRGB(0x999999) wordSpacing:1];
        textField;
    });
    [self.contentView addSubview:self.textField];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.15);

    self.continue_btn = ({
        CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 - 50 : height - 104 * ratio - 36 - 50;
        CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button.layer setCornerRadius:25];
        [button.layer setMasksToBounds:NO];
        [button setClipsToBounds:YES];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: NSLocalizedString(@"Continue",nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.continue_btn];
    
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.contentView addGestureRecognizer:tap];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    [self.textField becomeFirstResponder];
}

#pragma mark - delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.continue_btn.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length) {
        self.continue_btn.enabled = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    //[textField resignFirstResponder];
    [self nextAction:nil];
    return NO;
}

#pragma mark - action

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.textField resignFirstResponder];
}

- (void)nextAction:(id)sender{
    NSString *name = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (!name.length) {
        [self alertTitle:@"New Name Needed" withMessage:@"Wallet name cannot be empty, please try again" buttonTitle:@"OK" finish:^{
            [self.textField becomeFirstResponder];
        }];
        return;
    }
    NSString *current = self.wallet;
    if ([name isEqualToString:current]) {
        [self alertTitle:@"New Name Error" withMessage:@"Wallet name cannot be the same as the old name, please try again" buttonTitle:@"OK" finish:^{
            [self.textField becomeFirstResponder];
        }];
        return;
    }
    
    if (![[GSE_Wallet shared] renameWallet:self.wallet withName:name]) {
        [self alertTitle:NSLocalizedString(@"Wallet name already exists",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    if (self.finish) {
        self.finish();
    }
    
    MBProgressHUD *hud = [self finishing:NSLocalizedString(@"Renamed",nil)];
    
    self.continue_btn.hidden = YES;
    
    [self.textField resignFirstResponder];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
    });
}



#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
