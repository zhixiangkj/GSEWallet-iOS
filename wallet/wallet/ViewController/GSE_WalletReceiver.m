//
//  GSE_WalletReceiver.m
//  wallet
//
//  Created by user on 03/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletReceiver.h"

@interface GSE_WalletReceiver ()
@property (nonatomic, strong) UIImageView *qrcode;
@property (nonatomic, strong) UIButton *share_btn;
@end

@implementation GSE_WalletReceiver

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Receive",nil);
    
    Address *address = [[GSE_Wallet shared] getAddressForWallet:self.wallet];
    
    NSString * addressString = address ? address.checksumAddress : @"";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self setBlankLeftItem];
    
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
    
    self.share_btn = ({
        CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 * ratio - 50* ratio : height - 104 * ratio - 36* ratio - 50* ratio;
        CGRect rect = CGRectMake(MARGIN_2, origin + (ratio == 1? 0:padding), width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button.layer setCornerRadius:25];
        [button.layer setMasksToBounds:NO];
        [button setClipsToBounds:YES];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        //[button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: NSLocalizedString(@"Share",nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [button addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        //[button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.share_btn];
    
}

#pragma mark - action

- (void)copyAction:(id)sender{
    
    Address *address = [[GSE_Wallet shared] getAddressForWallet:self.wallet];
    
    NSString * addressString = address ? address.checksumAddress : @"";
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = addressString;
    
    [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
    
    MBProgressHUD *hud = [self finishing:NSLocalizedString(@"Copied",nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

- (void)shareAction:(UIButton *)sender{
    
    Address *address = [[GSE_Wallet shared] getAddressForWallet:self.wallet];
    
    NSString * addressString = address ? address.checksumAddress : @"";
    
    if (!addressString.length) {
        return;
    }
    
    UIImage *image = [addressString qrCodeImageForSave:400  * [UIScreen mainScreen].scale];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Address Text", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *itemsToShare = @[addressString];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:itemsToShare applicationActivities:nil];
        
        [self presentViewController:activityVC animated:YES completion:nil];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Address QRCode",nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *itemsToShare = @[image];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:itemsToShare applicationActivities:nil];
        
        [self presentViewController:activityVC animated:YES completion:nil];
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)skipAction:(UIButton *)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
