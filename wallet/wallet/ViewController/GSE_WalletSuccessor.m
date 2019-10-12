//
//  GSE_WalletSuccessor.m
//  wallet
//
//  Created by user on 25/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletSuccessor.h"
#import "GSE_WalletExporter.h"

@interface GSE_WalletSuccessor ()
@property (nonatomic, strong) UIImageView *qrcode;

@property (nonatomic, strong) UIButton *backup_btn;
@property (nonatomic, strong) UIButton *skip_btn;
@end

@implementation GSE_WalletSuccessor

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.import) {
        self.title = NSLocalizedString(@"Import Wallet",nil);
    }else{
        self.title = NSLocalizedString(@"Create Wallet",nil);
    }
    self.hideBack = YES;

    Address *address = [[GSE_Wallet shared] getAddressForWallet:self.wallet];
    
    NSString *addressString = address.checksumAddress?:@"";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setBlankLeftItem];
    
    /*CGFloat padding = -40;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat MARGIN = [UIScreen iPhonePlus] ? 20 : 15;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.4);
    
    {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:NSLocalizedString(@"Success",nil) forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x59e8c1) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:22]];
        [button setImage:[UIImage imageNamed:@"success_checked"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button alignImageToLeftWithGap:8];
        [button setUserInteractionEnabled:NO];
        [button setCenter:CGPointMake(width / 2.0, 40)];
        [self.contentView addSubview:button];
    }*/
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"%s,%@",__FUNCTION__,@(screenHeight));
    
    CGFloat padding =
    (screenHeight >= 812) ? -10 :
    (screenHeight >= 736) ? 2 :
    (screenHeight >= 667) ? -10 :
    (screenHeight >= 568  ? -30 : -30);
    
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"Current Wallet Address",nil);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont boldSystemFontOfSize:17];
        [label sizeToFit];
        label.center = CGPointMake(width / 2.0, 92 + padding);
        [self.contentView addSubview:label];
    }
    
    {
        CGRect rect = CGRectMake(0, 0, width - 2 * MARGIN - 16, 40);
        UIButton * button = [[UIButton alloc] initWithFrame:rect];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        if (width <= 320 && addressString.length == 42) {
            NSString * title = [NSString stringWithFormat:@"%@...%@",[addressString substringToIndex:15],[addressString substringFromIndex: 27]];
            [button setTitle:title forState:UIControlStateNormal];
        }else{
            [button setTitle:addressString forState:UIControlStateNormal];
        }
        [button setBackgroundColor:UIColorFromRGB(0xf8f8f8) forState:UIControlStateNormal];
        [button setAdjustsImageWhenHighlighted:NO];
        [button setImage:[UIImage imageNamed:@"icon_copy"] forState:UIControlStateNormal];
        [button alignImageToRightWithGap:8];
        [button addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
        button.center = CGPointMake(width / 2.0, 134 + padding);
        [self.contentView addSubview:button];
    }
    
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.4);
    
    self.qrcode = ({
        UIImage *image = [addressString qrCodeImage:(100 + 100 * ratio) * [UIScreen mainScreen].scale];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(width / 2.0, 210 + 88 * ratio + padding );
        imageView;
    });
    [self.contentView addSubview:self.qrcode];
    
    self.backup_btn = ({
        CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 * ratio - 50* ratio : height - 104 * ratio - 36* ratio - 50* ratio;
        CGRect rect = CGRectMake(MARGIN_2, origin + (ratio == 1? 0:padding), width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button.layer setCornerRadius:25];
        [button.layer setMasksToBounds:NO];
        [button setClipsToBounds:YES];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        //[button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(backupAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: NSLocalizedString(self.import ? @"Done" : @"Back Up Wallet",nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        //[button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.backup_btn];
    
    if (!self.import) {
        self.skip_btn = ({
            CGFloat center =
            self.backup_btn.frame.origin.y +
            self.backup_btn.frame.size.height + 30;
            
            UIButton * button = [[UIButton alloc] init];
            [button setTitle:NSLocalizedString(@"Skip",nil) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
            [button sizeToFit];
            [button setCenter:CGPointMake(width / 2.0, center)];
            [button addTarget:self action:@selector(skipAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self.contentView addSubview:self.skip_btn];
    }
}

#pragma mark - action

- (void)backupAction:(UIButton *)sender{
    if (self.import) {
        [self skipAction:sender];
    }else{
        GSE_WalletExporter *exporter = [[GSE_WalletExporter alloc] init];
        exporter.wallet = self.wallet;
        exporter.exportType = 0;
        exporter.finish = self.finish;
        [self.navigationController pushViewController:exporter animated:YES];
    }
}

- (void)skipAction:(UIButton *)sender{
    self.finish ? self.finish() : [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - action

- (void)copyAction:(id)sender{
    
    [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
    
    Address *address = [[GSE_Wallet shared] getAddressForWallet:self.wallet];
    
    NSString * addressString = address ? address.checksumAddress : @"";
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = addressString;
    
    MBProgressHUD *hud = [self finishing:NSLocalizedString(@"Copied",nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
