//
//  GSE_WalletTransferConfirmation.m
//  wallet
//
//  Created by user on 29/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletConfirmation.h"
#import "GSE_TxnDetailCell.h"

#import "GSE_WalletWebBrowser.h"
#import "GSE_WalletTxns.h"

@interface GSE_WalletTransferConfirmation () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *continue_btn;

@end

@implementation GSE_WalletTransferConfirmation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"Transaction Confirmation",nil);
    if ([UIScreen mainScreen].bounds.size.width < 414) {
        self.title = NSLocalizedString(@"Confirmation",nil);
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    //CGFloat navbar = [UIScreen iPhoneX] ? 144: 64;
    
    self.tableView = ({
        CGFloat originY = 0; //478 / 2.0;
        CGRect rect = CGRectMake(0, originY, width, height - originY);
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.tableFooterView = ({
            CGRect frame = CGRectMake(0, 0, width, 30);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
        tableView.separatorColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    [self.contentView addSubview:self.tableView];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.15);
    
    self.continue_btn = ({
        //CGFloat origin = 20;
        //CGRect rect = CGRectMake(MARGIN, origin, width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        CGFloat height = self.contentView.bounds.size.height;
        CGFloat origin = [UIScreen iPhoneX] ? height - 144 *ratio - 36 - 50 : height - 104 * ratio - 36 - 50;
        CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
        
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button.layer setCornerRadius:25];
        [button.layer setMasksToBounds:NO];
        [button setClipsToBounds:YES];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: NSLocalizedString(@"Send",nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        //[button setEnabled:NO];
        button;
    });
    //[self.contentView addSubview:self.continue_btn];
    
    self.tableView.tableFooterView = ({
        CGFloat footerHeight = (height - 70 * 2 - 158 / 2.0 - 92 - 170)  * ratio;
        if (footerHeight < 100) {
            footerHeight = 100;
        }
        CGRect frame = CGRectMake(0, 0, width, footerHeight);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        self.continue_btn.center = CGPointMake(width / 2.0, frame.size.height / 2.0);
        [view addSubview:self.continue_btn];
        view;
    });
}

#pragma mark - delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.transaction.transactionHash) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 4;
    }
    if (section == 2) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *identifier = @"GSE_Wallet_Txn_Detail_Amount_Cell";
        GSE_TxnDetailAmountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_TxnDetailAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //Transaction *info = self.transaction;
        
        NSString *symbol = self.token[@"symbol"];
        [cell setTitle:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Amount",nil), symbol]];
        
        NSInteger decimal = [self.token[@"decimals"] integerValue];
        if (self.isContract) {
            NSString *value = [Payment formatToken:self.value withDecimal:decimal] ;
            [cell setValue: [NSString stringWithFormat:@"-%@",value]];
        }else{
            
            NSString *value = [Payment formatEther:self.value];
            [cell setValue: [NSString stringWithFormat:@"-%@",value]];
        }
        [cell setTxn_out:self.isTxnOut];
        return cell;
    }
    static NSString *identifier = @"GSE_Wallet_Txn_Detail_Cell";
    GSE_TxnDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GSE_TxnDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Transaction*info = self.transaction;
    
    if (indexPath.section == 0) {
        [cell setTitle:NSLocalizedString(@"Amount",nil)];
        NSInteger decimal = [self.token[@"decimals"] integerValue];
        if (self.isContract) {
            NSString *value = [Payment formatToken:self.value withDecimal:decimal] ;
            [cell setValue: [NSString stringWithFormat:@"-%@",value]];
        }else{
            NSString *value = [Payment formatEther:self.value];
            [cell setValue: [NSString stringWithFormat:@"-%@",value]];
        }
        [cell setLargeBlue:YES];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell setTitle:NSLocalizedString(@"From",nil)];
            [cell setValue: info.fromAddress.checksumAddress];
        }else if (indexPath.row == 1){
            [cell setTitle:NSLocalizedString(@"To",nil)];
            [cell setValue: self.toAddress.checksumAddress];
        }else if (indexPath.row == 2){
            [cell setTitle:NSLocalizedString(@"Fee Estimation",nil)];
            NSString *fee = [Payment formatEther:[info.gasLimit mul:info.gasPrice]];
            [cell setValue: [NSString stringWithFormat:@"%@ Ether",fee]];
        }else if (indexPath.row == 3){
            [cell setTitle:NSLocalizedString(@"Nonce",nil)];
            [cell setValue: @(info.nonce).stringValue];
        }
        [cell setLargeBlue:NO];
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [cell setTitle:NSLocalizedString(@"Status",nil)];
            [cell setValue:NSLocalizedString(@"Pending", nil)];
        }else if (indexPath.row == 1){
            [cell setTitle:NSLocalizedString(@"TxHash",nil)];
            [cell setValue:[NSString stringWithFormat:@"%@",info.transactionHash.hexString]];
        }
        [cell setLargeBlue:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 240 / 2.0;
    }
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        if ([UIScreen mainScreen].bounds.size.height < 568) {
            return 1;
        }
        return 36 / 2.0;
    }
    if (section == 1) {
        return 10 / 2.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    CGFloat height = [self tableView:tableView heightForFooterInSection:section];
    
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, height);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = [UIColor whiteColor];
    if (section != 2)
    {
        if (section == 0 || ( section == 1 && self.transaction.transactionHash )) {
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGRect frame = CGRectMake(MARGIN, height - 1, width - MARGIN * 2 ,0.5); //450 / 2.0,
            UIView *separator = [[UIView alloc] initWithFrame:frame];
            separator.backgroundColor = UIColorFromRGB(0xdedede);
            [view addSubview:separator];
        }
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 2) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Copy TxHash", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            Transaction *info = (id)self.transaction;
            NSString *hash = info.transactionHash.hexString;
            pasteboard.string = hash;
            
            [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
            
            MBProgressHUD *hud = [self finishing:NSLocalizedString(@"Copied",nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Go Etherscan", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            Transaction *info = (id)self.transaction;
            NSString *hash = info.transactionHash.hexString;
            NSString *url = [NSString stringWithFormat:@"https://etherscan.io/tx/%@",hash];
            
            GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
            browser.customTitle = hash;
            browser.url = [NSURL URLWithString:url];
            [self.navigationController pushViewController:browser animated:YES];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)  style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - send

- (void)nextAction:(Transaction *)transaction{
    [self loadingFinish];
    
    //[self alertTitle:@"Transaction" withMessage:self.transaction.description buttonTitle:@"OK" finish:nil];
    //return;
    
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
                    }  finish:^{
                        [weakSelf nextAction:weakSelf.transaction];
                    }];
                    return;
                }
                [account sign:transaction];
                NSLog(@"%@",transaction);
                
                [weakSelf.continue_btn setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
                [weakSelf.continue_btn removeTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
                [weakSelf.continue_btn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
                [weakSelf setHideBack:YES];
                
                [weakSelf.tableView reloadData];
                
                NSLog(@"%@",transaction.transactionHash.hexString);
                
                NSData *signedTransaction = [transaction serialize];
                
                Provider *provider = [[GSE_Wallet shared] getProvider];
                
                hud.label.text = NSLocalizedString(@"Sending...",nil);
                
                
                NSString *from = transaction.fromAddress.checksumAddress.lowercaseString;
                NSString *to = transaction.toAddress.checksumAddress.lowercaseString;
                NSData *hashData = [SecureData KECCAK256:signedTransaction];
                Hash *hash = [Hash hashWithData:hashData];
                NSString *hashString = hash.hexString;
                
                TransactionInfo *transactionInfo = [TransactionInfo transactionInfoWithPendingTransaction:transaction hash:hash];
                NSMutableDictionary *dic = [transactionInfo dictionaryRepresentation].mutableCopy;
                NSLog(@"transactionInfo: %@, hash: %@",dic,hashString);
                
                if (weakSelf.isContract) {
                    if (!to || ![to isKindOfClass:[NSString class]] || !to.length) {
                        [weakSelf loadingFinish];
                        [weakSelf alertTitle:NSLocalizedString(@"Transaction Failed",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                        return;
                    }
                    NSInteger decimal = [weakSelf.token[@"decimals"] integerValue];
                    NSString *value = [Payment formatToken:weakSelf.value withDecimal:decimal] ;
                    [dic setObject:value forKey:@"quantity"];
                    [dic setObject:weakSelf.toAddress.checksumAddress.lowercaseString forKey:@"to"];
                }
                //[dic setObject:[GSE_Wallet shared].getClientid forKey:@"clientid"];
                
                if (!from || ![from isKindOfClass:[NSString class]] || !from.length || !hashString) {
                    [weakSelf loadingFinish];
                    [weakSelf alertTitle:NSLocalizedString(@"Transaction Failed",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                    return;
                }
                
                NSString *clientid = [GSE_Wallet shared].getClientid;
                NSMutableDictionary *pending = @{@"address":from,
                                                 @"hash":hashString,
                                                 @"transaction": dic,
                                                 @"clientid":clientid
                                                 }.mutableCopy;
                
                if (weakSelf.isContract) {
                    [pending setObject:to forKey:@"contractAddress"];
                }
                
                DictionaryPromise *p = [provider syncPending:pending];
                [p onCompletion:^(DictionaryPromise *promise) {
                    if (!promise.result) {
                        [weakSelf loadingFinish];
                        [weakSelf alertTitle:NSLocalizedString(@"Network Error",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                        return ;
                    }
                    
                    NSDictionary *value = promise.value;
                    NSString *ok = value[@"ok"];
                    if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
                        [weakSelf alertTitle:NSLocalizedString(@"Transaction Failed",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                        return;
                    }

                    [[provider sendTransaction:signedTransaction] onCompletion:^(HashPromise *promise) {
                        if (!promise.result) {
                            [weakSelf loadingFinish];
                            NSString *reason = promise.error.userInfo[@"reason"];
                            [weakSelf alertTitle:NSLocalizedString(@"Transaction Failed",nil) withMessage:reason ? NSLocalizedString( reason, nil): nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                            return;
                        }
                        NSLog(@"%@: Sent - signed=%@ hash=%@ error=%@", NSStringFromClass([self class]), signedTransaction, promise.value, promise.error);
                        
                        [weakSelf finishing:NSLocalizedString(@"Sent", nil) withHud:hud];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [hud hideAnimated:YES];
                        });
                    }];
                    
                    NSDictionary *rebate = value[@"rebate"];
                    NSLog(@"rebate: %@",rebate);
                    if([rebate isKindOfClass:[NSDictionary class]] && rebate.count){
                        
                        NSString *ok = rebate[@"ok"];
                        if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
                            return;
                        }
                        NSDictionary *data = rebate[@"data"];
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
                            return;
                        }
                        NSLog(@"%@",data);
                        
                        [[GSE_Wallet shared] storeRebate:data forClient:clientid];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"rebateChanged" object:nil];
                    }
                }];
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

- (void)sendAction:(id)sender{
 
    if (self.token && [self.token[@"contractAddress"] isKindOfClass:[NSString class]]) {
        
        Address *contract = [Address addressWithString:self.token[@"contractAddress"]];
        
        NSString *decimalString = self.token[@"decimals"];
        if (!contract || !decimalString || ![decimalString respondsToSelector:@selector(integerValue)]) {
            [self alertTitle:NSLocalizedString(@"Something Wrong", nil) withMessage:NSLocalizedString(@"Please try again later",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
                
            }];
            return;
        }
        BigNumber *decimal = [BigNumber bigNumberWithInteger:decimalString.integerValue];
        NSLog(@"decimal: %@",decimal);
        
        self.transaction.toAddress = contract;
        //contractAddress
        self.transaction.value = [BigNumber bigNumberWithInteger:0];
        
        NSString * transferMethod = @"transfer(address,uint256)";
        NSData * transferSignature = [SecureData KECCAK256:[transferMethod dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (!transferSignature || transferSignature.length < 5) {
            [self alertTitle:NSLocalizedString(@"Something Wrong", nil) withMessage:NSLocalizedString(@"Please try again later",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
                
            }];
            return;
        }
        transferSignature = [transferSignature subdataWithRange:NSMakeRange(0, 4)];
        NSLog(@"transfer signature: %@",transferSignature);
        
        NSData *toAddressData = self.toAddress.data;
        if (!toAddressData.length || toAddressData.length >= 32) {
            [self alertTitle:NSLocalizedString(@"Something Wrong", nil) withMessage:NSLocalizedString(@"Please try again later",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
                
            }];
            return;
        }
        
        SecureData *transferTo = [SecureData secureDataWithLength:32 - toAddressData.length];
        [transferTo appendData:toAddressData];
        
        NSLog(@"transfer to: %@", transferTo.data);
        
        BigNumber *value = self.value;
        
        NSData *valueData = value.data;
        
        if (!valueData.length || valueData.length >= 32) {
            [self alertTitle:NSLocalizedString(@"Something Wrong", nil) withMessage:NSLocalizedString(@"Please try again later",nil) buttonTitle:NSLocalizedString(@"OK",nil) finish:^{
                
            }];
            return;
        }
        
        SecureData *transferAmount = [SecureData secureDataWithLength:32 - valueData.length];
        [transferAmount appendData:valueData];
        
        NSLog(@"transfer value: %@", transferAmount.data);
        
        NSMutableData *data = [NSMutableData data];
        [data appendData:transferSignature];
        [data appendData:transferTo.data];
        [data appendData:transferAmount.data];
        
        self.transaction.data = data;
        NSLog(@"transaction data: %@",data);
        [self nextAction:self.transaction];
        
        return;
    }
    
    if (![self.token[@"symbol"] isEqualToString:@"ETH"]) {
        [self alertTitle:@"Transaction Error" withMessage:self.transaction.description buttonTitle:@"OK" finish:nil];
        return;
    }
    
    self.transaction.toAddress = self.toAddress;
    self.transaction.value = self.value;
    
    [self nextAction:self.transaction];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Tx_ConfirmTransfer"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)doneAction:(id)sender{
    UINavigationController *navigationController = self.navigationController;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    NSMutableDictionary *token = self.token.mutableCopy;
    
    GSE_WalletTxns * txns = [[GSE_WalletTxns alloc] init];
    txns.token = token;
    NSString * symbol = token[@"symbol"];
    if (![symbol isKindOfClass:[NSString class]] || !symbol.length) {
        return;
    }
    txns.symbol = symbol;
    NSString *name = token[@"name"];
    txns.name = name;
    
    NSString *contract = token[@"contractAddress"];
    if ([contract isKindOfClass:[NSString class]]) {
        txns.contract = [Address addressWithString:contract];
    }

    NSString *current = [[GSE_Wallet shared] getCurrentWallet];
    txns.address = [[GSE_Wallet shared] getAddressForWallet:current];
    [navigationController pushViewController:txns animated:YES];
}

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
