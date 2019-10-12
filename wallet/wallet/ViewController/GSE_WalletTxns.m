//
//  GSE_WalletTransaction.m
//  wallet
//
//  Created by user on 28/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletTxns.h"
#import "GSE_WalletTxnDetail.h"

#import "GSE_TxnsCell.h"

#import "GSE_WalletTransfer.h"
#import "GSE_WalletReceiver.h"

@interface GSE_WalletTxns () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *transactions;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *total;
@property (nonatomic, strong) UILabel *total_usd;
@property (nonatomic, strong) UIButton *send;
@property (nonatomic, strong) UIButton *receive;

@property (nonatomic, assign) CGFloat footerHeight;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation GSE_WalletTxns

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.name? :self.symbol;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    [self setBackItem];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat margin = [UIScreen iPhonePlus] ? 19 : 14;
    
    self.contentView.backgroundColor = UIColorFromRGB(0xfdfdfd);
    
    self.header = ({
        CGRect rect = CGRectMake(0, 0, width, 240);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = UIColorFromRGB(0xfdfdfd);
        view;
    });
    
    {
        CGRect rect = CGRectMake(margin, margin, width - margin * 2, 240 - margin);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.layer.cornerRadius = 5;
        view.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        view.layer.borderWidth = 0.5f;
        [self.header addSubview:view];
    }
    //[self.view addSubview:self.header];
    
    {
        NSString *name = [self.symbol isEqualToString:@"GSE"] ? @"token_gse" : ([self.symbol isEqualToString:@"ETH"] ? @"icon_coin" :@"icon_default") ;
        UIImage *image = [UIImage imageNamed: name];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(width /2.0, 110 / 2.0);
        [self.header addSubview:imageView];
    }
    
    self.total = ({
        UILabel * label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x333333);
        [label setText:self.token[@"quantity"] ? : @"0.0000" lineSpacing:0 wordSpacing:1];
        label.font = [UIFont systemFontOfSize:24];
        [label sizeToFit];
        if (label.bounds.size.width > 180) {
            CGRect frame = label.frame;
            frame.size.width = 180;
            label.frame = frame;
        }
        label.center = CGPointMake(width / 2.0, 210 / 2.0);
        label;
    });
    [self.header addSubview:self.total];
    
    self.total_usd = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0xbdbdbd);
        [label setText:self.token[@"valueInUSD"] ? : @"$ 0.00" lineSpacing:0 wordSpacing:1];
        label.font = [UIFont systemFontOfSize:12];
        [label setText:label.text lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        if (label.bounds.size.width > 180) {
            CGRect frame = label.frame;
            frame.size.width = 180;
            label.frame = frame;
        }
        label.center = CGPointMake(self.total.center.x, self.total.center.y + 30);
        label;
    });
    [self.header addSubview:self.total_usd];
    
    self.send = ({
        CGRect rect = CGRectMake(0, 0, 120, 44);
        UIButton * button = [[UIButton alloc] initWithFrame:rect];
        button.layer.cornerRadius = rect.size.height / 2.0;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"menu_send"];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        [button setTitle:NSLocalizedString(@"  Transfer",nil) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake(width / 2.0 - 150 / 2.0, 370 / 2.0);
        button;
    });
    [self.header addSubview:self.send];
    
    self.receive = ({
        CGRect rect = CGRectMake(0, 0, 120, 44);
        UIButton * button = [[UIButton alloc] initWithFrame:rect];
        button.layer.cornerRadius = rect.size.height / 2.0;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"menu_receive"];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
        [button setTitle:NSLocalizedString(@"  Receive",nil) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        button.center = CGPointMake(width / 2.0 + 150 / 2.0, 370 / 2.0);
        [button addTarget:self action:@selector(receiveAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.header addSubview:self.receive];
    
    [self.contentView addSubview:self.header];

    self.tableView = ({
        CGFloat originY = self.header.frame.origin.y + self.header.frame.size.height + 10; //0;
        CGRect rect = CGRectMake(0, originY, width, height - originY);
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        //tableView.tableHeaderView = self.header;
        
        self.footerHeight = (height - originY) / 2.0 ; //- self.header.bounds.size.height
        
        tableView.tableFooterView = ({
            CGRect rect = CGRectMake(0, 0, width, self.footerHeight);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            {
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = UIColorFromRGB(0xbdbdbd);
                label.font = [UIFont systemFontOfSize:15];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = NSLocalizedString(@"Loading...",nil);
                [label setText:label.text lineSpacing:0 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake(width / 2.0f, rect.size.height / 3.0 * 2);
                [view addSubview:label];
            }
            view;
        });
        tableView.backgroundColor = UIColorFromRGB(0xfdfdfd);
        tableView.separatorColor = UIColorFromRGB(0xeaeaea);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        tableView;
    });
    [self.contentView addSubview:self.tableView];
    
    {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        refreshControl.transform = CGAffineTransformMakeScale(0.8, 0.8);
        refreshControl.tintColor = UIColorFromRGB(0xdbdbdb);
        //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
        [self.tableView addSubview:refreshControl];
    }
    
    __weak typeof(self) weakSelf = self;
    Address * address = self.address;
    NSArray *array = [[GSE_Wallet shared] getTxnsForAddress:address atContract:self.contract];
    if (array.count) {
        weakSelf.transactions = [NSMutableArray arrayWithArray:array];
        [weakSelf.tableView reloadData];
        [weakSelf reloadFooter];
    }
    [self.tableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height)];
    [self.refreshControl beginRefreshing];
    [self refreshAction:self.refreshControl];
}

- (void)reloadFooter{
    if (!self.transactions.count) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.tableView.tableFooterView = ({
            CGRect rect = CGRectMake(0, 0, width, self.footerHeight);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            {
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = UIColorFromRGB(0xbdbdbd);
                label.font = [UIFont systemFontOfSize:15];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = NSLocalizedString(@"Could not find transactions\nMaybe it's on da moon...",nil);
                [label setText:label.text lineSpacing:0 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake(width / 2.0f, rect.size.height / 3.0 * 2 );
                [view addSubview:label];
            }
            view;
        });
    }else{
        self.tableView.tableFooterView = [UIView new];
    }
    if (self.refreshControl.isRefreshing) {
        [self.refreshControl endRefreshing];
    }
}

- (void)reloadData{
    [self reloadData:nil];
}

- (void)reloadData:(void(^)(void))finish{ //
    
    __weak typeof(self) weakSelf = self;
    
    Address * address = self.address;
    Provider * provider = [[GSE_Wallet shared] getProvider];
    if (!self.contract) {
        ArrayPromise *transactionPromise = [provider getTxns:@{@"address":address.checksumAddress.lowercaseString}];
        [transactionPromise onCompletion:^(ArrayPromise *promise) {
            if (!promise.result || promise.error) {
                [weakSelf reloadFooter];
                if (finish) {
                    finish();
                }
                return;
            }
            NSLog(@"%@",promise.value);
            
            [[GSE_Wallet shared] storeTxns:promise.value forAddress:address atContract:weakSelf.contract];
            weakSelf.transactions = [NSMutableArray arrayWithArray:promise.value];
            [weakSelf.tableView reloadData];
            [weakSelf reloadFooter];
            if (finish) {
                finish();
            }
        }];
    }else{
        ArrayPromise *transactionPromise = [provider getTxns:@{@"address":address.checksumAddress.lowercaseString,@"contractAddress":_contract.checksumAddress.lowercaseString}];
        NSLog(@"%@",self.contract);
        //ArrayPromise *transactionPromise = [provider getTransactions:address atContract:self.contract page:1 count:10];
        [transactionPromise onCompletion:^(ArrayPromise *promise) {
            if (!promise.result || promise.error) {
                NSLog(@"%@",promise.error);
                [weakSelf reloadFooter];
                if (finish) {
                    finish();
                }
                return;
            }
            NSLog(@"%@",promise.value);
            [[GSE_Wallet shared] storeTxns:promise.value forAddress:address atContract:weakSelf.contract];
            weakSelf.transactions = [NSMutableArray arrayWithArray:promise.value];
            [weakSelf.tableView reloadData];
            [weakSelf reloadFooter];
            if (finish) {
                finish();
            }
        }];
    }
}

- (void)setToken:(NSDictionary *)token{
    _token = token;
    if (self.total && self.total_usd) {
        UILabel *label = self.total;
        CGPoint center = label.center;
        [label setText:self.token[@"quantity"] ? : @"0.0000" lineSpacing:0 wordSpacing:1];
        label.font = [UIFont systemFontOfSize:24];
        [label sizeToFit];
        if (label.bounds.size.width > 180) {
            CGRect frame = label.frame;
            frame.size.width = 180;
            label.frame = frame;
        }
        label.center = center;
        
        label = self.total_usd;
        center = label.center;
        [label setText:self.token[@"valueInUSD"] ? : @"$ 0.00" lineSpacing:0 wordSpacing:1];
        label.font = [UIFont systemFontOfSize:12];
        [label setText:label.text lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        if (label.bounds.size.width > 180) {
            CGRect frame = label.frame;
            frame.size.width = 180;
            label.frame = frame;
        }
        label.center = center;
    }
}

#pragma mark - delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.transactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"GSE_Wallet_Transaction_Cell";
    GSE_TxnsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GSE_TxnsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = UIColorFromRGB(0xfdfdfd);
    }
    NSDictionary *info = self.transactions[indexPath.row];
    
    if ([info isKindOfClass:[NSDictionary class]]) {
        
        NSString *from = info[@"from"];
        NSString *to = info[@"to"];
        NSString *value = info[@"value"];
        NSString *age = info[@"age"];
        NSString *status = info[@"status"]? NSLocalizedString(info[@"status"], nil) : NSLocalizedString(@"Success", nil);
        
        NSString *timestamp = info[@"timestamp"] ? :info[@"timeStamp"];
        
        if (timestamp) {
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
            timestamp = [date deltaStringFromNow];
        }
        timestamp = timestamp?:age;
        
        NSString *quantity = info[@"quantity"];
        if (!self.contract && [value isKindOfClass:[NSString class]]) {
            BigNumber *ether = [BigNumber bigNumberWithDecimalString:value];
            value = [Payment formatEther:ether];
        }
        quantity = quantity ? : value;

        [cell setStatus:status];
        //trasfer out
        BOOL txn_out = [from.lowercaseString isEqualToString:self.address.checksumAddress.lowercaseString];
        [cell setTxn_out:txn_out];
        [cell setAddress: txn_out ? to: from];
        [cell setValue: txn_out? [NSString stringWithFormat:@"-%@",quantity] : [NSString stringWithFormat:@"+%@",quantity] ];
        [cell setTimestamp: [timestamp localizeWithBlank]];
        
    }else if ([info isKindOfClass:[TransactionInfo class]]){
        
        TransactionInfo *_info = (TransactionInfo *)info;
        
        //trasfer out
        BOOL txn_out = [_info.fromAddress.checksumAddress.lowercaseString isEqualToString:self.address.checksumAddress.lowercaseString];
        
        [cell setTxn_out:txn_out];
        [cell setAddress: txn_out ? _info.toAddress.checksumAddress : _info.fromAddress.checksumAddress];
        NSString *token = [Payment formatToken:_info.value withDecimal:4];
        [cell setValue: txn_out? [NSString stringWithFormat:@"-%@",token] : [NSString stringWithFormat:@"+%@",token] ];
        [cell setTimestamp:@(_info.timestamp).stringValue];
        [cell setStatus:NSLocalizedString(@"Success",nil)];
    }
    
    /*
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = info.description;
     */
    
    /*
    if ([info.fromAddress.checksumAddress.lowercaseString isEqualToString:self.address.checksumAddress.lowercaseString]) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"-%@",[Payment formatEther:info.value]];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"+%@",[Payment formatEther:info.value]];
    }*/
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GSE_WalletTxnDetail *detail = [[GSE_WalletTxnDetail alloc] init];
    
    NSDictionary *_info = self.transactions[indexPath.row];
    
    if ([_info isKindOfClass:[NSDictionary class]]) {
        NSString *from = _info[@"from"];
        detail.isTxnOut = [from.lowercaseString isEqualToString:self.address.checksumAddress.lowercaseString];
    }
    else if ([_info isKindOfClass:[TransactionInfo class]]){
        
        TransactionInfo *info = (TransactionInfo *)_info;
        
        //trasfer out
        detail.isTxnOut = [info.fromAddress.checksumAddress.lowercaseString isEqualToString:self.address.checksumAddress.lowercaseString];
        
    }
    detail.transaction = _info;
    detail.token = self.token;
    detail.isContract = self.contract ? YES : NO;
    
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - action

- (void)refreshAction:(UIRefreshControl *)sender{
    [self reloadData];
}
- (void)sendAction:(id)sender{
    GSE_WalletTransfer *transfer = [[GSE_WalletTransfer alloc] init];
    NSString *current = [[GSE_Wallet shared] getCurrentWallet];
    transfer.wallet = current;
    transfer.onlyOne = YES;
    transfer.token = self.token;
    [self.navigationController pushViewController:transfer animated:YES];
}

- (void)receiveAction:(id)sender{
    GSE_WalletReceiver *transfer = [[GSE_WalletReceiver alloc] init];
    NSString *current = [[GSE_Wallet shared] getCurrentWallet];
    transfer.wallet = current;
    [self.navigationController pushViewController:transfer animated:YES];
}

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
