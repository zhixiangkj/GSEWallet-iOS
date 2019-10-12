//
//  Node.m
//  GSEWallet
//
//  Created by user on 26/12/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "Node.h"

#import "GSE_Node.h"
#import "GSE_NodeController.h"

#import "GSE_WalletNodePlan.h"
#import "GSE_WalletNodeHistory.h"

@interface Node ()<IGListAdapterDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) IGListAdapter *adapter;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) GSE_Node *node;
@end

@implementation Node

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"个人节点",nil);
    
    UIImage *image = [[UIImage imageNamed:@"tab_icon_GSENode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImage = [[UIImage imageNamed:@"tab_icon_GSENode_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
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
    self.node = [[GSE_Node alloc] init];
    [self.items addObject:self.node];
    
    [self.items addObject:[GSE_NodePlan new]];
    
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
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
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
    if ([object isKindOfClass:[GSE_Node class]]) {
        GSE_NodeController *controller = [[GSE_NodeController alloc] init];
        controller.delegate = self;
        return controller;
    }
    if ([object isKindOfClass:[GSE_NodePlan class]]) {
        GSE_NodePlanController *controller = [[GSE_NodePlanController alloc] init];
        controller.delegate = self;
        return controller;
    }
    return nil;
}

- (UIView *)emptyViewForListAdapter:(IGListAdapter *)listAdapter {
    return nil;
}

#pragma mark - action

- (void)detailAction:(GSE_NodePlan *)plan{
    
    if ([plan isKindOfClass:[GSE_Node class]]) {
        GSE_WalletNodeHistory *history = [[GSE_WalletNodeHistory alloc] init];
        
        [self.navigationController pushViewController:history animated:YES];
        return;
    }
    
    GSE_WalletNodePlan *plvc = [[GSE_WalletNodePlan alloc] init];
    plvc.plan = plan;
    [self.navigationController pushViewController:plvc animated:YES];
}

#pragma mark - system

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

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
