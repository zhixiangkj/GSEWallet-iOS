//
//  GSE_WalletNodeTransfer.m
//  GSEWallet
//
//  Created by user on 07/01/2019.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

#import "GSE_WalletNodeTransfer.h"
#import "GSE_WalletMenu.h"
#import "ViewController.h"

@interface GSE_WalletNodeTransfer ()
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UILabel *walletLabel;
@property (nonatomic, strong) UIButton *walletButton;

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *rebateLabel;
@property (nonatomic, strong) UIImageView *rebateIcon;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *separatorView;
@property (nonatomic, strong) UILabel *minimumLabel;
@property (nonatomic, strong) UIButton *continue_btn;

@property (nonatomic, strong) NSString *choosenWallet;
@end

@implementation GSE_WalletNodeTransfer

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"GSE节点计划",nil);
    self.hidesBottomBarWhenPushed = YES;
    
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = self.contentView.bounds.size.height;
    
    self.menuButton = ({
        CGRect rect = CGRectMake(10, 30, width - 20, 40);
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.layer.borderWidth = 1.0 / 2;
        button.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
        [button addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [self.contentView addSubview:self.menuButton];
    
    self.walletLabel = ({
        CGRect rect = CGRectMake(15, 0,
                                 CGRectGetWidth(self.menuButton.bounds) - 30,
                                 CGRectGetHeight(self.menuButton.bounds));
        
        UILabel *label = [[UILabel alloc] initWithFrame:rect];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:14];
        label.text = NSLocalizedString(@"请选择转出GSE的钱包", nil);
        [label sizeToFit];
        label.center = CGPointMake( 15 + CGRectGetWidth(label.bounds) / 2.0, CGRectGetHeight(self.menuButton.bounds) / 2.0);
        label;
    });
    [self.menuButton addSubview:self.walletLabel];
    
    self.walletButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"withdraw_select_wallet"] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button sizeToFit];
        button.center = CGPointMake( CGRectGetWidth(self.menuButton.frame) - 15 - CGRectGetWidth(button.bounds) / 2.0, CGRectGetHeight(self.menuButton.bounds) / 2.0);
        button.userInteractionEnabled = NO;
        button;
    });
    [self.menuButton addSubview:self.walletButton];
    
    self.tipLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0x666666);
        label.text = NSLocalizedString(@"委托本金和权益将在到期后自动转账至此钱包", nil);
        [label sizeToFit];
        label.frame =({
            CGRect frame = label.frame;
            frame.origin.x = 25; //CGRectGetMinX(self.menuButton.frame);
            frame.origin.y = 20 + CGRectGetMaxY(self.menuButton.frame);
            frame;
        });
        label;
    });
    [self.contentView addSubview:self.tipLabel];
    
    self.rebateLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = UIColorFromRGB(0x7bb256);
        label.text = NSLocalizedString(@"此笔委托转账将获得手续费返还", nil);
        [label sizeToFit];
        label.frame = ({
            CGRect frame = label.frame;
            frame.origin.x = 25;
            frame.origin.y = 10 + CGRectGetMaxY(self.tipLabel.frame);
            frame;
        });
        label;
    });
    [self.contentView addSubview:self.rebateLabel];
    
    self.rebateIcon = ({
        UIImage *image = [UIImage imageNamed:@"node_green_checked"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = ({
            CGRect frame = imageView.frame;
            frame.origin.x = CGRectGetMaxX(self.rebateLabel.frame) + 5;
            frame;
        });
        imageView.center = ({
            CGPoint center = imageView.center;
            center.y = self.rebateLabel.center.y;
            center;
        });
        imageView;
    });
    [self.contentView addSubview:self.rebateIcon];
    
    self.textField = ({
        UITextField *textField = [[UITextField alloc] init];
        textField.textColor = UIColorFromRGB(0x333333);
        [textField setPlaceholder:NSLocalizedString(@"请输入委托GSE数量，最少1,000GSE", nil) color:UIColorFromRGB(0x999999) wordSpacing:0];
        [textField setFont:[UIFont systemFontOfSize:14]];
        [textField setKeyboardType:UIKeyboardTypeDecimalPad];
        [textField setReturnKeyType:UIReturnKeyDone];
        textField.frame = ({
            CGRect frame = textField.frame;
            frame.origin.x = 25;
            frame.origin.y = CGRectGetMaxY(self.rebateLabel.frame) + 50;
            frame.size.width = self.view.bounds.size.width - 50;
            frame.size.height = 28;
            frame;
        });
        textField;
    });
    [self.contentView addSubview:self.textField];
    
    self.separatorView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = UIColorFromRGB(0xdedede);
        view.frame = ({
            CGRect frame = view.frame;
            frame.origin.x = 25;
            frame.origin.y = CGRectGetMaxY(self.textField.frame);
            frame.size.width = self.view.bounds.size.width - 50;
            frame.size.height = 1.0 / [UIScreen mainScreen].scale;
            frame;
        });
        view;
    });
    [self.contentView addSubview:self.separatorView];
    
    self.minimumLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x666666);
        label.font = [UIFont systemFontOfSize:12];
        label.text = NSLocalizedString(@"当前余额 23,463.26", nil);
        [label sizeToFit];
        label.frame = ({
            CGRect frame = label.frame;
            frame.origin.x = 25;
            frame.origin.y = 10 + CGRectGetMaxY(self.separatorView.frame);
            frame;
        });
        label;
    });
    [self.contentView addSubview:self.minimumLabel];

    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.15);
    self.continue_btn = ({
        CGFloat margin = 45;
        CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 - 50 : height - 104* ratio - 36 - 50;
        CGRect rect = CGRectMake(margin, origin, width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button.layer setCornerRadius:25];
        [button.layer setMasksToBounds:NO];
        [button setClipsToBounds:YES];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: NSLocalizedString( @"委托" , nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        //[button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.continue_btn];
    
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.contentView addGestureRecognizer:tap];
    }
}

#pragma mark - action

- (void)menuAction:(id)sender{
    
    __weak typeof(self) weakSelf = self;
    GSE_WalletMenu *menu = [[GSE_WalletMenu alloc] init];
    menu.chooseWallet = YES;
    [menu setCreatedOrImported:^(NSString *name) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.walletButton setImage:nil forState:UIControlStateNormal];
            [weakSelf.walletButton setTitle:name forState:UIControlStateNormal];
            [weakSelf.walletButton sizeToFit];
            CGFloat maxWidth = CGRectGetWidth(weakSelf.menuButton.bounds) - CGRectGetMaxX(weakSelf.walletLabel.frame) - 20;
            if (CGRectGetWidth(weakSelf.walletButton.frame) > maxWidth) {
                weakSelf.walletButton.frame = ({
                    CGRect frame = weakSelf.walletButton.frame;
                    frame.size.width = maxWidth;
                    frame;
                });
            }
            weakSelf.walletButton.center = CGPointMake( CGRectGetWidth(weakSelf.menuButton.frame) - 15 - CGRectGetWidth(weakSelf.walletButton.bounds) / 2.0, CGRectGetHeight(weakSelf.menuButton.bounds) / 2.0);
            weakSelf.choosenWallet = name;
        });
    }];
    
    UIView *view = [self.navigationController.view snapshotViewAfterScreenUpdates:YES];
    [self.navigationController.view addSubview:view];
    
    [menu setFinish:^{
        [view removeFromSuperview];
    }];
    
    menu.backgroundView = [self.navigationController.tabBarController.view snapshotViewAfterScreenUpdates:YES];
    ViewControllerNav *nav = [[ViewControllerNav alloc] initWithRootViewController:menu];
    [self presentViewController:nav animated:NO completion:^{
        
    }];
}

- (void)tapAction:(id)sender{
    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }
}

- (void)nextAction:(id)sender{
    
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
