//
//  GSE_WalletGuide.m
//  wallet
//
//  Created by user on 25/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletGuide.h"

#import "GSE_Guide.h"

#import "GSE_WalletCreator.h"
#import "GSE_WalletImporter.h"

@interface GSE_WalletGuide ()

@end

@implementation GSE_WalletGuide

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect frame = self.view.bounds;
    GSE_Guide *guide = [[GSE_Guide alloc] initWithFrame:frame];
    guide.delegate = self;
    [self.view addSubview:guide];
}

- (void)createAction:(id)sender{
    GSE_WalletCreator *creator = [[GSE_WalletCreator alloc] init];
    __weak typeof(self)weakSelf = self;
    [creator setFinish:^(NSString *name){
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            if (weakSelf.finish) {
                weakSelf.finish();
            }
        }];
    }];
    [self.navigationController pushViewController:creator animated:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Intro_CreateWallet"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}
- (void)importAction:(id)sender{
    GSE_WalletImporter *importer = [[GSE_WalletImporter alloc] init];
    __weak typeof(self)weakSelf = self;
    [importer setFinish:^(NSString *name){
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            if (weakSelf.finish) {
                weakSelf.finish();
            }
        }];
    }];
    [self.navigationController pushViewController:importer animated:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Intro_ImportWallet"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
