//
//  GSE_WalletReferral.m
//  GSEWallet
//
//  Created by user on 05/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletReferral.h"
#import "GSE_MenuReferral.h"

@interface GSE_WalletReferral () <UITextFieldDelegate>
@property (nonatomic, strong) GSE_MenuReferral *menu;
@end

@implementation GSE_WalletReferral

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.backgroundView) {
        [self.view addSubview:self.backgroundView];
    }
    
    if (!self.menu) {
        self.menu =({
            GSE_MenuReferral *menu = [[GSE_MenuReferral alloc] init];
            menu.delegate = self;
            //menu.hidden = YES;
            menu;
        });
        [self.menu close];
        [self.view addSubview:_menu];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.menu open];
}

#pragma mark - action

- (void)closeAction:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.finish) {
            self.finish();
        }
    }];
}

- (void)closeAction{
    __weak typeof(self)weakSelf = self;
    [weakSelf.menu close:^{
       [weakSelf closeAction:nil];
    }];
}

#pragma mark - delegate

- (void)nextAction:(GSE_MenuReferral *)sender{
    
    if (!sender.textField.text.length) {
        if (self.createdOrImported) {
            self.createdOrImported(nil);
        }
        [self closeAction];
        return;
    }
    
    [self loading];
    
    GSE_Wallet *wallet = [GSE_Wallet shared];
    Address *address = [wallet getCurrentWalletAddress];
    NSDictionary * info = @{@"address":address.checksumAddress.lowercaseString?:@"",
                            @"device":[UIDevice deviceInfo],
                            @"clientid":[wallet getClientid],
                            @"code":sender.textField.text?:@""
                            };
    NSData *encrypted = [[NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:nil] sign];
    NSString *encryptedString = [encrypted base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"%@",encryptedString);
    NSDictionary *dic = @{@"encrypted": encryptedString?:@""};
    
    Provider *provider = wallet.getProvider;
    __weak typeof(self)weakSelf = self;
    [[provider checkRebateCode:dic] onCompletion:^(DictionaryPromise *promise) {
        if (!promise.result) {
            [weakSelf loadingFinish];
            [weakSelf alertTitle:NSLocalizedString(@"Network Error", nil)
                     withMessage:nil buttonTitle:NSLocalizedString(@"OK", nil) finish:nil];
            return ;
        }
        [weakSelf loadingFinish];
        NSDictionary *value = promise.value;
        NSString *ok = value[@"ok"];
        if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
            sender.referalTipLabel.hidden = NO;
            return;
        }
        if (weakSelf.createdOrImported) {
            weakSelf.createdOrImported(sender.textField.text);
        }
        [weakSelf closeAction];
    }];
    
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
