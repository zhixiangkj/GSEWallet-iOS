//
//  GSE_WalletTransfer.m
//  wallet
//
//  Created by user on 30/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletTransfer.h"
#import "GSE_WalletScanner.h"
#import "GSE_WalletChooseCoin.h"
#import "GSE_WalletConfirmation.h"

#import "GSE_TransferCell.h"
#import "GSE_Rebate.h"


@interface GSE_WalletTransfer () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *coinLabel;
@property (nonatomic, strong) UITextField *amountTextField;
@property (nonatomic, strong) UITextField *toAddressTextField;
@property (nonatomic, strong) UIButton *continue_btn;

@property (nonatomic, strong) NSMutableDictionary *gasPriceInfo;

@property (nonatomic, assign) NSInteger gasLimit;
@property (nonatomic, strong) BigNumber * gasPrice;
@property (nonatomic, strong) Transaction *transaction;
@property (nonatomic, assign) CGFloat pUsd;
@property (nonatomic, assign) BOOL gasMenuOpen;

@property (nonatomic, strong) GSE_RebateCode *rebate;
@end

@implementation GSE_WalletTransfer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GSE_Wallet *shared = [GSE_Wallet shared];
    GSE_RebateCode *code = [[GSE_RebateCode alloc] init];
    [code addEntriesFromDictionray: [shared getRebateForClient:shared.getClientid]];
    self.rebate = code;
    
    self.title = NSLocalizedString(@"Transfer",nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackItem];
    self.hidesBottomBarWhenPushed = YES;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.6);
    
    if (!self.token) {
        
        Address *address = [[GSE_Wallet shared] getAddressForWallet:self.wallet];
        
        NSDictionary *tokensInfo = [[GSE_Wallet shared] getTokensForAddress:address];
        if ([tokensInfo isKindOfClass:[NSArray class]]) {
            tokensInfo = @{@"tokens":tokensInfo};
        }
        
        NSArray *tokens = [tokensInfo isKindOfClass:[NSDictionary class]] ? tokensInfo[@"tokens"] : nil;
        if (!tokens || !tokens.count) {
            tokens = @[@{@"name" : @"Ethereum (ETH)",@"symbol":@"ETH",@"decimals":@(18)}];
        }else{
            self.token = tokens.firstObject;
        }
    }
    
    self.tableView = ({
        CGRect rect = CGRectMake(0, 0, width, height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
        tableView.separatorColor = [UIColor clearColor];
        tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
        tableView.tableFooterView = [UIView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    [self.contentView addSubview:self.tableView];
    
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        tap.delegate = self;
        [self.contentView addGestureRecognizer:tap];
    }
    
    self.continue_btn = ({
        //CGFloat origin = 20;
        //CGRect rect = CGRectMake(MARGIN, origin, width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        CGFloat height = self.contentView.bounds.size.height;
        CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 - 50 : height - 104 * ratio - 36 - 50;
        CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
        
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
    //[self.contentView addSubview:self.continue_btn];
    self.tableView.tableFooterView = ({
        CGRect frame = CGRectMake(0, 0, width, (height - 70 * 2 - 158 / 2.0 - 92) * ratio);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        self.continue_btn.center = CGPointMake(width / 2.0, frame.size.height / 2.0);
        [view addSubview:self.continue_btn];
        view;
    });
    
    [self.tableView reloadData];
    [self refreshAction:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.amountTextField becomeFirstResponder];
}

- (void)reloadUI{
    self.pUsd = [[GSE_Wallet shared].prices[@"pUsd"] floatValue];
    NSDictionary *dic = [GSE_Wallet shared].prices[@"gas"];
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        self.gasPriceInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        NSString *Gwei = dic[@"standard"];
        NSString *wei = [NSString stringWithFormat:@"%.0lf",Gwei.doubleValue * pow(10, 9)];
        self.gasPrice = [BigNumber bigNumberWithDecimalString:wei];
        NSLog(@"%@,%@,%@",Gwei,wei,[Payment formatEther:self.gasPrice]);
    }
}

- (void)reloadData:( void (^)(void) ) finish{
    
    GSE_Wallet *wallet = [GSE_Wallet shared] ;
    Provider *provider = [wallet getProvider];
    
    Address *fromAddress = [[GSE_Wallet shared] getAddressForWallet:self.wallet];
    
    NSMutableDictionary * dic = @{@"address":fromAddress.checksumAddress.lowercaseString}.mutableCopy;
    NSString *contractAddress = self.token[@"contractAddress"];
    if (contractAddress) {
        [dic setObject:contractAddress forKey:@"contractAddress"];
    }
    
    NSString *clientid = [wallet getClientid];
    
    [dic setObject:clientid forKey:@"clientid"];
    
    [[provider getPrices:dic] onCompletion:^(DictionaryPromise * promise) {
        NSLog(@"%@",promise.result);
        if (!promise.result) {
            NSLog(@"%s,promise.result error",__FUNCTION__);
            if (finish) {
                finish();
            }
            return ;
        }
        NSMutableDictionary *value = promise.value.mutableCopy;
        NSDictionary *rebate = [value objectForKey:@"rebate"];
        NSLog(@"rebate: %@",rebate);
        if([rebate isKindOfClass:[NSDictionary class]] && rebate.count){
            [value removeObjectForKey:@"rebate"];
            wallet.prices = value;
            
            NSString *ok = rebate[@"ok"];
            if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
                if (finish) {
                    finish();
                }
                return;
            }
            NSDictionary *data = rebate[@"data"];
            if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                if(![data isKindOfClass:[NSString class]]){
                    if (finish) {
                        finish();
                    }
                    return;
                }
                NSString *base64 = (id)data;
                NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *decryptedData = [base64Data sign];
                data = [NSJSONSerialization JSONObjectWithData:decryptedData options:kNilOptions error:nil];
            }
            if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                if (finish) {
                    finish();
                }
                return;
            }
            NSLog(@"%@",data);
            
            [wallet storeRebate:data forClient:clientid];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"rebateChanged" object:nil];
        }
        
        if (finish) {
            finish();
        }
    }];
}

#pragma mark - delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        static NSString *identifier = @"GSE_Wallet_Transfer_Cell";
        
        GSE_TransferCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_TransferCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
            
            if (!self.onlyOne) {
                cell.accessoryView = ({
                    CGRect frame = CGRectMake(0, 0, 12, 70 / 2.0);
                    UIView *view = [[UIView alloc]  initWithFrame:frame];
                    //view.backgroundColor = [UIColor yellowColor];
                    UIImage *image = [UIImage imageNamed:@"gas_arrow_right"];
                    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                    imageView.center = CGPointMake(6, 70 / 4.0 + 1);
                    [view addSubview:imageView];
                    view;
                });
            }
        }
        
        if (!self.token[@"contractAddress"]) {
            [cell.imageView setImage:[UIImage imageNamed:@"icon_coin"]];
            [cell.textLabel setText:@"ETH"];
        }else{
            NSString *name = self.token[@"name"];
            NSString *symbol = self.token[@"symbol"];
            
            [cell.imageView setImage:[UIImage imageNamed:@"icon_default"]];
            [cell.textLabel setText: symbol? :name];
            
            if ([symbol isEqualToString:@"GSE"]) {
                [cell.imageView setImage:[UIImage imageNamed:@"icon_gse"]];
                [cell.textLabel setText:@"GSE"];
            }
        }
        [cell.textLabel setText:cell.textLabel.text lineSpacing:0 wordSpacing:1];
        if (!self.onlyOne) {
            [cell.detailTextLabel setText:NSLocalizedString(@"Change Token",nil) lineSpacing:0 wordSpacing:1];
        }
        
        cell.showSeparator = YES;
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.coinLabel = cell.textLabel;
        return cell;
    }
    
    if (indexPath.row == 1) {
        
        static NSString *identifier = @"GSE_Wallet_Transfer_TextField_Cell";
        
        GSE_TransferTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_TransferTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textField.delegate = self;
        }
        [cell.textField setPlaceholder:NSLocalizedString(@"Enter the transfer amount",nil) color:UIColorFromRGB(0x999999) wordSpacing:1];
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        
        if (self.amountTextField.text) {
            cell.textField.text = self.amountTextField.text;
        }
        self.amountTextField = cell.textField;
        return cell;
    }
    
    if (indexPath.row == 2) {
        
        static NSString *identifier = @"GSE_Wallet_Transfer_TextField_QR_Cell";
        
        GSE_TransferTextFieldQRCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_TransferTextFieldQRCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.textField.delegate = self;
        }
        [cell setBalance: self.token[@"quantity"] ? :@"0"];
        [cell.textField setPlaceholder:NSLocalizedString(@"Enter the destination address",nil) color:UIColorFromRGB(0x999999) wordSpacing:1.2];
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.delegate = self;
        
        if (self.toAddressTextField.text) {
            cell.textField.text = self.toAddressTextField.text;
        }
        
        self.toAddressTextField = cell.textField;
        return cell;
    }
    
    if (indexPath.row == 3) {
        
        static NSString *identifier = @"GSE_Wallet_Transfer_Cell_2";
        
        GSE_TransferGasCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_TransferGasCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
            
            cell.accessoryView = ({
                CGRect frame = CGRectMake(0, 0, 12, 92 / 2.0);
                UIView *view = [[UIView alloc]  initWithFrame:frame];
                //view.backgroundColor = [UIColor yellowColor];
                UIImage *image = [UIImage imageNamed:@"gas_arrow_right"];
                UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
                imageView.center = CGPointMake(6, 92 / 4.0 + 1);
                imageView.tag = 1000;
                [view addSubview:imageView];
                view;
            });
            if (![cell viewWithTag:1001]) {
                UIButton *button = [[UIButton alloc] init];
                [button setTitleColor:UIColorFromRGB(0x68b547) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
                button.tag = 1001;
                [button addTarget:cell action:@selector(rebateAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
            }
            if (![cell viewWithTag:1002]) {
                UIImage *image = [UIImage imageNamed:@"rebate_tip_back"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.tag = 1002;
                imageView.center = CGPointMake(self.view.bounds.size.width - 23 - image.size.width / 2.0, 120);
                {
                    CGRect rect = CGRectMake(15, 8, image.size.width - 25, image.size.height - 10);
                    UILabel *label = [[UILabel alloc] initWithFrame:rect];
                    label.textColor = UIColorFromRGB(0x666666);
                    label.font = [UIFont systemFontOfSize:10];
                    label.numberOfLines = 0;
                    //label.backgroundColor = [UIColor yellowColor];
                    label.text = NSLocalizedString(@"Gas fee is ETH transaction fee.\nReceive GSE as rebate for your\ngas fee.", nil);
                    [label setText:label.text lineSpacing:3 wordSpacing:0];
                    [imageView addSubview:label];
                }
                imageView.alpha = 0;
                [cell addSubview:imageView];
            }
        }
        //cell.showSeparator = NO;
        if ([UIScreen mainScreen].bounds.size.width <= 320) {
            [cell.textLabel setText:NSLocalizedString(@"Fee",nil) lineSpacing:0 wordSpacing:1];
        }else{
            [cell.textLabel setText:NSLocalizedString(@"Fee Estimation",nil) lineSpacing:0 wordSpacing:1];
        }
        
        if (!self.gasPriceInfo) {
            [cell.detailTextLabel setText:NSLocalizedString(@"Loading...",nil) lineSpacing:0 wordSpacing:1];
        }else{
            double ether = [Payment formatEther:self.gasPrice].doubleValue * self.gasLimit;
            double usd = ether * self.pUsd;
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%.7f Ether ~ $%.2f", ether,usd] lineSpacing:0 wordSpacing:1];
        }
        UIView *indicator = [cell viewWithTag:1000];
        //NSLog(@"gas menu open: %@", self.gasMenuOpen ? @"YES" : @"NO");
        indicator.transform = self.gasMenuOpen ?  CGAffineTransformMakeRotation(M_PI / 2.0) : CGAffineTransformIdentity;
        
        UIButton *rebate = (id)[cell viewWithTag:1001];
        rebate.hidden = self.gasMenuOpen;
        cell.delegate = self;
        
        UIView *tip = [cell viewWithTag:1002];
        tip.alpha = 0;
        
        if (!self.gasMenuOpen) {

            if (self.rebate.rebates.integerValue > 0) {
                NSString *string = [NSString stringWithFormat:NSLocalizedString(@"Remaining Gas Rebates: %@", nil),self.rebate.rebates];
                [rebate setTitle:string forState:UIControlStateNormal];
                [rebate setImage:[UIImage imageNamed:@"rebate_count_tip"] forState:UIControlStateNormal];
                [rebate sizeToFit];
                [rebate alignImageToRightWithGap:10];
                /*rebate.imageEdgeInsets = ({
                    UIEdgeInsets insets = rebate.imageEdgeInsets;
                    insets.top = -1;
                    insets;
                });*/
                rebate.center = CGPointMake(self.view.bounds.size.width - CGRectGetWidth(rebate.bounds) / 2.0  - 15, 153 / 2.0);
            }else{
                
                NSString *string = NSLocalizedString(@"Get Gas Rebates", nil);
                [rebate setTitle:string forState:UIControlStateNormal];
                [rebate sizeToFit];
                
                rebate.frame = ({
                    CGRect frame = rebate.frame;
                    frame.size.width = 100;
                    frame.size.height = 22;
                    frame;
                });
                
                [rebate.layer setMasksToBounds:YES];
                [rebate.layer setBorderColor:UIColorFromRGB(0x85bb65).CGColor];
                [rebate.layer setBorderWidth:1.0];
                [rebate.layer setCornerRadius:CGRectGetHeight(rebate.bounds) / 2.0];
                
                rebate.center = CGPointMake(self.view.bounds.size.width - CGRectGetWidth(rebate.bounds) / 2.0  - 15, 153 / 2.0 + 4);
            }
        }
        return cell;
    }
    
    if (indexPath.row == 4) {        
        if (self.gasMenuOpen) {
            static NSString *identifier = @"GSE_Wallet_Transfer_Slider_Cell";
            GSE_TransferSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[GSE_TransferSliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            cell.delegate = self;
            [cell setEtherchainData:self.gasPriceInfo];
            return cell;
        }else{
            static NSString *identifier = @"GSE_Wallet_Transfer_Slider_Cell_Closed";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 70;
    }
    if (indexPath.row == 1) {
        return 70;
    }
    if (indexPath.row == 2) {
        return 158 / 2.0;
    }
    if (indexPath.row == 3) {
        return 92;
    }
    if (indexPath.row == 4) {
        if (self.gasMenuOpen) {
            return 100;
        }
        return 0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        if (self.onlyOne) {
            return;
        }
        GSE_WalletTransferChooseCoin *chooseCoin = [[GSE_WalletTransferChooseCoin alloc] init];
        chooseCoin.token = self.token;
        
        __weak typeof(self) weakSelf = self;
        [chooseCoin setFinish:^(NSDictionary * token) {
            weakSelf.token = token;
        }];
        [self.navigationController pushViewController:chooseCoin animated:YES];
    }else if (indexPath.row == 3) {
        
        [self.amountTextField resignFirstResponder];
        [self.toAddressTextField resignFirstResponder];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        UIView *indicator = [cell viewWithTag:1000];
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            indicator.transform = self.gasMenuOpen ? CGAffineTransformIdentity: CGAffineTransformMakeRotation(M_PI / 2.0);
        } completion:^(BOOL finished) {

        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.gasMenuOpen = !self.gasMenuOpen;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:4 inSection:0];
            [tableView reloadRowsAtIndexPaths:@[indexPath,indexPath1] withRowAnimation:UITableViewRowAnimationFade];
        });
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.continue_btn.enabled = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.continue_btn.enabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.amountTextField) {
        [self.amountTextField resignFirstResponder];
        [self.toAddressTextField becomeFirstResponder];
    }else if (textField == self.toAddressTextField){
        [self.amountTextField resignFirstResponder];
        [self.toAddressTextField resignFirstResponder];
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint point = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    if (!indexPath || indexPath.row >= 4) {
        return YES;
    }
    return NO;
}

#pragma mark - action

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.amountTextField resignFirstResponder];
    [self.toAddressTextField resignFirstResponder];
}

- (void)nextAction:(id)sender{
    
    Address *fromAddress = [[GSE_Wallet shared] getAddressForWallet:self.wallet];
    
    NSLog(@"%@,%@",self.wallet,fromAddress);
    
    if (!fromAddress) {
        [self alertTitle:NSLocalizedString(@"Invalid Transfer Address",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    if (!self.amountTextField.text.length || self.amountTextField.text.doubleValue <= 0 || ![Payment parseEther:self.amountTextField.text]) {
        NSLog(@"%@",[Payment parseEther:self.amountTextField.text]);
        [self alertTitle:NSLocalizedString(@"Invalid Transfer Amount",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    Address *toAddress = [Address addressWithString:[self.toAddressTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    if (!toAddress) {
        [self alertTitle:NSLocalizedString(@"Invalid Transfer Address",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    BigNumber *gasLimit = [BigNumber bigNumberWithInteger:self.gasLimit];
    if (!gasLimit) {
        [self alertTitle:NSLocalizedString(@"Invalid gasLimit",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    if (!self.gasPrice) {
        [self alertTitle:NSLocalizedString(@"Invalid gasPrice",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }
    
    /*BigNumber *balance = [[GSE_Wallet shared] getEtherBalance];
    NSLog(@"balance: %@, fee estimated: %@",balance,[gasLimit mul:self.gasPrice]);
    if (!balance || [[gasLimit mul:self.gasPrice] greaterThan:balance]) {
        [self alertTitle:NSLocalizedString(@"Insufficient ETH balance",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
        return;
    }*/

    Transaction * transaction = [Transaction transactionWithFromAddress:fromAddress];
    
    transaction.gasLimit = gasLimit;
    transaction.gasPrice = self.gasPrice;
    transaction.chainId = [GSE_Wallet shared].chainId;

    __weak typeof(self) weakSelf = self;
    
    MBProgressHUD *hud = [self loading];
    
    Provider *provider = [[GSE_Wallet shared] getProvider];
    
    // Set some text to show the initial status.
    hud.label.text = NSLocalizedString(@"Preparing...",nil);
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 120.f);
    
    NSMutableDictionary * dic = @{@"address":fromAddress.checksumAddress.lowercaseString}.mutableCopy;
    NSString *contractAddress = self.token[@"contractAddress"];
    if (contractAddress) {
        [dic setObject:contractAddress forKey:@"contractAddress"];
    }
    
    [[provider getNonce:dic] onCompletion:^(DictionaryPromise * promise) {
        NSLog(@"%@",promise.result);
        if (!promise.result) {
            [weakSelf loadingFinish];
            [weakSelf alertTitle:NSLocalizedString(@"Network Error",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
            return ;
        }
        NSDictionary *nonceDic = promise.value;
        
        NSString *nonce = nonceDic[@"nonce"];
        
        if (!nonce || ![nonce isKindOfClass:[NSString class]]) {
            [weakSelf loadingFinish];
            [weakSelf alertTitle:NSLocalizedString(@"Network Error",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
            return;
        }
        transaction.nonce = nonce.integerValue;
        
        NSString *ethString = nonceDic[@"eth"];
        
        BigNumber *eth = [[GSE_Wallet shared] getEtherBalance];
        
        if ([ethString isKindOfClass:[NSString class]]) {
            eth = [BigNumber bigNumberWithDecimalString:ethString];
        }
        
        if ([[gasLimit mul:weakSelf.gasPrice] greaterThan:eth]) {
            [weakSelf loadingFinish];
            [weakSelf alertTitle:NSLocalizedString(@"Insufficient ETH balance",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
            return;
        }
        
        NSString *contractString = weakSelf.token[@"contractAddress"];
        
        if ([contractString isKindOfClass:[NSString class]]) {
            Address *contract = [Address addressWithString:contractString];
            
            if (!contract) {
                [weakSelf loadingFinish];
                [weakSelf alertTitle:NSLocalizedString(@"Invalid Contract Address",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                return;
            }
            
            NSString *decimalString = weakSelf.token[@"decimals"];
            if (decimalString && [decimalString respondsToSelector:@selector(integerValue)]) {
                [weakSelf loadingFinish];
                BigNumber *value =  [Payment parseToken:weakSelf.amountTextField.text withDecimal:decimalString.integerValue];
                
                BigNumber *balance =  weakSelf.token[@"value"] ? [BigNumber bigNumberWithDecimalString:weakSelf.token[@"value"]] : [Payment parseToken:weakSelf.token[@"quantity"] withDecimal:decimalString.integerValue];
                
                NSString *balanceString = nonceDic[@"balance"];
                if([balanceString isKindOfClass:[NSString class]]){
                    balance = [BigNumber bigNumberWithDecimalString:balanceString];
                }
                NSLog(@"%@,%@",value,balance);
                if ([value greaterThan:balance]) {
                    [weakSelf alertTitle:[NSString stringWithFormat:NSLocalizedString(@"Insufficient %@ balance",nil),weakSelf.token[@"symbol"]?:@""] withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                    return;
                }
                
                [weakSelf confirmAction:transaction fromAddress:fromAddress toAddress:toAddress isContract:YES value:value];
                return;
            }
            
            Transaction *decimals = [Transaction transaction];
            
            NSString * transferMethod = @"decimals()";
            NSData * transferSignature = [SecureData KECCAK256:[transferMethod dataUsingEncoding:NSUTF8StringEncoding]];
            
            transferSignature = [transferSignature subdataWithRange:NSMakeRange(0, 4)];
            NSLog(@"transfer signature: %@",transferSignature);
            
            decimals.data = transferSignature;
            decimals.toAddress = contract;
            
            [[provider call:decimals] onCompletion:^(DataPromise * promise) {
                NSLog(@"%@",promise.value);
                if (!promise.result) {
                    [weakSelf loadingFinish];
                    [weakSelf alertTitle:NSLocalizedString(@"Network Error",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
                    return;
                }
                [weakSelf loadingFinish];
                
                BigNumber *decimalNumber = [BigNumber bigNumberWithData:promise.value];
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:weakSelf.token];
                [dic setObject:@(decimalNumber.integerValue).stringValue forKey:@"decimals"];
                weakSelf.token = dic;
                
                BigNumber *decimal = [BigNumber bigNumberWithData:promise.value];
                BigNumber *value =  [Payment parseToken:weakSelf.amountTextField.text withDecimal:decimal.unsignedIntegerValue];
                [weakSelf confirmAction:transaction fromAddress:fromAddress toAddress:toAddress isContract:YES value:value];
                
            }];
            return;
        }
        
        [weakSelf loadingFinish];
        
        BigNumber *value = [Payment parseEther:weakSelf.amountTextField.text];
        if ([[value add:[gasLimit mul:self.gasPrice]] greaterThan:eth]) {
            [weakSelf alertTitle:NSLocalizedString(@"Insufficient ETH balance",nil) withMessage:nil buttonTitle:NSLocalizedString(@"OK",nil) finish:nil];
            return;
        }
        
        [weakSelf confirmAction:transaction fromAddress:fromAddress toAddress:toAddress isContract:NO value:value];
        
    }];
}

- (void)confirmAction:(Transaction *)transaction fromAddress:(Address *)fromAddress toAddress:(Address *)toAddress isContract:(BOOL)isContract value:(BigNumber *)value{
    
    [self loadingFinish];
    
    GSE_WalletTransferConfirmation *confirm = [[GSE_WalletTransferConfirmation alloc] init];
    confirm.transaction = transaction;
    confirm.fromAddress = fromAddress;
    confirm.toAddress = toAddress;
    confirm.token = self.token;
    confirm.value = value;
    confirm.wallet = self.wallet;
    confirm.isContract = isContract;
    confirm.isTxnOut = YES;
    [self.navigationController pushViewController:confirm animated:YES];
    
}

- (void)sliderDidChangeAction:(UISlider *)slider{
    NSString *Gwei = @(slider.value).stringValue;
    [self.gasPriceInfo setObject:Gwei forKey:@"standard"];
    NSString *wei = [NSString stringWithFormat:@"%.0lf",Gwei.doubleValue * pow(10, 9)];
    self.gasPrice = [BigNumber bigNumberWithDecimalString:wei];
}

- (void)qrCodeAction:(id)sender{
    __weak typeof(self) weakSelf = self;
    
    [self.amountTextField resignFirstResponder];
    [self.toAddressTextField resignFirstResponder];
    
    GSE_WalletScanner *scanner = [[GSE_WalletScanner alloc] init];
    [scanner setFinish:^(NSString *address) {
        weakSelf.toAddressTextField.text = address;
    }];
    [self.navigationController pushViewController:scanner animated:YES];
}

- (void)refreshAction:(id)sender{
    __weak typeof(self) weakSelf = self;
    [self reloadData:^{
        [weakSelf reloadUI];
    }];
}

- (void)rebateAction:(GSE_TransferGasCell *)cell{
    
    if (self.rebate.rebates.integerValue > 0) {
        UIView *tip = [cell viewWithTag:1002];
        if (tip) {
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                tip.alpha = 1.0 - tip.alpha;
            } completion:^(BOOL finished) {
                
            }];
        }
    }else{
        UITabBarController *tabController = self.navigationController.tabBarController;
        [self.navigationController popViewControllerAnimated:NO];
        [tabController setSelectedIndex:1];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        NSMutableDictionary * event = [[GAIDictionaryBuilder
                                        createEventWithCategory:@"ui_action"
                                        action:@"Transfer_GetGasRebate"
                                        label:[GSE_Wallet shared].getClientid
                                        value:nil] build];
        NSLog(@"%@",event);
        [tracker send:event];
    }
}

#pragma mark - get

- (NSInteger)gasLimit{
    if ([self.gasPriceInfo isKindOfClass:[NSDictionary class]]) {
        NSInteger contract = [self.gasPriceInfo[@"limit"][@"contract"] integerValue];
        if (!contract) {
            contract = 60000;
        }
        NSInteger eth = [self.gasPriceInfo[@"limit"][@"eth"] integerValue];
        if (!eth) {
            eth = 30000;
        }
        return (self.token[@"contractAddress"] ?  contract: eth);
    }
    return (self.token[@"contractAddress"] ? 60000 : 30000);
}

#pragma mark - set

- (void)setToken:(NSDictionary *)token{
    _token = token;
    
    [self.tableView beginUpdates];
    NSArray *array = @[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0]];
    [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

- (void)setGasPrice:(BigNumber *)gasPrice{
    _gasPrice = gasPrice;
    
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}

#pragma mark - scrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.amountTextField.isFirstResponder) {
        [self.amountTextField resignFirstResponder];
    }
    if (self.toAddressTextField.isFirstResponder) {
        [self.toAddressTextField resignFirstResponder];
    }
}

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

