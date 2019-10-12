//
//  ViewController.m
//  wallet
//
//  Created by user on 21/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

#import "GSE_WalletCreator.h"
#import "GSE_WalletSuccessor.h"
#import "GSE_WalletImporter.h"
#import "GSE_WalletExporter.h"
#import "GSE_WalletLogin.h"
#import "GSE_WalletTxns.h"
#import "GSE_WalletTransfer.h"
#import "GSE_WalletReceiver.h"
#import "GSE_WalletGuide.h"
#import "GSE_WalletReName.h"
#import "GSE_WalletRemover.h"

#import "GSE_MenuVertical.h"
#import "GSE_Main.h"
#import "GSE_WalletMenu.h"


@interface ViewControllerNav ()

@end

@implementation ViewControllerNav
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
@end

@interface ViewController ()<UINavigationControllerDelegate,UITabBarControllerDelegate,UNUserNotificationCenterDelegate, GSE_MainDelegate>

@property (nonatomic, strong) GSE_Main *main;
@property (nonatomic, strong) UIView *loading;

@property (nonatomic, assign) NSTimeInterval tapTime;
@property (nonatomic, weak) UIViewController *prevVC;
@end

@implementation ViewController

static ViewController *instance = nil;
+ (id)shared{
    return instance;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.title = NSLocalizedString(@"Wallet",nil);
    
    UIImage *image = [[UIImage imageNamed:@"tab_home_icon_wallet_default"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImage = [[UIImage imageNamed:@"tab_home_icon_wallet"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBarItem.image = image;
    self.tabBarItem.selectedImage = selectedImage;
    
    
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x4775f4)} forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    instance = self;
    
    //CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    //CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.15);
    //NSLog(@"%s,%@,%@",__FUNCTION__,@(screenHeight),@(ratio));
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.delegate = self;
    [self.tabBarController.tabBar setTranslucent:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    /*[self.navigationController.tabBarController.tabBar.items enumerateObjectsUsingBlock:^(UITabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 1) {
            [obj setTitlePositionAdjustment:UIOffsetMake(0, -3.5)];
        }else{
            [obj setTitlePositionAdjustment:UIOffsetMake(0, -5)];
        }
    }];*/
    
    UIImage *leftImage = [[UIImage imageNamed:@"menu_hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(menuAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIImage *rightImage = [[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:rightImage style:UIBarButtonItemStylePlain target:self action:@selector(exportAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    {
        UINavigationBar *navigationBar = self.navigationController.navigationBar;
        navigationBar.backgroundColor = [UIColor whiteColor];
        navigationBar.translucent = NO;
        CGRect rect = CGRectMake(0, navigationBar.bounds.size.height - 0.5, self.view.bounds.size.width, 1);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [self.navigationController.navigationBar addSubview:view];
    }
    
    [self setBackItem];
    
    //NSLog(@"%@",[[SSDB shared] hGetString:@"wallet/0/deleted" forKey:@"0x409121809b898dbb9c6bad294995cae297cb9722"]);
    
    [self checkUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self checkUpdate];
        
        if ([[GSE_Wallet shared] getWallets].count) {
            [self reloadData];
            //[self.main reloadData];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"rebateChanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        if ([[GSE_Wallet shared] getWallets].count) {
            [self.main reloadData];
        }
        
    }];

    if ([[GSE_Wallet shared] getWallets].count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showGuide];
        });
        return;
    }
    
    [self showLogin];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - show guide

- (void)showGuide{
    GSE_WalletGuide *guide = [[GSE_WalletGuide alloc] init];
    __weak typeof(self) weakSelf = self;
    [guide setFinish:^{
        {
            CGRect rect = [UIScreen mainScreen].bounds;
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.backgroundColor = [UIColor whiteColor];
            [weakSelf.navigationController.tabBarController.view.window addSubview:view];
            
            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
            [weakSelf showLogin];
        }
    }];
    ViewControllerNav *nav = [[ViewControllerNav alloc] initWithRootViewController:guide];
    nav.navigationBar.hidden = YES;
    [self presentViewController:nav animated:NO completion:nil];
}


- (void)showLogin{
    
    NSString *current = [[GSE_Wallet shared] getCurrentWallet];
    
    if (!current.length) {
        return;
    }
    
    if (!self.main) {
        self.main =({
            GSE_Main *main = [[GSE_Main alloc] initWithFrame:self.view.bounds];
            main.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            main.delegate = self;
            main;
        });
        [self.view addSubview:self.main];
    }
    
    [self.main setWallet:current];
    
    [self reloadData];
    
    [self notify];
    
    /*
    Address *fromAddress = address;
    
    Provider *provider = [[GSE_Wallet shared] getProvider];
    
    [[provider getBalance:fromAddress] onCompletion:^(BigNumberPromise *promise) {
        NSLog(@"%@",promise.value);
        
        BigNumber *value = promise.value;
        NSLog(@"%@",[Payment formatEther:value]);
    }];
    
    Hash *hash = [Hash hashWithHexString:@"0xcf83325f41a848454f7ae83a225e02540660207ea0c08280d055c318d25f127f"];
    
    [[provider getTransaction:hash] onCompletion:^(TransactionInfoPromise *promise) {
        NSLog(@"%@",promise.value);
    }];
    
    NSLog(@"%@",fromAddress.data);
    
    SecureData *data = [SecureData secureDataWithLength:32 - fromAddress.data.length];
    [data appendData:fromAddress.data];
    NSLog(@"%@",data);
    
    
    self.loading = ({
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.navigationController.view.window addSubview:self.loading];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        GSE_WalletLogin *login = [[GSE_WalletLogin alloc] init];
        [self presentViewController:login animated:NO completion:^{
            [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.loading.alpha = 0;
            } completion:^(BOOL finished) {
                [self.loading removeFromSuperview];
            }];
        }];
    });
    
     */
    
    //NSLog(@"address: %@",[Address addressWithString:@"0xd24e56f02ee723a443575836b9668587ffd6204f"]);
}

- (void)notify{
    if (@available(iOS 10,*)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }];
    }else{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIApplication *application = [UIApplication sharedApplication];
            
            [application registerUserNotificationSettings:
             [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert |UIUserNotificationTypeBadge)
                                               categories:nil]];
            
            [application registerForRemoteNotifications];
        });
    }
}

- (void)checkUpdate{

    Provider * provider = [[GSE_Wallet shared] getProvider];
    
    NSDictionary *dic = [UIDevice deviceInfo];

    [[provider getUpdate:dic] onCompletion:^(DictionaryPromise *promise) {
        if (!promise.result) {
            NSLog(@"%@",promise.error);
            return ;
        }
        NSLog(@"%s,%@",__FUNCTION__,promise.value);
        NSDictionary *dic = promise.value;
        if (![dic isKindOfClass:[NSDictionary class]]) {
            return;
        }
        NSString *url = dic[@"url"];
        if (!url || ![url isKindOfClass:[NSString class]] || !url.length) {
            return;
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }];
}

#pragma mark - reloadData

- (void)reloadData{
    __weak typeof(self)weakSelf = self;
    [self reloadData:^{
        GSE_WalletTxns *vc = (id)(weakSelf.navigationController.topViewController);
        if ([vc isKindOfClass:[GSE_WalletTxns class]]) {
            
            NSString *current = [[GSE_Wallet shared] getCurrentWallet];
            if (!current.length) {
                return ;
            }
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
            
            for (NSDictionary *token in tokens) {
                if (![token isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                NSString *contractAddressString = token[@"contractAddress"];
                if (contractAddressString) {
                    NSString *contract = vc.contract.checksumAddress.lowercaseString;
                    if ([contractAddressString isEqualToString:contract]) {
                        vc.token = token;
                        break;
                    }
                }else{
                    if (!vc.contract) {
                        vc.token = token;
                        break;
                    }
                }
            }
        }
    }];
}

- (void)reloadData:( void (^)(void) ) finish{
    
    GSE_Wallet *wallet = [GSE_Wallet shared];
    
    __weak typeof(self) weakSelf = self;
    
    [wallet reloadTokens:^(NSDictionary *object) {
        NSString * total = object[@"totalusd"];
        [weakSelf.main setTotalUSD:total?:@"$ 0.00"];
        
        NSString *percentchange = object[@"usdpercentagechange"];
        [weakSelf.main setPercentageChange:percentchange?:@"0%"];
        
        [weakSelf.main reloadData];
        if (finish) {
            finish();
        }
    }];
}

#pragma mark - action

- (void)menuAction:(id)sender{
    //[self.menu open];
}

- (void)exportAction:(id)sender{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //alert.view.tintColor = UIColorFromRGB(0x333333);
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Back Up Current Wallet",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString *current = [[GSE_Wallet shared] getCurrentWallet];
        NSDictionary *keystore = [[GSE_Wallet shared] getKeystore:current];
        
        NSDictionary *ethersData = [keystore objectForKey:@"x-ethers"];
        if ([ethersData isKindOfClass:[NSDictionary class]] && [[ethersData objectForKey:@"version"] isEqual:@"0.1"]) {
            
            NSData *mnemonicCounter = [ethersData objectForKey:@"mnemonicCounter"];
            NSData *mnemonicCiphertext = [ethersData objectForKey:@"mnemonicCiphertext"];
            if (mnemonicCounter.length&& mnemonicCiphertext.length) {
                
                [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Export Mnemonic Phase", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    GSE_WalletExporter *exporter = [[GSE_WalletExporter alloc] init];
                    
                    exporter.wallet = current;
                    exporter.exportType = 0;
                    [self.navigationController pushViewController:exporter animated:YES];
                }]];
            }
        }
        
        [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Export Private Key", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            GSE_WalletExporter *exporter = [[GSE_WalletExporter alloc] init];
            
            exporter.wallet = current;
            exporter.exportType = 1;
            [self.navigationController pushViewController:exporter animated:YES];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"Export Keystore", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            GSE_WalletExporter *exporter = [[GSE_WalletExporter alloc] init];
            
            exporter.wallet = current;
            exporter.exportType = 2;
            [self.navigationController pushViewController:exporter animated:YES];
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }]];
    
    /*
    [alert addAction:[UIAlertAction actionWithTitle:@"Back up Private Key" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GSE_WalletExporter *exporter = [[GSE_WalletExporter alloc] init];
        NSString *current = [[GSE_Wallet shared] getCurrentWallet];
        exporter.wallet = current;
        exporter.exportType = 1;
        [self.navigationController pushViewController:exporter animated:YES];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Back up Keystore" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        GSE_WalletExporter *exporter = [[GSE_WalletExporter alloc] init];
        NSString *current = [[GSE_Wallet shared] getCurrentWallet];
        exporter.wallet = current;
        exporter.exportType = 2;
        [self.navigationController pushViewController:exporter animated:YES];
        
    }]];
    */
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Rename Current Wallet",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        /*
        GSE_WalletSuccessor *successor = [[GSE_WalletSuccessor alloc] init];
        successor.wallet = [[GSE_Wallet shared] getCurrentWallet];
        [self.navigationController pushViewController:successor animated:YES];
        
        return;*/
        
        GSE_WalletReName *rename = [[GSE_WalletReName alloc] init];
        NSString *current = [[GSE_Wallet shared] getCurrentWallet];
        rename.wallet = current;
        
        [rename setFinish:^{
            NSString *current = [[GSE_Wallet shared] getCurrentWallet];
            [self.main setWallet:current];
            //[self.menu reloadData];
        }];
        [self.navigationController pushViewController:rename animated:YES];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Delete Current Wallet",nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        GSE_WalletRemover *remover = [[GSE_WalletRemover alloc] init];
        NSString *current = [[GSE_Wallet shared] getCurrentWallet];
        remover.wallet = current;
        [remover setFinish:^{
            
            if ([[GSE_Wallet shared] getWallets].count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    [self showGuide];
                });
                return;
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self showLogin];
            
        }];
        [self.navigationController pushViewController:remover animated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)refreshAction:(UIRefreshControl *)sender{
    //__weak typeof(self)weakSelf = self;
    [self reloadData:^{
        if (sender.isRefreshing) {
            [sender endRefreshing];
        }
    }];
}

#pragma mark - delegate

- (void)main:(GSE_Main *)mainView didSelectToken:(NSDictionary *)token{
    
    GSE_WalletTxns * txns = [[GSE_WalletTxns alloc] init];
    txns.token = token;
    NSString * symbol = token[@"symbol"];
    if (![symbol isKindOfClass:[NSString class]] || !symbol.length) {
        return;
    }
    txns.symbol = symbol;
    NSString *name = token[@"name"];
    txns.name = name;
    
    NSString *contract = token[@"contractAddress"];
    if ([contract isKindOfClass:[NSString class]]) {
        txns.contract = [Address addressWithString:contract];
    }

    NSString *current = [[GSE_Wallet shared] getCurrentWallet];
    txns.address = [[GSE_Wallet shared] getAddressForWallet:current];
    
    [self.navigationController pushViewController:txns animated:YES];
}

- (void)main:(GSE_Main *)mainView didClickSend:(id)sender{
    
    GSE_WalletTransfer *transfer = [[GSE_WalletTransfer alloc] init];
    NSString *current = [[GSE_Wallet shared] getCurrentWallet];
    transfer.wallet = current;
    [self.navigationController pushViewController:transfer animated:YES];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Home_Transfer"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

- (void)main:(GSE_Main *)mainView didClickReceive:(id)sender{
    
    GSE_WalletReceiver *transfer = [[GSE_WalletReceiver alloc] init];
    NSString *current = [[GSE_Wallet shared] getCurrentWallet];
    transfer.wallet = current;
    [self.navigationController pushViewController:transfer animated:YES];
}

- (void)main:(GSE_Main *)mainView didClickMore:(id)sender{
    [self exportAction:nil];
}

- (void)main:(GSE_Main *)mainView didClickTitle:(id)sender{
    //[self.menu open];
    
    __weak typeof(self) weakSelf = self;
    
    UITabBar *tabBar = self.navigationController.tabBarController.tabBar;
    
    GSE_WalletMenu *menu = [[GSE_WalletMenu alloc] init];
    [menu setCreatedOrImported:^(NSString *name) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[GSE_Wallet shared] setCurrentWallet:name];
            [weakSelf.main setWallet:name];
            [weakSelf.main refresh];
            [weakSelf notify];
        });
    }];
    
    UIView *view = [self.navigationController.tabBarController.view snapshotViewAfterScreenUpdates:YES];
    [self.navigationController.tabBarController.view addSubview:view];
    
    [menu setFinish:^{
        tabBar.alpha = 1;
        [view removeFromSuperview];
    }];
    
    menu.backgroundView = [self.navigationController.tabBarController.view snapshotViewAfterScreenUpdates:YES];
    ViewControllerNav *nav = [[ViewControllerNav alloc] initWithRootViewController:menu];
    [self presentViewController:nav animated:NO completion:^{
        tabBar.alpha = 0;
    }];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    NSMutableDictionary * event = [[GAIDictionaryBuilder
                                    createEventWithCategory:@"ui_action"
                                    action:@"Home_SwitchWallets"
                                    label:[GSE_Wallet shared].getClientid
                                    value:nil] build];
    NSLog(@"%@",event);
    [tracker send:event];
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    //Called when a notification is delivered to a foreground app.
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    //Called to let your app know which action was selected by the user for a given notification.
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
}

#pragma mark - tabbar

/*
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval duration = currentTime - self.tapTime;
    self.tapTime = currentTime;
    if (viewController == self.navigationController) {
        if (duration < 0.2) {
            // double tap detected! write your code here
            [self.menu toggle:^{
                
            }];
            self.tapTime = 0;
        }
    }
}*/

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
