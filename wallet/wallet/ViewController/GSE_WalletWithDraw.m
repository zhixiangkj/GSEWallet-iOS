//
//  GSE_WalletWithDraw.m
//  GSEWallet
//
//  Created by user on 06/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletWithDraw.h"
#import "GSE_WalletMenu.h"
#import "ViewController.h"

#import "GSE_Rebate.h"

@interface GSE_WalletWithDraw ()
@property (nonatomic, strong) UILabel *gseLabel;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *walletLabel;
@property (nonatomic, strong) UIButton *walletButton;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *continue_btn;

@property (nonatomic, strong) GSE_RebateCode *rebate;
@property (nonatomic, strong) NSString *choosenWallet;
@end

@implementation GSE_WalletWithDraw

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Withdraw GSE",nil);
    self.hidesBottomBarWhenPushed = YES;
    
    self.rebate = ({
        GSE_Wallet *shared = [GSE_Wallet shared];
        GSE_RebateCode *rebate = [[GSE_RebateCode alloc] init];
        [rebate addEntriesFromDictionray: [shared getRebateForClient:shared.getClientid]];
        rebate;
    });
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = self.contentView.bounds.size.height;    
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:12];
        label.text = NSLocalizedString(@"GSE from Rebates", nil);
        [label sizeToFit];
        label.center = CGPointMake(width / 2.0, 50);
        [self.contentView addSubview:label];
    }

    self.gseLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:30];
        
        label.text = self.rebate.quantity?:@"0.0000";
        
        [label sizeToFit];
        label.center = CGPointMake(width / 2.0, 172 / 2.0);
        label;
    });
    [self.contentView addSubview:self.gseLabel];
    
    self.menuButton = ({
        CGRect rect = CGRectMake(10, 384 / 2.0 - 20, width - 20, 40);
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0 / 2;
        button.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        [button addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.contentView addSubview:self.menuButton];
    
    self.walletLabel = ({
        CGRect rect = CGRectMake(15, 0,
                                 CGRectGetWidth(self.menuButton.bounds) - 30,
                                 CGRectGetHeight(self.menuButton.bounds));
        
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"Destination Wallet", nil);
        [label sizeToFit];
        label.center = CGPointMake( 15 + CGRectGetWidth(label.bounds) / 2.0, CGRectGetHeight(self.menuButton.bounds) / 2.0);
        label;
    });
    [self.menuButton addSubview:self.walletLabel];
    
    self.walletButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"withdraw_select_wallet"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button sizeToFit];
        button.center = CGPointMake( CGRectGetWidth(self.menuButton.frame) - 15 - CGRectGetWidth(button.bounds) / 2.0, CGRectGetHeight(self.menuButton.bounds) / 2.0);
        button.userInteractionEnabled = NO;
        button;
    });
    [self.menuButton addSubview:self.walletButton];
    
    self.tipLabel = ({
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setTextColor:UIColorFromRGB(0x999999)];
        [label setText: [NSString stringWithFormat:NSLocalizedString(@"Minimum withdrawal: %@ GSE", nil),self.rebate.withdraw ? : @"500"]];
        [label sizeToFit];
        label.center = CGPointMake( 15 + 10 + label.bounds.size.width / 2.0, CGRectGetMaxY(self.menuButton.frame) + 20);
        label;
    });
    [self.contentView addSubview:self.tipLabel];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.15);
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
        [button setTitle: NSLocalizedString( @"Withdraw" , nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        //[button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.continue_btn];
}

- (void)menuAction:(id)sender{
    
    __weak typeof(self) weakSelf = self;
    GSE_WalletMenu *menu = [[GSE_WalletMenu alloc] init];
    menu.chooseWallet = YES;
    [menu setCreatedOrImported:^(NSString *name) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.walletButton setImage:nil forState:UIControlStateNormal];
            [weakSelf.walletButton setTitle:name forState:UIControlStateNormal];
            [weakSelf.walletButton sizeToFit];
            CGFloat maxWidth = CGRectGetWidth(weakSelf.menuButton.bounds) - CGRectGetMaxX(weakSelf.walletLabel.frame) - 20;
            if (CGRectGetWidth(weakSelf.walletButton.frame) > maxWidth) {
                weakSelf.walletButton.frame = ({
                    CGRect frame = weakSelf.walletButton.frame;
                    frame.size.width = maxWidth;
                    frame;
                });
            }
            weakSelf.walletButton.center = CGPointMake( CGRectGetWidth(weakSelf.menuButton.frame) - 15 - CGRectGetWidth(weakSelf.walletButton.bounds) / 2.0, CGRectGetHeight(weakSelf.menuButton.bounds) / 2.0);
            weakSelf.choosenWallet = name;
        });
    }];
    
    UIView *view = [self.navigationController.view snapshotViewAfterScreenUpdates:YES];
    [self.navigationController.view addSubview:view];
    
    [menu setFinish:^{
        [view removeFromSuperview];
    }];
    
    menu.backgroundView = [self.navigationController.tabBarController.view snapshotViewAfterScreenUpdates:YES];
    ViewControllerNav *nav = [[ViewControllerNav alloc] initWithRootViewController:menu];
    [self presentViewController:nav animated:NO completion:^{

    }];
}

- (void)nextAction:(id)sender{

    if (!self.choosenWallet) {
        [self alertTitle:NSLocalizedString(@"Wallet Required",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
        
        /*
         [weakSelf alertTitle:result withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
         [weakSelf.navigationController popViewControllerAnimated:YES];
         }];*/
        
        /*NSString *days = @"3" ;
        NSString *result = [NSString stringWithFormat:NSLocalizedString(@"The GSE rebates will be sent to your\nselected wallet address in %@ days", nil),days];
        
        GSE_WalletWithDrawSuccess *success = [[GSE_WalletWithDrawSuccess alloc] init];
        success.tip = result;
        [self.navigationController pushViewController:success animated:YES];
        return;*/
    }
    
    double quantity = self.rebate.quantity.doubleValue;
    double withdraw = self.rebate.withdraw ? self.rebate.withdraw.doubleValue : 500;
    
    if (quantity < withdraw) {
        [self alertTitle:[NSString stringWithFormat:NSLocalizedString(@"Minimum withdrawal: %@ GSE", nil),self.rebate.withdraw ? : @"500"] withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    NSString *title = [NSString stringWithFormat: NSLocalizedString(@"Confirm to withdraw GSE rebates to Wallet %@?", nil) ,self.choosenWallet];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Confirm", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MBProgressHUD *hud = [self loading];
        
        GSE_Wallet *wallet = [GSE_Wallet shared];
        Provider *provider = [wallet getProvider];
        
        Address *address = [wallet getAddressForWallet:self.choosenWallet];
        if (!address) {
            [self alertTitle:NSLocalizedString(@"Wallet Required",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
            return ;
        }
        NSDictionary * info = @{@"address":address.checksumAddress.lowercaseString?:@"",
                                @"device":[UIDevice deviceInfo],
                                @"clientid":[wallet getClientid],
                                @"quantity":self.gseLabel.text?:@"0"
                                };
        NSData *encrypted = [[NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:nil] sign];
        NSString *encryptedString = [encrypted base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSLog(@"%@",encryptedString);
        NSDictionary *dic = @{@"encrypted": encryptedString?:@""};
        
        __weak typeof(self)weakSelf = self;
        
        [[provider withdrawRebate:dic] onCompletion:^(DictionaryPromise *promise) {
            NSLog(@"%@",promise.result);
            
            if (!promise.result) {
                [hud hideAnimated:YES];
                [weakSelf alertTitle:NSLocalizedString(@"Network Error",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                return ;
            }
            
            [hud hideAnimated:YES];
            
            NSDictionary *value = promise.value;
            NSString *ok = value[@"ok"];
            if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
                [weakSelf alertTitle:NSLocalizedString(@"Withdraw Failed",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                return;
            }
            
            NSDictionary *data = value[@"data"];
            if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                if(![data isKindOfClass:[NSString class]]){
                    return;
                }
                NSString *base64 = (id)data;
                NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *decryptedData = [base64Data sign];
                data = [NSJSONSerialization JSONObjectWithData:decryptedData options:kNilOptions error:nil];
            }
            if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                [weakSelf alertTitle:NSLocalizedString(@"Withdraw Failed",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                return;
            }
            NSLog(@"%@",data);
            
            NSString *days = [data objectForKey:@"day"] ? :@"3" ;
            NSString *result = [NSString stringWithFormat:NSLocalizedString(@"The GSE rebates will be sent to your\nselected wallet address in %@ days", nil),days];
            
            /*
            [weakSelf alertTitle:result withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];*/
            
            [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
            
            GSE_WalletWithDrawSuccess *success = [[GSE_WalletWithDrawSuccess alloc] init];
            success.tip = result;
            [weakSelf.navigationController pushViewController:success animated:YES];
            
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@interface GSE_WalletWithDrawSuccess ()
@property (nonatomic,strong) UIButton *continue_btn;
@end

@implementation GSE_WalletWithDrawSuccess

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = self.contentView.bounds.size.height;
    self.hideBack = YES;
    self.navigationItem.leftBarButtonItem = ({
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction:)];
        item;
    });
    
    self.title = NSLocalizedString(@"Withdraw Submitted", nil);
    
    {
        UIImage *image = [UIImage imageNamed:@"rebate_success_check"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, 288 / 2.0);
        [self.contentView addSubview:imageView];
    }
    
    {
        CGRect rect  = CGRectMake(0, 0, self.view.bounds.size.width - 60, 0);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:16];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.tip;
        [label setText:label.text lineSpacing:8 wordSpacing:1];
        [label sizeToFit];
        label.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, 468 / 2.0);
        [self.contentView addSubview:label];
    }
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.15);
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
        [button setTitle: NSLocalizedString( @"Done" , nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        //[button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.continue_btn];
}

- (void)nextAction:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
