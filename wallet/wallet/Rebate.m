//
//  Rebate.m
//  GSEWallet
//
//  Created by user on 01/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "Rebate.h"
#import "GSE_RebateController.h"
#import "GSE_WalletWebBrowser.h"
#import "GSE_WalletWithDraw.h"
#import "GSE_WalletRebateHistory.h"
#import "GSE_Rebate.h"

@interface Rebate ()<IGListAdapterDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) GSE_Rebate *menu;
@property (nonatomic, strong) GSE_RebateCode *rebate;
@end

@implementation Rebate

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"Gas Rebate",nil);
    
    UIImage *image = [[UIImage imageNamed:@"tab_icon_GasRabate"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImage = [[UIImage imageNamed:@"tab_icon_GasRabate_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBarItem.image = image;
    self.tabBarItem.selectedImage = selectedImage;
    
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x4775f4)} forState:UIControlStateSelected];
    
    self.hideBack = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    
    self.items = @[].mutableCopy;
    
    GSE_Rebate * menu = [[GSE_Rebate alloc] init];
    menu.quantity = @"0.0000";
    self.menu = menu;
    [self.items addObject:menu];
    
    GSE_RebateCode *rebate = [[GSE_RebateCode alloc] init];
    rebate.code = NSLocalizedString(@"Loading...",nil);
    self.rebate = rebate;
    [self.items addObject:rebate];

    self.collectionView = [[IGListCollectionView alloc] initWithFrame:self.contentView.bounds ];
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
    //self.adapter.scrollViewDelegate = self;
    
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    
    [self reloadData];
    [self reloadData:nil];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)reloadData{
    
    GSE_Wallet *wallet = [GSE_Wallet shared];
    NSString *clientid = [wallet getClientid];
    
    NSDictionary *data = [[GSE_Wallet shared] getRebateForClient:clientid];
    if (data.count) {
        [self.rebate addEntriesFromDictionray:data];
        self.menu.quantity = self.rebate.quantity;
        [self.adapter reloadDataWithCompletion:nil];
    }
}

- (void)reloadData:( void (^)(void) ) finish{
    GSE_Wallet *wallet = [GSE_Wallet shared];
    NSString *clientid = [wallet getClientid];
    
    Address *address = [wallet getCurrentWalletAddress];
    NSDictionary * info = @{@"address":address.checksumAddress.lowercaseString?:@"",
                            @"device":[UIDevice deviceInfo],
                            @"clientid":clientid};
    NSData *encrypted = [[NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:nil] sign];
    NSString *encryptedString = [encrypted base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"%@",encryptedString);
    NSDictionary *dic = @{@"encrypted": encryptedString?:@""};
    
    __weak typeof(self)weakSelf = self;
    Provider *provider = [[GSE_Wallet shared] getProvider];
    [[provider getRebateCode:dic] onCompletion:^(DictionaryPromise *promise) {
        NSLog(@"%@",promise.result);
        if (!promise.result) {
            if (!weakSelf.rebate.code.length) {
                weakSelf.rebate.code = NSLocalizedString(@"Network Error", nil);
                [weakSelf.adapter reloadDataWithCompletion:nil];
            }
            if (finish) {
                finish();
            }
            return;
        }
        NSDictionary *value = promise.value;
        NSString *ok = value[@"ok"];
        if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
            if (finish) {
                finish();
            }
            return;
        }
        NSDictionary *data = value[@"data"];
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
        
        [weakSelf reloadData];
        
        if (finish) {
            finish();
        }
    }];
}

- (void)refreshAction:(UIRefreshControl *)sender{
    
    [self reloadData:^{
        if (sender.isRefreshing) {
            [sender endRefreshing];
        }
    }];
    
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.items;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {
    GSE_RebateController *controller = [[GSE_RebateController alloc] init];
    controller.delegate = self;
    return controller;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.view.bounds.size.width,
                      self.contentView.bounds.size.height - 150 ); // - ([UIScreen iPhoneX] ? 83 : 50)
}

#pragma mark - action

- (void)copyAction:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"Network Error", nil)]) {
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = sender.titleLabel.text;
    
    [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
    
    MBProgressHUD *hud = [self finishing:NSLocalizedString(@"Copied",nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Invite_CopyCode"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)shareAction:(UIButton *)sender{
    
    if (!sender.titleLabel.text.length) {
        return;
    }
    
    NSString *string = [NSString stringWithFormat:NSLocalizedString(@"I'm using an ETH wallet called GSE Wallet, you should get it because there is no transaction fee (Gas fee) if you use my invitation code %@ to transfer! Download from App Store https://itunes.apple.com/us/app/id1437511476?mt=8", nil),sender.titleLabel.text];
    
    NSArray *itemsToShare = @[string];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:itemsToShare applicationActivities:nil];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Invite_Share"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)howAction:(id)sender{
    GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
    browser.customTitle = NSLocalizedString(@"How it works",nil);
    browser.url = [NSURL URLWithString:self.rebate.url];
    [self.navigationController pushViewController:browser animated:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Invite_Howitworks"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)withdrawAction:(id)sender{
    GSE_WalletWithDraw *withdraw = [[GSE_WalletWithDraw alloc] init];
    [self.navigationController pushViewController:withdraw animated:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Invite_Withdraw"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)historyAction:(id)sender{
    GSE_WalletRebateHistory *rebate = [[GSE_WalletRebateHistory alloc] init];
    [self.navigationController pushViewController:rebate animated:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Invite_History"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
