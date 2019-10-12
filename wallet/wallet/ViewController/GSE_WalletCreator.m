//
//  GSE_WalletCreator.m
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletCreator.h"
#import "GSE_WalletSuccessor.h"
#import "GSE_WalletWebBrowser.h"
#import "GSE_WalletReferral.h"
#import "ViewController.h"

@interface GSE_WalletCreator ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *image;

@property (nonatomic, strong) UITextField *name;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *repeat;

@property (nonatomic, strong) UILabel  *password_tip1;
@property (nonatomic, strong) UILabel  *password_tip2;
@property (nonatomic, strong) UIButton *password_btn1;
@property (nonatomic, strong) UIButton *password_btn2;

@property (nonatomic, strong) UIButton *privacy_policy;
@property (nonatomic, strong) UIButton *continue_btn;
@property (nonatomic, strong) UIButton *referral_btn;

@property (nonatomic, strong) NSString *referral_code;
@end

@implementation GSE_WalletCreator

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.import ? NSLocalizedString(@"Import Wallet", nil) : NSLocalizedString(@"Create Wallet", nil);
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    //[self setBackItem];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.15);
    NSLog(@"%s,%@,%@",__FUNCTION__,@(screenHeight),@(ratio));
    
    self.image = ({
        UIImage *image = [UIImage imageNamed:@"new_wallet"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(width / 2.0, 56 * ratio);
        imageView.transform = CGAffineTransformMakeScale(ratio, ratio);
        imageView.hidden = (ratio != 1.0);
        imageView;
    });
    [self.contentView addSubview:self.image];
    
    self.name = ({
        CGRect rect = CGRectMake(MARGIN, 120 * ratio, width - MARGIN * 2, 40);
        UITextField *textField = [[UITextField alloc] initWithFrame:rect];
        textField.font = [UIFont systemFontOfSize:15];
        [textField setPlaceholder:NSLocalizedString(@"Enter wallet name", nil) color:UIColorFromRGB(0x999999) wordSpacing:1]; //Name the wallet
        textField.returnKeyType = UIReturnKeyNext;
        textField.textColor = UIColorFromRGB(0x333333);
        textField.delegate = self;
        textField;
    });
    [self.contentView addSubview:self.name];
    
    {
        CGFloat origin = self.name.frame.origin.y + self.name.frame.size.height;
        CGRect rect = CGRectMake(MARGIN, origin, width - MARGIN * 2, 0.5);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = UIColorFromRGB(0xeaeaea);
        [self.contentView addSubview:view];
    }
    
    self.password = ({
        CGFloat origin = self.name.frame.origin.y + self.name.frame.size.height + 30 * ratio;
        CGRect rect = CGRectMake(MARGIN, origin, width - MARGIN * 2, 40);
        UITextField *textField = [[UITextField alloc] initWithFrame:rect];
        textField.font = [UIFont systemFontOfSize:15];
        [textField setPlaceholder: NSLocalizedString( @"Enter wallet password", nil) color:UIColorFromRGB(0x999999) wordSpacing:1]; //Set up password for this wallet
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyNext;
        textField.textColor = UIColorFromRGB(0x333333);
        textField.delegate = self;
        textField;
    });
    [self.contentView addSubview:self.password];
    
    {
        CGFloat origin = self.password.frame.origin.y + self.password.frame.size.height;
        CGRect rect = CGRectMake(MARGIN, origin, width - MARGIN * 2, 0.5);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = UIColorFromRGB(0xeaeaea);
        [self.contentView addSubview:view];
    }
    
    self.password_tip1 = ({
        CGFloat origin = self.password.frame.origin.y + self.password.frame.size.height;
        CGRect rect  = CGRectMake(MARGIN,origin + 2,0,0);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.text = NSLocalizedString(@"at least 6 characters",nil); //Minimum
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xdbdbdb);
        [label sizeToFit];
        label.alpha = (ratio == 0.15) ? 0 : 1;
        rect.size.width = label.bounds.size.width;
        rect.size.height = label.bounds.size.height;
        label.frame  = rect;
        label.hidden = YES;
        label;
    });
    [self.contentView addSubview:self.password_tip1];
    
    self.password_btn1 = ({
        UIButton *button = [[UIButton alloc] init];
        UIImage *password_weak = [UIImage imageNamed:@"password_weak"];
        UIImage *password_strong = [UIImage imageNamed:@"password_strong"];
        [button setImage:password_weak forState:UIControlStateNormal];
        [button setImage:password_strong forState:UIControlStateSelected];
        [button setTitle:NSLocalizedString(@" weak ",nil) forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"strong",nil) forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [button setTitleColor:UIColorFromRGB(0xff4b4b) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x59e8c1) forState:UIControlStateSelected];
        [button sizeToFit]; [button centerVertically];
        button.center = CGPointMake( width - MARGIN * 2, self.password.center.y + 8 - 5);
        button.userInteractionEnabled = NO;
        button.hidden = YES;
        button;
    });
    [self.contentView addSubview:self.password_btn1];
    
    self.repeat = ({
        CGFloat origin = self.password.frame.origin.y + self.password.frame.size.height + 30 * ratio; // + 44
        CGRect rect = CGRectMake(MARGIN, origin, width - MARGIN * 2, 40);
        UITextField *textField = [[UITextField alloc] initWithFrame:rect];
        textField.font = [UIFont systemFontOfSize:15];
        [textField setPlaceholder:NSLocalizedString(@"Confirm wallet password",nil) color:UIColorFromRGB(0x999999) wordSpacing:1];
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
        textField.textColor = UIColorFromRGB(0x333333);
        textField.delegate = self;
        textField;
    });
    [self.contentView addSubview:self.repeat];
    
    {
        CGFloat origin = self.repeat.frame.origin.y + self.repeat.frame.size.height;
        CGRect rect = CGRectMake(MARGIN, origin, width - MARGIN * 2, 0.5);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = UIColorFromRGB(0xeaeaea);
        [self.contentView addSubview:view];
    }
    
    self.password_tip2 = ({
        CGFloat origin = self.repeat.frame.origin.y + self.repeat.frame.size.height;
        CGRect rect  = CGRectMake(MARGIN,origin + 2,0,0);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.text = NSLocalizedString(@"Passwords don't match",nil); //at least
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xff4b4b);
        [label sizeToFit];
        rect.size.width = label.bounds.size.width;
        rect.size.height = label.bounds.size.height;
        label.frame  = rect;
        label.hidden = YES;
        label;
    });
    //[self.view addSubview:self.password_tip2];
    
    self.privacy_policy = ({
        CGFloat origin = self.repeat.frame.origin.y + self.repeat.frame.size.height;
        UIButton *button = [[UIButton alloc] init];
        UIImage *policy_unchecked = [UIImage imageNamed:@"policy_unchecked"];
        UIImage *policy_checked = [UIImage imageNamed:@"policy_checked"];
        [button setImage:policy_unchecked forState:UIControlStateNormal];
        [button setImage:policy_checked forState:UIControlStateSelected];
        [button setTitle:NSLocalizedString(ratio == 1 ?  @"I have read and agree to " : @"Agree to ",nil) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [button setTitleColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateSelected];
        [button setAdjustsImageWhenHighlighted:NO];
        [button sizeToFit];
        [button alignImageToLeftWithGap:10];
        [button addTarget:self action:@selector(agreeToPolicyAction:) forControlEvents:UIControlEventTouchUpInside];
        //button.selected = YES;
        button.center = CGPointMake( MARGIN + button.bounds.size.width / 2.0, origin + button.bounds.size.height / 2.0 + 20);
        button;
    });
    [self.contentView addSubview:self.privacy_policy];
    
    {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:NSLocalizedString(@"Terms & Privacy Policy",nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [button sizeToFit];
        [button addTarget:self action:@selector(showPolicyAction:) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake( self.privacy_policy.frame.origin.x + self.privacy_policy.frame.size.width + button.bounds.size.width / 2.0, self.privacy_policy.center.y);
        [self.contentView addSubview:button];
    }
    
    if (self.import) {
        //self.privacy_policy.hidden = YES;
    }
    
    
    self.continue_btn = ({
        CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 - 50 : height - 104* ratio - 36 - 50;
        CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button.layer setCornerRadius:25];
        [button.layer setMasksToBounds:NO];
        [button setClipsToBounds:YES];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: NSLocalizedString( self.import? @"Import" : @"Continue" , nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.continue_btn];
    
    if (![[GSE_Wallet shared] getCurrentWallet].length) {
        self.referral_btn = ({
            UIButton *button = [[UIButton alloc] init];
            [button setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [button setTitle:NSLocalizedString(@"Have a referral code?", nil) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button sizeToFit];
            button.frame = ({
                CGRect frame = button.frame;
                frame.size.width = self.view.bounds.size.width - MARGIN * 2;
                frame;
            });
            [button addTarget:self action:@selector(referralAction:) forControlEvents:UIControlEventTouchUpInside];
            button.center = CGPointMake(self.continue_btn.center.x,
                                        CGRectGetMinY(self.continue_btn.frame) - CGRectGetHeight(button.bounds) / 2.0 - 10);
            button;
        });
        [self.contentView addSubview:self.referral_btn];
    }
    
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.contentView addGestureRecognizer:tap];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(textFieldTextDidChange:)
     name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.referral_btn.selected) {
        return;
    }
    if (self.name.text.length) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.name becomeFirstResponder];
    });
}

#pragma mark - delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.name) {
        [self.password becomeFirstResponder];
    }else if (textField == self.password){
        [self.repeat becomeFirstResponder];
    }else if (textField == self.repeat){
        NSString *repeat = textField.text;
        NSString *password = self.password.text;
        BOOL same = [repeat isEqualToString:password];
        self.password_tip2.hidden = same;
        if (same) {
            [self.repeat resignFirstResponder];
        }else{
            
            [self alertTitle:NSLocalizedString(@"Passwords don't match",nil) withMessage:NSLocalizedString(@"Please input the same password to confirm",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        }
    }
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.password || textField == self.repeat) {
        self.password_tip2.hidden = YES;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.password) {
        self.password_tip1.hidden = NO;
        self.password_btn1.hidden = NO;
    }
    self.continue_btn.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.continue_btn.enabled = self.privacy_policy.selected;
}

- (void)textFieldTextDidChange:(NSNotification *)noti{
    UITextField * sender = noti.object;
    if(![sender isKindOfClass:[UITextField class]]){
        return;
    }
    if (sender == self.password) {
        NSString * text = sender.text;
        NSInteger length = text.length;
        NSInteger strength = [text passwordStrength];
        BOOL strong = (length >= 6 && strength >= 3);
        self.password_btn1.selected = strong;
    }else if (sender == self.repeat){
        self.password_tip2.hidden = YES;
    }
}

#pragma mark - action

- (void)agreeToPolicyAction:(UIButton *)sender{
    self.privacy_policy.selected = !self.privacy_policy.selected;
    if (self.privacy_policy.selected) {
        [self.name resignFirstResponder];
        [self.password resignFirstResponder];
        [self.repeat resignFirstResponder];
    }else{
        [self.name becomeFirstResponder];
    }
    self.continue_btn.enabled = self.privacy_policy.selected;
}

- (void)showPolicyAction:(id)sender{
    NSURL *url = [NSURL URLWithString:GSENETWORK_HOST@"/wallet/terms"];
    GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
    browser.customTitle = NSLocalizedString(@"Terms & Privacy Policy",nil);
    browser.url = url;
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)nextAction:(UIButton *)sender{
    
    NSString *name = self.name.text;
    if (!name || !name.length) {
        [self alertTitle:NSLocalizedString(@"Wallet Name Needed",nil) withMessage:NSLocalizedString(@"Please input a wallet name and it should not be empty",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    NSString * password = self.password.text;
    
    if (password.length < 6) {
        [self alertTitle:NSLocalizedString(@"Password Length Required",nil) withMessage:NSLocalizedString(@"Please input the password with at least 6 characters",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    NSString *repeat = self.repeat.text;
    BOOL same = [password isEqualToString:repeat];
    if (!same) {
        [self alertTitle:NSLocalizedString(@"Passwords don't match",nil) withMessage:NSLocalizedString(@"Please input the same password to confirm",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    if (!self.privacy_policy.selected) {
        [self alertTitle:NSLocalizedString(@"Agreement Required",nil) withMessage:NSLocalizedString(@"Please agree to Terms & Privacy Policy",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    NSDictionary *wallet = [[GSE_Wallet shared] getKeystore:name];
    if(wallet.count){
        [self alertTitle:NSLocalizedString(@"Wallet name already exists",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    MBProgressHUD *hud = [self loading];
    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Preparing...",nil);
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 120.f);
    
    Account *account = self.import ? : [Account randomMnemonicAccount];
    //NSLog(@"Menonic Phrase: %@", account.mnemonicPhrase);
    
    if (!account) {
        [hud hideAnimated:YES];
        
        [self alertTitle:NSLocalizedString(@"Something Wrong",nil) withMessage:NSLocalizedString(@"Please try again later",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        
        return;
    }
    
    if ([[GSE_Wallet shared] getWalletNameForAddress:account.address].length) {
        [hud hideAnimated:YES];
        
        [self alertTitle:NSLocalizedString(@"Address already exists",nil) withMessage:NSLocalizedString(@"Please import another one",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        
        return;
    }
    
    if (self.referral_btn.selected) {
        __weak typeof(self)weakSelf = self;
        Provider *provider = [GSE_Wallet shared].getProvider;
        GSE_Wallet *wallet = [GSE_Wallet shared];
        NSString *addressString = account.address.checksumAddress.lowercaseString?:@"";
        NSDictionary * info = @{@"address":addressString,
                                @"device":[UIDevice deviceInfo],
                                @"clientid":[wallet getClientid],
                                @"code":weakSelf.referral_code?:@""
                                };
        NSData *encrypted = [[NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:nil] sign];
        NSString *encryptedString = [encrypted base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSLog(@"%@",encryptedString);
        NSDictionary *dic = @{@"encrypted": encryptedString?:@""};
        
        [[provider redeemRebateCode:dic] onCompletion:^(DictionaryPromise *promise) {
            if (!promise.result) {
                [hud hideAnimated:YES];
                [weakSelf alertTitle:NSLocalizedString(@"Network Error",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                return ;
            }
            
            NSDictionary *value = promise.value;
            NSString *ok = value[@"ok"];
            if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
                [weakSelf alertTitle:NSLocalizedString(@"Invalid Referral Code",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                return;
            }
            
            [weakSelf createOrImport:account withPassword:password andWalletName:name andloading:hud];
        }];
        return;
    }
    
    [self createOrImport:account withPassword:password andWalletName:name andloading:hud];
}

- (void)createOrImport:(Account *)account
          withPassword:(NSString *)password
         andWalletName:(NSString *)name
            andloading:(MBProgressHUD *)hud{
    
    if (![account isKindOfClass:[Account class]] ||
        ![password isKindOfClass:[NSString class]] ||
        ![name isKindOfClass:[NSString class]] ||
        ![hud isKindOfClass:[MBProgressHUD class]]
        ) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    [account encryptSecretStorageJSON: password callback: ^(NSString *json) {
        NSLog(@"MnemonicPhase: %@, Password encrypted JSON: %@", account.mnemonicPhrase, json);
        if (!json) {
            [hud hideAnimated:YES];
            
            [weakSelf alertTitle:NSLocalizedString(@"Something Wrong",nil) withMessage:NSLocalizedString(@"Please try again later",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
            return ;
        }
        
        [[GSE_Wallet shared] storeKeystore:json forWallet:name];
        
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = NSLocalizedString(@"Created",nil);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            
            [weakSelf showSuccessAction:name];
        });
    }];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action: self.import? @"Intro_ConfirmImport" : @"Introl_ConfirmCreate"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)showSuccessAction:(NSString *)name{
    if (!name || ![name isKindOfClass:[NSString class]]) {
        self.finish ? self.finish(name) : nil;
        return;
    }
    [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
    
    GSE_WalletSuccessor *successor = [[GSE_WalletSuccessor alloc] init];
    successor.wallet = name;
    successor.import = self.import ? YES : NO;
    if (self.finish) {
        __weak typeof(self) weakSelf = self;
        [successor setFinish:^{
            weakSelf.finish(name);
        }];
    }
    
    [self.navigationController pushViewController:successor animated:YES];
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    [self.repeat resignFirstResponder];
}

- (void)referralAction:(id)sender{
//    if ([[GSE_Wallet shared] getCurrentWallet].length) {
//        return;
//    }
    __weak typeof(self)weakSelf = self;
    GSE_WalletReferral *menu = [[GSE_WalletReferral alloc] init];
    [menu setCreatedOrImported:^(NSString *name) {
        if (!name.length) {
            weakSelf.referral_code = nil;
            weakSelf.referral_btn.selected = NO;
            return ;
        }
        weakSelf.referral_code = name;
        NSString *string = [NSString stringWithFormat:NSLocalizedString(@"Referral code applied: %@", nil),name];
        [weakSelf.referral_btn setTitle:string forState:UIControlStateSelected];
        weakSelf.referral_btn.selected = YES;
    }];
    
    UIView *view = [self.navigationController.view snapshotViewAfterScreenUpdates:YES];
    [self.navigationController.view addSubview:view];
    
    [menu setFinish:^{

        [view removeFromSuperview];
    }];
    
    menu.backgroundView = [self.navigationController.view snapshotViewAfterScreenUpdates:YES];
    ViewControllerNav *nav = [[ViewControllerNav alloc] initWithRootViewController:menu];
    [self presentViewController:nav animated:NO completion:^{

    }];
}

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
