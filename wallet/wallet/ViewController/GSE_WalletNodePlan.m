//
//  GSE_WalletNodePlan.m
//  GSEWallet
//
//  Created by user on 07/01/2019.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

#import "GSE_WalletNodePlan.h"


#import "GSE_NodeController.h"
#import "GSE_WalletNodeTransfer.h"
#import "GSE_WalletWebBrowser.h"

@interface GSE_WalletNodePlan ()<IGListAdapterDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation GSE_WalletNodePlan

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"GSE节点计划",nil);
    
    self.navigationController.navigationBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    
    self.items = @[].mutableCopy;
    
    if (self.plan) {
        if (self.plan.name.length) {
            self.title = self.plan.name;
        }
        [self.items addObject:self.plan];
    }
    
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
    //self.hidesBottomBarWhenPushed = YES;
    [self reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //self.hidesBottomBarWhenPushed = NO;
}

- (void)reloadData{

}

#pragma mark - action

- (void)refreshAction:(id)sender{
    
}

#pragma mark - IGListAdapterDataSource

- (NSArray<id<IGListDiffable>> *)objectsForListAdapter:(IGListAdapter *)listAdapter {
    return self.items;
}

- (IGListSectionController *)listAdapter:(IGListAdapter *)listAdapter sectionControllerForObject:(id)object {

    GSE_NodePlanDetailController *controller = [[GSE_NodePlanDetailController alloc] init];
    controller.delegate = self;
    return controller;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - action

- (void)transferAction:(GSE_NodePlan *)plan{
    
    GSE_WalletNodeTransfer *transfer = [[GSE_WalletNodeTransfer alloc] init];
    transfer.plan = plan;
    [self.navigationController pushViewController:transfer animated:YES];
}

- (void)detailAction:(GSE_NodePlan *)plan{
    GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
    browser.customTitle = NSLocalizedString(@"How it works",nil);
    browser.url = [NSURL URLWithString:plan.url?:GSENETWORK_HOST@"/wallet/stake/howitworks"];
    [self.navigationController pushViewController:browser animated:YES];
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
