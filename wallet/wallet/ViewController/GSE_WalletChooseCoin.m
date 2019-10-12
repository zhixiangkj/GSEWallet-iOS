//
//  GSE_WalletTransferChooseCoin.m
//  wallet
//
//  Created by user on 29/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletChooseCoin.h"

@interface GSE_WalletTransferChooseCoin ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tokens;
@end

@implementation GSE_WalletTransferChooseCoin

- (void)viewDidLoad{
    
    self.title = NSLocalizedString(@"Choose Token",nil);
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    
    NSString *current = [[GSE_Wallet shared] getCurrentWallet];
    Address *address = [[GSE_Wallet shared] getAddressForWallet:current];
    
    NSDictionary *tokensInfo = [[GSE_Wallet shared] getTokensForAddress:address];
    if ([tokensInfo isKindOfClass:[NSArray class]]) {
        tokensInfo = @{@"tokens":tokensInfo};
    }else{
        
    }
    NSArray *tokens = [tokensInfo isKindOfClass:[NSDictionary class]] ? tokensInfo[@"tokens"] : nil;
    if (!tokens || !tokens.count) {
        tokens = @[@{@"name" : @"Ethereum (ETH)",@"symbol":@"ETH",@"decimals":@(18)}];
    }
    
    self.tokens = tokens;
    
    self.tableView = ({
        CGRect rect = CGRectMake(0, 0, width, height);
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect];
        tableView.separatorColor = UIColorFromRGB(0xeaeaea);
        tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
        tableView.tableFooterView = [UIView new];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    [self.contentView addSubview:self.tableView];
}

#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tokens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"GSE_Wallet_Transfer_Choose_Coin_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *token = self.tokens[indexPath.row];
    NSString *contract = token[@"contractAddress"];
    
    [cell.detailTextLabel setText:contract lineSpacing:0 wordSpacing:1];
    
    if (!self.token[@"contractAddress"] && !token[@"contractAddress"]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        if ([self.token[@"contractAddress"] isEqualToString:contract]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    NSString *name = token[@"name"];
    NSString *symbol = token[@"symbol"];
    
    if ([symbol isKindOfClass:[NSString class]]) {
        
        cell.imageView.image = [UIImage imageNamed:@"icon_default"];
        cell.textLabel.text = name ? :symbol;
        
        if ([symbol isEqualToString:@"GSE"]){
            cell.imageView.image = [UIImage imageNamed:@"icon_gse"];
        }else if ([symbol isEqualToString:@"ETH"]){
            cell.imageView.image = [UIImage imageNamed:@"icon_coin"];
        }
    }
    [cell.textLabel setText:cell.textLabel.text lineSpacing:0 wordSpacing:1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.token = self.tokens[indexPath.row];
    
    [self.tableView reloadData];
    
    if (self.finish) {
        self.finish(self.token);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
