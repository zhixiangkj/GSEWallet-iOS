//
//  GSE_WalletRemover.m
//  GSEWallet
//
//  Created by user on 30/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletRemover.h"

@interface GSE_WalletRemover ()
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UIButton *continue_btn;
@end

@implementation GSE_WalletRemover

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Delete Wallet",nil);
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //self.hidesBottomBarWhenPushed = YES;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat padding = 40;
    
    /*{
     UILabel *label = [[UILabel alloc] init];
     label.text = @"Warning";
     label.textColor = GSE_Blue;
     label.font = [UIFont systemFontOfSize:22];
     [label sizeToFit];
     label.center = CGPointMake(width / 2.0, 40 + padding);
     [self.contentView addSubview:label];
     }*/
    
    {
        UIImage *image = [UIImage imageNamed:@"remove_warning"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(width / 2.0, 142 + padding);
        [self.view addSubview:imageView];
    }
    
    self.content = ({
        CGRect rect = CGRectMake(0, 0, width - MARGIN * 2, 0);
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textColor = UIColorFromRGB(0x333333);
        label.font = [UIFont systemFontOfSize:16];
        [label setText:NSLocalizedString(@"You are about to remove the current\nwallet from this device. Please\nconfirm with your wallet password",nil) lineSpacing:8 wordSpacing:1];
        label.textAlignment = NSTextAlignmentCenter;
        
        [label sizeToFit];
        label.center = CGPointMake(width / 2.0, 142 + padding  + label.bounds.size.height / 2.0);
        label;
    });
    [self.contentView addSubview:self.content];
    
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
        //[button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: NSLocalizedString(@"Continue",nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        //[button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.continue_btn];
}
#pragma mark - action

- (void)nextAction:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Enter Wallet Password",nil) message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = NSLocalizedString(@"Password",nil);
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    
    __weak typeof(self) weakSelf = self;
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *password = alert.textFields.firstObject;
        if (password.text.length) {
            
            if (!weakSelf.wallet) {
                [weakSelf alertTitle:NSLocalizedString(@"Something Wrong",nil) withMessage:NSLocalizedString(@"Please try again later",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                return;
            }
            MBProgressHUD *hud = [weakSelf unlocking];
            
            NSString *keystore = [[GSE_Wallet shared] getKeystoreString:weakSelf.wallet];
            [Account decryptSecretStorageJSON:keystore password:password.text callback:^(Account *account, NSError *error) {
                if (error) {
                    [weakSelf loadingFinish];
                    [weakSelf alertTitle:NSLocalizedString(@"Invalid Password",nil) withMessage:nil buttonTitle:NSLocalizedString(@"Retry",nil) cancel:^{
                        
                    } finish:^{
                        [weakSelf nextAction:nil];
                    }];
                    return;
                }
                [weakSelf finishing:NSLocalizedString(@"Deleted",nil) withHud:hud];

                BOOL result = [[GSE_Wallet shared] removeWallet:weakSelf.wallet withPassword:password.text];
                
                if (!result) {
                    [weakSelf alertTitle:NSLocalizedString(@"Something wrong",nil) withMessage:NSLocalizedString(@"Please try again later",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                    return;
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hideAnimated:NO];
                    if (weakSelf.finish) {
                        weakSelf.finish();
                    }
                    
                });
            }];
        }
        else{
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:^{}];
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
