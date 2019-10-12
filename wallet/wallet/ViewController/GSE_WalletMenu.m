//
//  GSE_WalletMenu.m
//  GSEWallet
//
//  Created by user on 08/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletMenu.h"
#import "GSE_MenuVertical.h"

#import "GSE_WalletCreator.h"
#import "GSE_WalletImporter.h"

@interface GSE_WalletMenu () <GSE_MenuDelegate>
@property (nonatomic, strong) GSE_MenuVertical *menu;
@end

@implementation GSE_WalletMenu

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.backgroundView) {
        [self.view addSubview:self.backgroundView];
    }
    if (!self.menu) {
        self.menu =({
            GSE_MenuVertical *menu = [[GSE_MenuVertical alloc] init];
            menu.delegate = self;
            //menu.hidden = YES;
            if (self.chooseWallet) {
                menu.hideCreateAndImport = YES;
                menu.hideTotalAssets = YES;
                //menu.hidePercentage = YES;
                menu.menuTitle = NSLocalizedString(@"Select Wallet", nil);
            }
            menu;
        });
        [self.menu close];
        [self.view addSubview:_menu];
    }
    
    [self.menu reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.menu open];
}

#pragma mark - delegate

- (void)menu:(id)menu runCreateWallet:(BOOL)finish{
    
    __weak typeof(self)weakSelf = self;
    
    [weakSelf.menu close:^{
        GSE_WalletCreator *creator = [[GSE_WalletCreator alloc] init];
        
        [creator setFinish:^(NSString *name){
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            if (weakSelf.createdOrImported) {
                weakSelf.createdOrImported(name);
            }
            //[weakSelf.menu close:^{
                [weakSelf closeAction:nil];
            //}];
        }];
        [weakSelf.navigationController pushViewController:creator animated:YES];
    }];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"ManageWallet_Create"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)menu:(id)menu runImportWallet:(BOOL)finish{

    __weak typeof(self)weakSelf = self;
    
    [weakSelf.menu close:^{
        GSE_WalletImporter *importer = [[GSE_WalletImporter alloc] init];
        [importer setFinish:^(NSString *name){
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            if (weakSelf.createdOrImported) {
                weakSelf.createdOrImported(name);
            }
            //[weakSelf.menu close:^{
                [weakSelf closeAction:nil];
            //}];
        }];
        [self.navigationController pushViewController:importer animated:YES];
    }];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"ManageWallet_Import"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)menu:(GSE_MenuVertical *)menu runSelectWallet:(NSString *)wallet{
    __weak typeof(self) weakSelf = self;
    
    if (weakSelf.createdOrImported) {
        weakSelf.createdOrImported(wallet);
    }
    
    [weakSelf.menu close:^{
        [weakSelf closeAction:nil];
    }];
    
}

- (void)menu:(id)menu runSettings:(BOOL)finish{
    
}

- (void)closeAction:(UITapGestureRecognizer *)tap{
    [self dismissViewControllerAnimated:NO completion:^{
        if (self.finish) {
            self.finish();
        }
    }];
    
}

- (void)longPressAction:(UILongPressGestureRecognizer *)pGesture{
    
    [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
    
    MBProgressHUD *hud = [self finishing:NSLocalizedString(@"Copied",nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
