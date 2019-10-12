//
//  GSE_WalletRebateHistory.m
//  GSEWallet
//
//  Created by user on 06/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletRebateHistory.h"
#import "GSE_RebateController.h"

#import "GSE_Rebate.h"
#import "GSE_SpinnerCell.h"
#import "GSE_WalletTxnDetail.h"

@interface GSE_WalletRebateHistory ()<IGListAdapterDataSource, UIScrollViewDelegate, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) NSString *menuView;
@property (nonatomic, strong) NSString *spiningToken;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *emptyLabel;
@end

@implementation GSE_WalletRebateHistory

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"My Gas Rebates",nil);
    
    self.items = @[].mutableCopy;
    
    self.spiningToken = @"loadingView";
    self.menuView = @"menuView";
    self.hidesBottomBarWhenPushed = YES;
    
    
    /*
    [self.items addObject:self.menuView];
    NSMutableArray * array = @[].mutableCopy;
    for (NSInteger i = 0; i < 10; i++) {
        NSDictionary *dic = @{
                              @"hash" : @"0xd39682461c86f31804e79e48e4b76bdd27b14bb7e18bedfe6917d476b88d92ef",
                              @"address" : @"0xa9e6fe2551a24add531a15b8a29c32f645834d38",
                              @"timestamp" : @"2018-11-10",
                              @"valueInGSE" : @"1.00",
                              @"source" : @"Rebate",
                              };
        [array addObject:dic];
    }
    [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GSE_RebateInfo * item = [[GSE_RebateInfo alloc] init];
        [item addEntriesFromDictionray:obj];
        [self.items addObject:item];
    }];
     */
    
    self.emptyView = ({
        CGFloat width = self.contentView.bounds.size.width - 50;
        CGFloat height  = self.contentView.bounds.size.height;
        UIView *view = [[UIView alloc] initWithFrame:self.contentView.bounds];
        {
            CGRect rect = CGRectMake(0, 0, width, height);
            
            self.emptyLabel = ({
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = UIColorFromRGB(0xbdbdbd);
                label.font = [UIFont systemFontOfSize:15];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = NSLocalizedString(@"Loading...",nil);
                [label setText:label.text lineSpacing:8 wordSpacing:1];
                [label sizeToFit];
                label.frame = ({
                    CGRect frame = label.frame;
                    frame.size.width = width;
                    frame.size.height *= 2;
                    frame;
                });
                label.center = CGPointMake(view.bounds.size.width / 2.0f, height/ 5.0 * 2 );
                [view addSubview:label];
                label;
            });
        }
        view;
    });
    
    self.collectionView = [[IGListCollectionView alloc] initWithFrame:self.contentView.bounds];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.collectionView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.transform = CGAffineTransformMakeScale(0.9, 0.9);
    refreshControl.tintColor = UIColorFromRGB(0xdbdbdb);
    [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    self.adapter = [[IGListAdapter alloc] initWithUpdater:[[IGListAdapterUpdater alloc] init]
                                           viewController:self];
    
    self.adapter.collectionView = self.collectionView;
    self.adapter.dataSource = self;
    self.adapter.scrollViewDelegate = self;
    self.adapter.collectionViewDelegate = self;
    
    [self reloadData];
    
    __weak typeof(self)weakSelf = self;
    [self reloadData:nil finish:^{
        if (weakSelf.items.count <= 1) {
            weakSelf.emptyLabel.text = NSLocalizedString(@"Rebates will appear after you make transactions",nil);
            [weakSelf.emptyLabel setText:weakSelf.emptyLabel.text lineSpacing:8 wordSpacing:1];
        }
    }];
}

- (void)reloadData{
    GSE_Wallet *shared = [GSE_Wallet shared];
    NSString *clientid = [shared getClientid];
    NSArray *array = [shared getRebateHistoryForClient:clientid];
    if ([array isKindOfClass:[NSArray class]] && array.count) {
        [self.items addObject:self.menuView];
        [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            GSE_RebateInfo * item = [[GSE_RebateInfo alloc] init];
            [item addEntriesFromDictionray:obj];
            [self.items addObject:item];
        }];
        [self.adapter performUpdatesAnimated:NO completion:nil];
    }
}

- (void)reloadData:(NSString *)lastid finish:( void (^)(void) ) finish{
    GSE_Wallet *wallet = [GSE_Wallet shared];
    Address *address = [wallet getCurrentWalletAddress];
    NSString *clientid = [wallet getClientid];
    NSMutableDictionary * info = @{@"address":address.checksumAddress.lowercaseString?:@"",
                            @"device":[UIDevice deviceInfo],
                            @"clientid":clientid,
                            }.mutableCopy;
    
    if([lastid isKindOfClass:[NSString class]]){
        [info setObject:lastid forKey:@"lastid"];
    }

    NSData *encrypted = [[NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:nil] sign];
    NSString *encryptedString = [encrypted base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"%@",encryptedString);
    NSDictionary *dic = @{@"encrypted": encryptedString?:@""};
    
    Provider *provider = wallet.getProvider;
    __weak typeof(self)weakSelf = self;
    [[provider getRebateHistory:dic] onCompletion:^(DictionaryPromise *promise) {
        if (!promise.result) {
            [weakSelf loadingFinish];
            [weakSelf alertTitle:NSLocalizedString(@"Network Error", nil)
                     withMessage:nil buttonTitle:NSLocalizedString(@"OK", nil) finish:nil];
            if (finish) {
                finish();
            }
            return ;
        }
        [weakSelf loadingFinish];
        NSDictionary *value = promise.value;
        NSString *ok = value[@"ok"];
        if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
            if (finish) {
                finish();
            }
            return;
        }
        
        NSArray *data = value[@"data"];
        if (!data || ![data isKindOfClass:[NSArray class]]) {
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
        if (!data || ![data isKindOfClass:[NSArray class]]) {
            if (finish) {
                finish();
            }
            return;
        }
        NSLog(@"%@",data);
        
        if (!lastid) {
            [weakSelf.items removeAllObjects];
            if (data.count) {
                [weakSelf.items addObject:weakSelf.menuView];
            }
        }
        
        [data enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            GSE_RebateInfo * item = [[GSE_RebateInfo alloc] init];
            [item addEntriesFromDictionray:obj];
            [weakSelf.items addObject:item];
        }];
        
        [wallet storeRebateHistory:data forClient:clientid];
        
        [weakSelf.adapter performUpdatesAnimated:YES completion:nil];
        if (finish) {
            finish();
        }
    }];
}

#pragma mark - action

- (void)refreshAction:(UIRefreshControl *)sender{
    
    __weak typeof(self)weakSelf = self;
    [self reloadData:nil finish:^{
        if (sender.isRefreshing) {
            [sender endRefreshing];
        }
        if (weakSelf.items.count <= 1) {
            weakSelf.emptyLabel.text = NSLocalizedString(@"Rebates will appear after you make transactions",nil);
        }
    }];
    
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    
    NSMutableArray *items = self.items;
    if (self.loading && items.count > 20) {
        [items addObject:self.spiningToken];
    }
    return items;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    
    if ([object isEqual:self.spiningToken]) {
        return [[IGListSingleSectionController alloc] initWithCellClass:[GSE_SpinnerCell class] configureBlock:^(id  _Nonnull item, __kindof UICollectionViewCell * _Nonnull cell) {
            if ([cell isKindOfClass:[GSE_SpinnerCell class]]) {
                GSE_SpinnerCell *_cell = (id)cell;
                [_cell.indicatorView startAnimating];
            }
        } sizeBlock:^CGSize(id  _Nonnull item, id<IGListCollectionContext>  _Nullable collectionContext) {
            return CGSizeMake( collectionContext.containerSize.width, 100);
        }];
    }
    
    GSE_RebateHistoryController *controller = [[GSE_RebateHistoryController alloc] init];
    controller.delegate = self;
    return controller;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    //return nil;
    
    return self.emptyView;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat distance = scrollView.contentSize.height - ((*targetContentOffset).y + CGRectGetHeight(scrollView.bounds));
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addMoreData) object:nil];
    
    if (!self.loading && distance <= 200) {
        self.loading = YES;
        [self.adapter performUpdatesAnimated:NO completion:nil];
    }
    [self performSelector:@selector(addMoreData) withObject:nil afterDelay:0.5f];
}

- (void)addMoreData{
    
    if (!self.loading) {
        return;
    }
    self.loading = NO;
    [self.items removeObject:self.spiningToken];
    
    if (self.items.count > 1) {
        GSE_RebateInfo *info = self.items.lastObject;
        [self reloadData:info.rebateid finish:nil];
    }else{
        [self reloadData:nil finish:nil];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    GSE_WalletTxnDetail *detail = [[GSE_WalletTxnDetail alloc] init];
    detail.isFromRebateHistory = YES;
    
    GSE_RebateInfo *item = self.items[indexPath.section];
    
    if (![item isKindOfClass:[GSE_RebateInfo class]]) {
        return;
    }

    NSDictionary *_info = item.transaction;
    
    if (![_info isKindOfClass:[NSDictionary class]] && !_info.count) {
        NSLog(@"%@",_info);
        return;
    }
    
    if (! _info[@"hash"] || !_info[@"from"] || !_info[@"to"]) {
        return;
    }
    
    NSString *wallet = [[GSE_Wallet shared] getCurrentWallet];
    Address *address = [[GSE_Wallet shared] getAddressForWallet:wallet];
    
    if ([_info isKindOfClass:[NSDictionary class]]) {
        NSString *from = _info[@"from"];
        detail.isTxnOut = [from.lowercaseString isEqualToString:address.checksumAddress.lowercaseString];
    }
    else if ([_info isKindOfClass:[TransactionInfo class]]){
        
        TransactionInfo *info = (TransactionInfo *)_info;
        
        //trasfer out
        detail.isTxnOut = [info.fromAddress.checksumAddress.lowercaseString isEqualToString:address.checksumAddress.lowercaseString];
        
    }
    detail.transaction = _info;
    detail.token = item.contract;
    detail.isContract = item.contract ? YES : NO;
    
    [self.navigationController pushViewController:detail animated:YES];
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
