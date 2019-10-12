//
//  GSE_WalletImporter.m
//  wallet
//
//  Created by user on 25/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletImporter.h"
#import "GSE_WalletCreator.h"
#import "GSE_WalletWebBrowser.h"

@interface GSE_WalletImporter () <UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIButton * viaMnemonic;
@property (nonatomic, strong) UIButton * viaPrivateKey;
@property (nonatomic, strong) UIButton * viaKeystore;

@property (nonatomic, strong) UIView   * viaSlider;
@property (nonatomic, strong) UIScrollView * viaScrollView;

@property (nonatomic, strong) UITextView * viaMnemonicTextView;
@property (nonatomic, strong) UITextView * viaPrivateKeyTextView;
@property (nonatomic, strong) UITextView * viaKeystoreTextView;
@property (nonatomic, strong) UITextField * viaKeystorePassword;

@property (nonatomic, strong) UIButton *continue_btn_1;
@property (nonatomic, strong) UIButton *continue_btn_2;
@property (nonatomic, strong) UIButton *continue_btn_3;

@property (nonatomic, strong) UIButton *privacy_policy_1;
@property (nonatomic, strong) UIButton *privacy_policy_2;
@property (nonatomic, strong) UIButton *privacy_policy_3;

@end

@implementation GSE_WalletImporter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Import Wallet" , nil );
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    [self setBackItem];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    //CGFloat height = self.contentView.bounds.size.height;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.6);
    
    self.viaMnemonic = ({
        CGRect rect  = CGRectMake(0, 0, width / 3.0, 44);
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button setTitle:NSLocalizedString(@"via Mnemonic",nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button addTarget:self action:@selector(viaMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:0];
        button;
    });
    [self.contentView addSubview:self.viaMnemonic];
    
    self.viaPrivateKey = ({
        CGRect rect  = CGRectMake( width / 3.0 , 0, width / 3.0, 44);
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button setTitle:NSLocalizedString(@"via Private Key",nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button addTarget:self action:@selector(viaMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:1];
        button;
    });
    [self.contentView addSubview:self.viaPrivateKey];
    
    self.viaKeystore = ({
        CGRect rect  = CGRectMake( width / 3.0 * 2.0 , 0, width / 3.0, 44);
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button setTitle:NSLocalizedString(@"via Keystore",nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button addTarget:self action:@selector(viaMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:2];
        button;
    });
    [self.contentView addSubview:self.viaKeystore];
    
    self.viaSlider = ({
        CGFloat origin = self.viaMnemonic.frame.origin.y + self.viaMnemonic.frame.size.height;
        CGRect rect = CGRectMake(0, origin, width / 3.0, 1.0);
        UIView * view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = GSE_Blue;
        view;
    });
    [self.contentView addSubview:_viaSlider];
    
    self.viaScrollView = ({
        CGRect rect = CGRectMake(0, 45 * ratio, width, self.contentView.bounds.size.height - 45);
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
        [scrollView setContentSize:CGSizeMake(width * 3, rect.size.height)];
        [scrollView setPagingEnabled:YES];
        CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
        CGFloat padding = -50;
        
        {
            CGRect rect = CGRectMake(0, 0, width, height);
            UIView * view = [[UIView alloc] initWithFrame:rect];
            //view.backgroundColor = [UIColor yellowColor];
            [scrollView addSubview:view];
            
            /*{
                CGRect rect = CGRectMake(MARGIN, 20, width - MARGIN * 2, 40);
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.text = @"m/44'/60'/0'/0/0";
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = UIColorFromRGB(0xbdbdbd);
                [view addSubview:label];
            }
            {
                CGRect rect = CGRectMake(MARGIN, 55, width - MARGIN * 2, 1);
                UIView *separator = [[UIView alloc] initWithFrame:rect];
                separator.backgroundColor = UIColorFromRGB(0xeaeaea);
                [view addSubview:separator];
            }*/
            
            {
                CGRect rect = CGRectMake(MARGIN, 86 + padding, width - MARGIN * 2, 150 * ratio);
                UIView *background = [[UIView alloc] initWithFrame:rect];
                background.backgroundColor = UIColorFromRGB(0xf4f4f4);
                background.layer.cornerRadius = 5;
                background.layer.masksToBounds = YES;
                [view addSubview:background];
            }
            
            self.viaMnemonicTextView = ({
                CGRect rect = CGRectMake(MARGIN + 2, 90 + padding, width - MARGIN * 2 - 4, 140 * ratio);
                UITextView *textView = [[UITextView alloc] initWithFrame:rect];
                textView.backgroundColor = [UIColor clearColor];
                textView.font = [UIFont systemFontOfSize:15];
                [textView addPlaceHolder:NSLocalizedString(ratio == 1 ? @"Please input your mnemonic phrase" : @"Please input your mnemonic",nil)];
                textView.returnKeyType = UIReturnKeyDone;
                textView.delegate = self;
                textView;
            });
            [view addSubview:self.viaMnemonicTextView];
            
            self.privacy_policy_1 = ({
                CGFloat origin = self.viaMnemonicTextView.frame.origin.y + self.viaMnemonicTextView.frame.size.height;
                UIButton *button = [[UIButton alloc] init];
                UIImage *policy_unchecked = [UIImage imageNamed:@"policy_unchecked"];
                UIImage *policy_checked = [UIImage imageNamed:@"policy_checked"];
                [button setImage:policy_unchecked forState:UIControlStateNormal];
                [button setImage:policy_checked forState:UIControlStateSelected];
                [button setTitle:NSLocalizedString(ratio == 1 ? @"I have read and agree to " : @"Agree to ",nil) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
                [button setTitleColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateSelected];
                [button setAdjustsImageWhenHighlighted:NO];
                [button sizeToFit];
                [button alignImageToLeftWithGap:10];
                [button addTarget:self action:@selector(agreeToPolicyAction:) forControlEvents:UIControlEventTouchUpInside];
                //button.selected = YES;
                button.center = CGPointMake( MARGIN + 2 + button.bounds.size.width / 2.0 , origin + button.bounds.size.height / 2.0 + 20 );
                button;
            });
            [view addSubview:self.privacy_policy_1];
            
            
            {
                UIButton *button = [[UIButton alloc] init];
                [button setTitle:NSLocalizedString(@"Terms & Privacy Policy",nil) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
                [button sizeToFit];
                [button addTarget:self action:@selector(showPolicyAction:) forControlEvents:UIControlEventTouchUpInside];
                button.center = CGPointMake( self.privacy_policy_1.frame.origin.x + self.privacy_policy_1.frame.size.width + button.bounds.size.width / 2.0, self.privacy_policy_1.center.y);
                [view addSubview:button];
            }
            
            self.continue_btn_1 = ({
                CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio  - 36 - 50 : height - 104 * ratio  - 36 - 50;
                CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
                //NSLog(@"%@",NSStringFromCGRect(rect));
                UIButton *button = [[UIButton alloc] initWithFrame:rect];
                [button.layer setCornerRadius:25];
                [button.layer setMasksToBounds:NO];
                [button setClipsToBounds:YES];
                [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
                [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
                [button addTarget:self action:@selector(viaMnemonicAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle: NSLocalizedString(@"Next",nil) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
                [button setEnabled:NO];
                button;
            });
            [view addSubview:self.continue_btn_1];
        }
        {
            CGRect rect = CGRectMake(width, 0, width, height);
            UIView * view = [[UIView alloc] initWithFrame:rect];
            //view.backgroundColor = [UIColor blueColor];
            [scrollView addSubview:view];
            
            /*{
                CGRect rect = CGRectMake(MARGIN, 20, width - MARGIN * 2, 40);
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.text = @"Input private key hex string below";
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = UIColorFromRGB(0xbdbdbd);
                [view addSubview:label];
            }
            {
                CGRect rect = CGRectMake(MARGIN, 55, width - MARGIN * 2, 1);
                UIView *separator = [[UIView alloc] initWithFrame:rect];
                separator.backgroundColor = UIColorFromRGB(0xeaeaea);
                [view addSubview:separator];
            }*/
            
            {
                CGRect rect = CGRectMake(MARGIN, 86  + padding, width - MARGIN * 2, 150* ratio);
                UIView *background = [[UIView alloc] initWithFrame:rect];
                background.backgroundColor = UIColorFromRGB(0xf4f4f4);
                background.layer.cornerRadius = 5;
                background.layer.masksToBounds = YES;
                [view addSubview:background];
            }
            
            self.viaPrivateKeyTextView = ({
                CGRect rect = CGRectMake(MARGIN + 2, 90  + padding , width - MARGIN * 2 - 4, 140* ratio);
                UITextView *textView = [[UITextView alloc] initWithFrame:rect];
                textView.backgroundColor = [UIColor clearColor];
                textView.font = [UIFont systemFontOfSize:15];
                [textView addPlaceHolder:NSLocalizedString(@"Please input your private key",nil)];
                textView.returnKeyType = UIReturnKeyDone;
                textView.delegate = self;
                textView;
            });
            [view addSubview:self.viaPrivateKeyTextView];
            
            self.privacy_policy_2 = ({
                CGFloat origin = self.viaPrivateKeyTextView.frame.origin.y + self.viaPrivateKeyTextView.frame.size.height;
                UIButton *button = [[UIButton alloc] init];
                UIImage *policy_unchecked = [UIImage imageNamed:@"policy_unchecked"];
                UIImage *policy_checked = [UIImage imageNamed:@"policy_checked"];
                [button setImage:policy_unchecked forState:UIControlStateNormal];
                [button setImage:policy_checked forState:UIControlStateSelected];
                [button setTitle: NSLocalizedString(ratio == 1 ? @"I have read and agree to " : @"Agree to ",nil) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
                [button setTitleColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateSelected];
                [button setAdjustsImageWhenHighlighted:NO];
                [button sizeToFit];
                [button alignImageToLeftWithGap:10];
                [button addTarget:self action:@selector(agreeToPolicyAction:) forControlEvents:UIControlEventTouchUpInside];
                //button.selected = YES;
                button.center = CGPointMake( MARGIN + 2 + button.bounds.size.width / 2.0 , origin + button.bounds.size.height / 2.0 + 20 );
                button;
            });
            [view addSubview:self.privacy_policy_2];
            
            {
                UIButton *button = [[UIButton alloc] init];
                [button setTitle:NSLocalizedString(@"Terms & Privacy Policy",nil) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
                [button sizeToFit];
                [button addTarget:self action:@selector(showPolicyAction:) forControlEvents:UIControlEventTouchUpInside];
                button.center = CGPointMake( self.privacy_policy_2.frame.origin.x + self.privacy_policy_2.frame.size.width + button.bounds.size.width / 2.0, self.privacy_policy_2.center.y);
                [view addSubview:button];
            }
            
            self.continue_btn_2 = ({
                CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 - 50 : height - 104 * ratio - 36 - 50;
                CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
                //NSLog(@"%@",NSStringFromCGRect(rect));
                UIButton *button = [[UIButton alloc] initWithFrame:rect];
                [button.layer setCornerRadius:25];
                [button.layer setMasksToBounds:NO];
                [button setClipsToBounds:YES];
                [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
                [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
                [button addTarget:self action:@selector(viaPrivateKeyAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle: NSLocalizedString(@"Next",nil) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
                [button setEnabled:NO];
                button;
            });
            [view addSubview:self.continue_btn_2];
        }
        {
            CGRect rect = CGRectMake(width * 2, 0, width, height);
            UIView * view = [[UIView alloc] initWithFrame:rect];
            //view.backgroundColor = [UIColor redColor];
            [scrollView addSubview:view];
            
            /*{
                CGRect rect = CGRectMake(MARGIN, 20, width - MARGIN * 2, 40);
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.text = @"Input keystore JSON string below";
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = UIColorFromRGB(0xbdbdbd);
                [view addSubview:label];
            }
            {
                CGRect rect = CGRectMake(MARGIN, 55, width - MARGIN * 2, 1);
                UIView *separator = [[UIView alloc] initWithFrame:rect];
                separator.backgroundColor = UIColorFromRGB(0xeaeaea);
                [view addSubview:separator];
            }*/
            
            {
                CGRect rect = CGRectMake(MARGIN, 86  + padding, width - MARGIN * 2, 150* ratio);
                UIView *background = [[UIView alloc] initWithFrame:rect];
                background.backgroundColor = UIColorFromRGB(0xf4f4f4);
                background.layer.cornerRadius = 5;
                background.layer.masksToBounds = YES;
                [view addSubview:background];
            }
            
            self.viaKeystoreTextView = ({
                CGRect rect = CGRectMake(MARGIN + 2, 90  + padding, width - MARGIN * 2 - 4, 140* ratio);
                UITextView *textView = [[UITextView alloc] initWithFrame:rect];
                textView.backgroundColor = [UIColor clearColor];
                textView.font = [UIFont systemFontOfSize:15];
                [textView addPlaceHolder:NSLocalizedString(@"Please input your keystore file",nil)];
                textView.returnKeyType = UIReturnKeyNext;
                textView.delegate = self;
                textView;
            });
            [view addSubview:self.viaKeystoreTextView];
            
            self.viaKeystorePassword = ({
                CGRect rect = CGRectMake(MARGIN + 8, 90 + padding + 140 * ratio + 10, width - MARGIN * 2 - 16, 40);
                UITextField *textField = [[UITextField alloc] initWithFrame:rect];
                textField.placeholder = NSLocalizedString(@"Keystore Password",nil);
                textField.font = [UIFont systemFontOfSize:15];
                textField.textColor = UIColorFromRGB(0x333333);
                textField.secureTextEntry = YES;
                textField.returnKeyType = UIReturnKeyDone;
                textField.delegate = self;
                textField;
            });
            [view addSubview:self.viaKeystorePassword];
            
            {
                CGFloat origin = self.viaKeystorePassword.frame.origin.y + self.viaKeystorePassword.frame.size.height;
                CGRect rect = CGRectMake(MARGIN + 2, origin , width - MARGIN * 2 - 4, 1);
                UIView *separator = [[UIView alloc] initWithFrame:rect];
                separator.backgroundColor = UIColorFromRGB(0xeaeaea);
                [view addSubview:separator];
            }
            
            self.privacy_policy_3 = ({
                CGFloat origin = self.viaKeystorePassword.frame.origin.y + self.viaKeystorePassword.frame.size.height;
                UIButton *button = [[UIButton alloc] init];
                UIImage *policy_unchecked = [UIImage imageNamed:@"policy_unchecked"];
                UIImage *policy_checked = [UIImage imageNamed:@"policy_checked"];
                [button setImage:policy_unchecked forState:UIControlStateNormal];
                [button setImage:policy_checked forState:UIControlStateSelected];
                [button setTitle:NSLocalizedString(ratio == 1 ? @"I have read and agree to " : @"Agree to ",nil) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
                [button setTitleColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateSelected];
                [button setAdjustsImageWhenHighlighted:NO];
                [button sizeToFit];
                [button alignImageToLeftWithGap:10];
                [button addTarget:self action:@selector(agreeToPolicyAction:) forControlEvents:UIControlEventTouchUpInside];
                //button.selected = YES;
                button.center = CGPointMake( MARGIN + 2 + button.bounds.size.width / 2.0, origin + button.bounds.size.height / 2.0 + 20);
                button;
            });
            [view addSubview:self.privacy_policy_3];
            
            {
                UIButton *button = [[UIButton alloc] init];
                [button setTitle:NSLocalizedString(@"Terms & Privacy Policy",nil) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
                [button sizeToFit];
                [button addTarget:self action:@selector(showPolicyAction:) forControlEvents:UIControlEventTouchUpInside];
                button.center = CGPointMake( self.privacy_policy_3.frame.origin.x + self.privacy_policy_3.frame.size.width + button.bounds.size.width / 2.0, self.privacy_policy_3.center.y);
                [view addSubview:button];
            }
            
            self.continue_btn_3 = ({
                CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 - 50 : height - 104 * ratio - 36 - 50;
                if (screenHeight < 568) {
                    origin += 50;
                }
                CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
                //NSLog(@"%@",NSStringFromCGRect(rect));
                UIButton *button = [[UIButton alloc] initWithFrame:rect];
                [button.layer setCornerRadius:25];
                [button.layer setMasksToBounds:NO];
                [button setClipsToBounds:YES];
                [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
                [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
                [button addTarget:self action:@selector(viaKeystoreAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle: NSLocalizedString(@"Next",nil) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
                [button setEnabled:NO];
                button;
            });
            [view addSubview:self.continue_btn_3];
        }
        [scrollView setScrollEnabled:NO];
        scrollView;
    });
    [self.contentView addSubview:self.viaScrollView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viaMnemonicTextView becomeFirstResponder];
    });
}

#pragma mark - delegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.continue_btn_1.enabled = NO;
    self.continue_btn_2.enabled = NO;
    self.continue_btn_3.enabled = NO;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.continue_btn_1.enabled = self.privacy_policy_1.selected;
    self.continue_btn_2.enabled = self.privacy_policy_2.selected;
    self.continue_btn_3.enabled = self.privacy_policy_3.selected;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        
        if (textView == self.viaKeystoreTextView) {
            [self.viaKeystorePassword becomeFirstResponder];
            return NO;
        }
        
        [textView resignFirstResponder];

        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.viaKeystorePassword) {
        [self.viaKeystorePassword resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.viaKeystorePassword) {
        self.continue_btn_3.enabled = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.viaKeystorePassword) {
        self.continue_btn_3.enabled = self.privacy_policy_3.selected;
    }
}

#pragma mark - action

- (void)agreeToPolicyAction:(UIButton *)sender{
    
    if (sender == self.privacy_policy_1) {
        self.privacy_policy_1.selected = !self.privacy_policy_1.selected;
        self.continue_btn_1.enabled =  self.privacy_policy_1.selected;
        
        if (self.privacy_policy_1.selected) {
            [self.viaMnemonicTextView resignFirstResponder];
        }else{
            [self.viaMnemonicTextView becomeFirstResponder];
        }
    }else if (sender == self.privacy_policy_2){
        self.privacy_policy_2.selected = !self.privacy_policy_2.selected;
        self.continue_btn_2.enabled = self.privacy_policy_2.selected;
        if (self.privacy_policy_2.selected) {
            [self.viaPrivateKeyTextView resignFirstResponder];
        }else{
            [self.viaPrivateKeyTextView becomeFirstResponder];
        }
    }else if (sender == self.privacy_policy_3){
        self.privacy_policy_3.selected = !self.privacy_policy_3.selected;
        self.continue_btn_3.enabled = self.privacy_policy_3.selected;
        if (self.privacy_policy_3.selected) {
            [self.viaKeystoreTextView resignFirstResponder];
            [self.viaKeystorePassword resignFirstResponder];
        }else{
            [self.viaKeystoreTextView becomeFirstResponder];
        }
    }
}

- (void)viaMnemonicAction:(UIButton *)sender{
    
    [self loading];
    
    Account * account = [Account accountWithMnemonicPhrase:self.viaMnemonicTextView.text];
    if (!account) {
        [self alertTitle:NSLocalizedString(@"Invalid Mnemonics",nil)
             withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
            
                 [self.viaMnemonicTextView becomeFirstResponder];
                 
        }];
        [self loadingFinish];
        return;
    }
    NSLog(@"%@",account.address);

    if ([[GSE_Wallet shared] getWalletNameForAddress:account.address].length) {
        [self loadingFinish];
        
        [self alertTitle:NSLocalizedString(@"Address already exists",nil) withMessage:NSLocalizedString(@"Please import another one",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        
        return;
    }
    
    GSE_WalletCreator *creator = [[GSE_WalletCreator alloc] init];
    creator.import = account;
    if (self.finish) {
        [creator setFinish:self.finish];
    }
    [self.navigationController pushViewController:creator animated:YES];
    
    [self loadingFinish];
}

- (void)viaPrivateKeyAction:(UIButton *)sender{
    [self loading];
    
    NSData *data = [self.viaPrivateKeyTextView.text hexStringToData];
    if (!data) {
        [self alertTitle:NSLocalizedString(@"Invalid Private Key",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
            [self.viaPrivateKeyTextView becomeFirstResponder];
        }];
        
        [self loadingFinish];
        return;
    }
    Account * account = [Account accountWithPrivateKey:data];
    if (!account) {
        [self alertTitle:NSLocalizedString(@"Invalid Private Key",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
            [self.viaPrivateKeyTextView becomeFirstResponder];
        }];
        
        [self loadingFinish];
        return;
    }
    NSLog(@"%@",account.address);

    if ([[GSE_Wallet shared] getWalletNameForAddress:account.address].length) {
        [self loadingFinish];
        
        [self alertTitle:NSLocalizedString(@"Address already exists",nil) withMessage:NSLocalizedString(@"Please import another one",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
            [self.viaPrivateKeyTextView becomeFirstResponder];
        }];
        
        return;
    }
    
    GSE_WalletCreator *creator = [[GSE_WalletCreator alloc] init];
    creator.import = account;
    if (self.finish) {
        [creator setFinish:self.finish];
    }
    [self.navigationController pushViewController:creator animated:YES];
    
    [self loadingFinish];
}

- (void)viaKeystoreAction:(UIButton *)sender{
    
    [self unlocking];
    __weak typeof(self) weakSelf = self;
    [Account decryptSecretStorageJSON:self.viaKeystoreTextView.text password:self.viaKeystorePassword.text callback:^(Account *account, NSError *error) {
        
        if (error) {
            NSLog(@"%@,%@",account,error);
            [weakSelf loadingFinish];
            
            NSString *errorMsg = error.userInfo[@"reason"]?:@"";
            
            [weakSelf alertTitle:NSLocalizedString(@"Invalid Keystore",nil) withMessage:errorMsg buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
                [weakSelf.viaKeystoreTextView becomeFirstResponder];
            }];
            return ;
        }
        
        NSLog(@"%@,%@,%@",account.address,account.mnemonicData,account.mnemonicPhrase);

        if ([[GSE_Wallet shared] getWalletNameForAddress:account.address].length) {
            
            [weakSelf loadingFinish];
            
            [weakSelf alertTitle:NSLocalizedString(@"Address already exists",nil) withMessage:NSLocalizedString(@"Please import another one",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
                [weakSelf.viaKeystoreTextView becomeFirstResponder];
            }];
            
            return;
        }
        
        GSE_WalletCreator *creator = [[GSE_WalletCreator alloc] init];
        creator.import = account;
        if (weakSelf.finish) {
            [creator setFinish:weakSelf.finish];
        }
        [weakSelf.navigationController pushViewController:creator animated:YES];
        
        [weakSelf loadingFinish];
    }];
}

- (void)viaMenuAction:(UIButton *)sender{
    
    CGFloat originX = sender.frame.origin.x;
    CGFloat width = self.view.bounds.size.width;
    
    [self.viaScrollView setContentOffset:CGPointMake( sender.tag * width, 0) animated:YES];
    
    self.privacy_policy_1.selected = NO;
    self.continue_btn_1.enabled = NO;
    
    self.privacy_policy_2.selected = NO;
    self.continue_btn_2.enabled = NO;
    
    self.privacy_policy_3.selected = NO;
    self.continue_btn_3.enabled = NO;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.viaSlider.frame;
        frame.origin.x = originX;
        self.viaSlider.frame = frame;
    } completion:^(BOOL finished) {
        
        if (sender.tag == 0) {
            [self.viaMnemonicTextView becomeFirstResponder];
        }else if (sender.tag == 1){
            [self.viaPrivateKeyTextView becomeFirstResponder];
        }else if (sender.tag == 2){
            [self.viaKeystoreTextView becomeFirstResponder];
        }
    }];
}

- (void)showPolicyAction:(id)sender{
    NSURL *url = [NSURL URLWithString:GSENETWORK_HOST@"/wallet/terms"];
    GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
    browser.customTitle = NSLocalizedString(@"Terms & Privacy Policy",nil);
    browser.url = url;
    [self.navigationController pushViewController:browser animated:YES];
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
