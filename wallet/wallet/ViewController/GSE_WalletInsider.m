//
//  GSE_WalletInsider.m
//  wallet
//
//  Created by user on 26/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletInsider.h"

@interface GSE_WalletInsider ()
@property (nonatomic, strong) UILabel *header;
@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) UIButton *continue_btn;
@end

@implementation GSE_WalletInsider

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Back Up Wallet",nil);
    self.hideBack = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBlankLeftItem];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = self.contentView.bounds.size.height;
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat ratio = (screenHeight >= 736) ? 1.0 : (screenHeight >= 568 ? 0.6 : 0.6);
    NSLog(@"%s,%@,%@",__FUNCTION__,@(screenHeight),@(ratio));
    
    CGFloat padding = 40;
    
    {
        UIImage *image = [UIImage imageNamed:@"icon_export"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(width / 2.0, (53 + padding) * ratio);
        [self.contentView addSubview:imageView];
    }
    
    self.header = ({
        UILabel *label = [[UILabel alloc] init];
        
        if (self.exportType == 0) {
            label.text = NSLocalizedString(@"Your Mnemonic Phrase",nil);
        }else if (self.exportType == 1){
            label.text = NSLocalizedString(@"Your Private Key",nil);
        }else if (self.exportType == 2){
            label.text = NSLocalizedString(@"Your Keystore",nil);
        }
        
        label.font = [UIFont systemFontOfSize:22];
        label.textColor = UIColorFromRGB(0x666666);
        [label setText:label.text lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        label.center = CGPointMake(width / 2.0, 103 * ratio + padding);
        label;
    });
    [self.contentView addSubview:self.header];
    
    {
        CGRect rect = CGRectMake(MARGIN * 2,  296 / 2.0 * ratio + padding, width - MARGIN * 4 , 150 * ratio );
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = UIColorFromRGB(0xf8f8f8);
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        [self.contentView addSubview:view];
    }
    
    self.content = ({
        CGRect rect = CGRectMake(MARGIN * 2 + 5,  296 / 2.0 * ratio + 5 + padding, width - MARGIN * 4 - 10, (150 - 10) * ratio );
        UITextView *textView = [[UITextView alloc] initWithFrame:rect];
        
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = UIColorFromRGB(0x999999);
        textView.font = [UIFont systemFontOfSize:15];
        textView.editable = NO;
        //textView.userInteractionEnabled = NO;
        //textView.selectable = NO;
        //textView.textAlignment = NSTextAlignmentJustified;
        //textView.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
        
        if (self.exportType == 0) {
            textView.text = self.account.mnemonicPhrase;
            NSLog(@"%@,%@",self.account.mnemonicPhrase,self.account.mnemonicData);
        }else if (self.exportType == 1){
            textView.text = [self.account.privateKey hex];
        }else if (self.exportType == 2){
            textView.text = self.keystore;
        }
        
        textView;
    });
    [self.contentView addSubview:self.content];
    
    if (self.exportType == 2){
        CGFloat originY = self.content.frame.origin.y + 15;
        UIButton * button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"icon_copy"] forState:UIControlStateNormal];
        [button sizeToFit];
        button.center = CGPointMake( width - MARGIN * 2 - 18, originY);
        [button addTarget:self action:@selector(copyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
    }
    
    {
        CGRect frame = CGRectMake(0, 0, width - MARGIN * 2, 0);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        if (self.exportType == 0) {
            label.text = NSLocalizedString(@"Please do not take screenshot!\nWrite down your mnemonic phrase on a paper\nand keep it in a safe place",nil);
        }else if (self.exportType == 1){
            label.text = NSLocalizedString(@"Please do not take screenshot!\nWrite down your private key on a paper\nand keep it in a safe place",nil);
        }else if (self.exportType == 2){
            label.text = NSLocalizedString(@"Please do not take screenshot!\nWrite down your keystore file on a paper\nand keep it in a safe place",nil);
        }
        label.font = [UIFont italicSystemFontOfSize:12];
        label.textColor = UIColorFromRGB(0x999999);
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.textAlignment = NSTextAlignmentCenter;
        [label setText:label.text lineSpacing: ratio == 1 ?  8  : 4 wordSpacing:1];
        [label sizeToFit];
        CGFloat originY = self.content.frame.origin.y + self.content.frame.size.height + (22 + padding) * ratio;
        label.center = CGPointMake(width / 2.0, originY + label.bounds.size.height / 2.0);
        [self.contentView addSubview:label];
        if (screenHeight < 568) {
            label.hidden = YES;
        }
    }
    
    self.continue_btn = ({
        CGFloat origin = [UIScreen iPhoneX] ? height - 144 * ratio - 36 - 50 : height - 104 * ratio - 36 - 50;
        CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button.layer setCornerRadius:25];
        [button.layer setMasksToBounds:NO];
        [button setClipsToBounds:YES];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        //[button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: NSLocalizedString(@"Done",nil) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        //[button setEnabled:NO];
        button;
    });
    [self.contentView addSubview:self.continue_btn];
}

#pragma mark - action

- (void)copyAction:(id)sender{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.content.text;
    
    [GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
    
    MBProgressHUD *hud = [self finishing:NSLocalizedString(@"Copied",nil)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

- (void)nextAction:(id)sender{
    if (self.finish) {
        self.finish();
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
