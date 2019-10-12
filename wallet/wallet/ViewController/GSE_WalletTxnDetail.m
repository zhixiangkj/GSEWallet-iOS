//
//  GSE_WalletTxnDetail.m
//  wallet
//
//  Created by user on 30/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletTxnDetail.h"
#import "GSE_TxnDetailCell.h"
#import "GSE_WalletWebBrowser.h"

@interface GSE_WalletTxnDetail ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *blockConfirm;

@end

@implementation GSE_WalletTxnDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString( @"Transaction Details", nil );
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    //CGFloat navbar = [UIScreen iPhoneX] ? 144: 64;
    
    __weak typeof(self) weakSelf = self;
    
    NSString *currentBlock = [[GSE_Wallet shared] blockNumber];
    if (currentBlock.length) {
        if ([weakSelf.transaction isKindOfClass:[NSDictionary class]]) {
            NSDictionary *info = weakSelf.transaction;
            NSString *blockNumber = info[@"blockNumber"];
            if (blockNumber && [blockNumber isKindOfClass:[NSString class]]) {
                _blockConfirm = @(currentBlock.integerValue - blockNumber.integerValue).stringValue;
            }
        }
    }
    
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
    
    [self reloadData];
}

- (void)reloadData{
    
    Provider *provider = [[GSE_Wallet shared] getProvider];
    
    __weak typeof(self) weakSelf = self;
    
    [[provider getBlockNumber] onCompletion:^(IntegerPromise *promise) {
        NSLog(@"blockNumber: %@",@(promise.value));
        if (!promise.result) {
            return ;
        }
        [GSE_Wallet shared].blockNumber = @(promise.value).stringValue;
        
        if ([weakSelf.transaction isKindOfClass:[NSDictionary class]]) {
            NSDictionary *info = weakSelf.transaction;
            NSString *blockNumber = info[@"blockNumber"];
            if (blockNumber && [blockNumber isKindOfClass:[NSString class]]) {
                weakSelf.blockConfirm = @(promise.value - blockNumber.integerValue).stringValue;
            }
        }
    }];
    if ([self.transaction isKindOfClass:[NSDictionary class]]) {
        /*Hash *hash = [Hash hashWithHexString:self.transaction[@"hash"]];
         
        [[provider getTransactionByHash:hash] onCompletion:^(DictionaryPromise *promise) {
            NSLog(@"%@",promise.value);
        }];
        [[provider getTransactionReceipt:hash] onCompletion:^(DictionaryPromise *promise) {
            NSLog(@"%@",promise.value);
        }];*/
    }
}

- (void)setBlockConfirm:(NSString *)blockConfirm{
    _blockConfirm = blockConfirm;
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:0 inSection:2] ] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 3;
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
        
        if ([self.transaction isKindOfClass:[TransactionInfo class]]) {
            TransactionInfo *info = self.transaction;
            
            [cell setTitle:NSLocalizedString(@"Amount",nil)];
            [cell setValue: self.isContract ? [Payment formatToken:info.value withDecimal:4] : [Payment formatEther:info.value] ];
            [cell setTxn_out:self.isTxnOut];
        }else if([self.transaction isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *info = self.transaction;
            
            if (indexPath.section == 0) {
                
                NSString *symbol = self.token[@"symbol"];
                [cell setTitle:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"Amount",nil), symbol]];
                
                NSString *quantity = info[@"quantity"];
                NSString *value = info[@"value"];
                
                if (!self.isContract && [value isKindOfClass:[NSString class]]) {
                    BigNumber *ether = [BigNumber bigNumberWithDecimalString:value];
                    value = [Payment formatEther:ether];
                }
                
                quantity = quantity ? : value;
                
                if (self.isTxnOut) {
                    [cell setValue:  [NSString stringWithFormat:@"-%@",quantity]];
                }else{
                    [cell setValue:  [NSString stringWithFormat:@"+%@",quantity]];
                }
                [cell setTxn_out:self.isTxnOut];
            }
        }
        
        return cell;
    }
    static NSString *identifier = @"GSE_Wallet_Txn_Detail_Cell";
    GSE_TxnDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GSE_TxnDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.accessoryView = nil;
    
    if ([self.transaction isKindOfClass:[TransactionInfo class]]) {
        TransactionInfo *info = self.transaction;
        
        if (indexPath.section == 0) {
            [cell setTitle:NSLocalizedString(@"Amount",nil)];
            [cell setValue: self.isContract ? [Payment formatToken:info.value withDecimal:4] : [Payment formatEther:info.value] ];
            [cell setLargeBlue:YES];
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                [cell setTitle:NSLocalizedString(@"From ",nil)];
                [cell setValue: info.fromAddress.checksumAddress];
            }else if (indexPath.row == 1){
                [cell setTitle:NSLocalizedString(@"To",nil)];
                [cell setValue: info.toAddress.checksumAddress];
            }else if (indexPath.row == 2){
                [cell setTitle:NSLocalizedString(@"Transaction Fee",nil)];
                [cell setValue: [Payment formatEther:[info.gasUsed mul:info.gasPrice]]];
            }
            [cell setLargeBlue:NO];
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                [cell setTitle:NSLocalizedString(@"Status",nil)];
                [cell setValue:NSLocalizedString(@"Success",nil)];
            }else if (indexPath.row == 1){
                [cell setTitle:NSLocalizedString(@"Time",nil)];
                [cell setValue:@(info.timestamp).stringValue];
            }else if (indexPath.row == 2){
                [cell setTitle:NSLocalizedString(@"TxHash",nil)];
                [cell setValue:[NSString stringWithFormat:@"%@",info.transactionHash.hexString]];
            }
            [cell setLargeBlue:NO];
        }
    }else if([self.transaction isKindOfClass:[NSDictionary class]]){
        /*{
            from = 0x8d12a197cb00d4747a1fe03395095ce2a5cc6819;
            timestamp = "13 days 15 hrs ago";
            to = 0xbdf766ff02e0b9b5df20daba365a1bc2bc02a22d;
            txn = 0x8bd4cfb3d4526d89e9e648e5ab61d3c0a438dfa876e19f041f16ae3609d07192;
            value = 10;
        }*/
        
        NSDictionary *info = self.transaction;
        
        if (indexPath.section == 0) {
            [cell setTitle:NSLocalizedString(@"Amount",nil)];
            //[cell setValue: info[@"value"] ];
            NSString *value = info[@"quantity"]?: info[@"value"];
            
            [cell setTxn_out:self.isTxnOut];
            [cell setValue: self.isTxnOut? [NSString stringWithFormat:@"-%@",value] : [NSString stringWithFormat:@"+%@",value] ];
            
            [cell setLargeBlue:YES];
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                [cell setTitle:NSLocalizedString(@"From",nil)];
                [cell setValue: info[@"from"]];
            }else if (indexPath.row == 1){
                [cell setTitle:NSLocalizedString(@"To",nil)];
                [cell setValue: info[@"to"]];
            }else if (indexPath.row == 2){
                
                BigNumber *fee = nil;
                NSString *gasPrice = info[@"gasPrice"];
                NSString *gasUsed = info[@"gasUsed"];
                NSString *gasLimit = info[@"gasLimit"];
                if ([gasPrice isKindOfClass:[NSString class]] &&
                    [gasUsed isKindOfClass:[NSString class]]) {
                    [cell setTitle:NSLocalizedString(@"Transaction Fee",nil)];
                    fee = [[BigNumber bigNumberWithDecimalString:gasUsed] mul:[BigNumber bigNumberWithDecimalString:gasPrice]];
                }else if([gasPrice isKindOfClass:[NSString class]] &&
                         [gasLimit isKindOfClass:[NSString class]]){
                    [cell setTitle:NSLocalizedString(@"Fee Estimation",nil)];
                    fee = [[BigNumber bigNumberWithDecimalString:gasLimit] mul:[BigNumber bigNumberWithDecimalString:gasPrice]];
                }else{
                    [cell setTitle:NSLocalizedString(@"Transaction Fee",nil)];
                }
                [cell setValue:  fee? [NSString stringWithFormat:@"%@ Ether",[Payment formatEther:fee]]: @"..."];
                cell.accessoryView = ({
                    CGRect frame = CGRectMake(0, 0, 100, 60);
                    UIView *view = [[UIView alloc] initWithFrame:frame];
                    //view.backgroundColor = [UIColor yellowColor];
                    {
                        UIButton *rebate = [[UIButton alloc] init];
                        [rebate setTitleColor:UIColorFromRGB(0x68b547) forState:UIControlStateNormal];
                        [rebate.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];

                        NSString *rebated = info[@"rebated"];
                        if (rebated && [rebated respondsToSelector:@selector(boolValue)] && rebated.boolValue) {
                            NSString *string = NSLocalizedString(@"100% Gas Rebated", nil);
                            [rebate setTitle:string forState:UIControlStateNormal];
                        }else{
                            NSString *string = NSLocalizedString(@"Get Gas Rebates", nil);
                            [rebate setTitle:string forState:UIControlStateNormal];
                        }
                        [rebate sizeToFit];
                        [rebate addTarget:self action:@selector(rebateAction:) forControlEvents:UIControlEventTouchUpInside];

                        rebate.frame = ({
                            CGRect frame = rebate.frame;
                            frame.origin.x = 0;
                            frame.origin.y = 37;
                            frame.size.width = 100;
                            frame.size.height = 22;
                            frame;
                        });
                        
                        if (rebated && [rebated respondsToSelector:@selector(boolValue)] && rebated.boolValue) {
                        }else{
                            [rebate.layer setMasksToBounds:YES];
                            [rebate.layer setBorderColor:UIColorFromRGB(0x85bb65).CGColor];
                            [rebate.layer setBorderWidth:1.0];
                            [rebate.layer setCornerRadius:CGRectGetHeight(rebate.bounds) / 2.0];
                        }
                        
                        [view addSubview:rebate];
                    }
                    view;
                });
            }else if (indexPath.row == 3){
                [cell setTitle:NSLocalizedString(@"Nonce",nil)];
                [cell setValue: info[@"nonce"]];
            }
            [cell setLargeBlue:NO];
        }else if (indexPath.section == 2){
            if (indexPath.row == 0) {
                [cell setTitle:NSLocalizedString(@"Status",nil)];
                NSString *status = info[@"status"]? NSLocalizedString(info[@"status"], nil) : NSLocalizedString(@"Success", nil);
                if ([status isEqualToString:NSLocalizedString(@"Success", nil)] && self.blockConfirm) {
                    status = [NSString stringWithFormat:@"%@ (%@ %@)",NSLocalizedString(@"Success", nil),self.blockConfirm,NSLocalizedString(@"Block Confirmations", nil)];
                }
                [cell setValue:status];
            }else if (indexPath.row == 1){
                [cell setTitle:NSLocalizedString(@"Time",nil)];
                NSString *age = info[@"age"];
                NSString *timestamp = info[@"timestamp"] ? :info[@"timeStamp"];
                if (timestamp) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
                    timestamp = [date deltaStringFromNow];
                }
                timestamp = timestamp?:age;
                
                [cell setValue:[timestamp localizeWithBlank]];
            }else if (indexPath.row == 2){
                [cell setTitle:NSLocalizedString(@"TxHash",nil)];
                [cell setValue:[NSString stringWithFormat:@"%@",info[@"hash"]]];
            }
            [cell setLargeBlue:NO];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 240 / 2.0;
    }
    return 60.0; //519 / 3.0 / 2.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 36 / 2.0;
    }
    if (section == 1) {
        return 36 / 2.0;
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
        CGFloat margin = [UIScreen iPhonePlus] ? 20 : 15;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGRect frame = CGRectMake(margin, height - 1, width - margin * 2 ,0.5); //450 / 2.0,
        UIView *separator = [[UIView alloc] initWithFrame:frame];
        separator.backgroundColor = UIColorFromRGB(0xdedede);
        [view addSubview:separator];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 2) {
        if ([self.transaction isKindOfClass:[TransactionInfo class]]) {
            TransactionInfo *info = self.transaction;
            NSString *url = [NSString stringWithFormat:@"%@",info.transactionHash.hexString];
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
            GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
            browser.customTitle = info.transactionHash.hexString;
            browser.url = [NSURL URLWithString:url];
            [self.navigationController pushViewController:browser animated:YES];
            
        }else if ([self.transaction isKindOfClass:[NSDictionary class]]){

            NSDictionary *info = self.transaction;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Copy TxHash", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                NSString *hash = info[@"hash"];
                pasteboard.string = hash;
                
                [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
                
                MBProgressHUD *hud = [self finishing:NSLocalizedString(@"Copied",nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Go Etherscan", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *hash = info[@"hash"];
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
}

#pragma mark - action

- (void)rebateAction:(UIButton *)sender{
    if (sender.layer.borderWidth != 0) {
        UITabBarController *barController = self.navigationController.tabBarController;
        if (self.isFromRebateHistory) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self.navigationController popToRootViewControllerAnimated:NO];
            [barController setSelectedIndex:1];
        }
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        NSMutableDictionary * event = [[GAIDictionaryBuilder
                                        createEventWithCategory:@"ui_action"
                                        action: self.isFromRebateHistory ? @"TxRecord_GetGasRebate": @"TxDetails_GetGasRebate"
                                        label:[GSE_Wallet shared].getClientid
                                        value:nil] build];
        NSLog(@"%@",event);
        [tracker send:event];
    }
}

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
