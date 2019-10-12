//
//  GSE_WalletAbout.m
//  wallet
//
//  Created by user on 25/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletAbout.h"
#import "GSE_AboutCell.h"

#import "GSE_WalletWebBrowser.h"

@interface GSE_WalletAbout () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation GSE_WalletAbout

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString( @"About", nil );
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;    
    self.tableView = ({
        CGRect rect = self.contentView.bounds;
        UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = ({
            CGRect frame = CGRectMake(0, 0, width, 170);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            {
                UIImage *image = [UIImage imageNamed:@"about_logo"];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.center = CGPointMake( width / 2.0, 80);
                [view addSubview:imageView];
                
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0x999999);
                    label.font = [UIFont systemFontOfSize:10];
                    label.text = NSLocalizedString(@"Sharing Economy Reimagined with Blockchain", nil);
                    //label.text = NSLocalizedString(@"The Decentralized Trust Network for Sharing Economies",nil);
                    //[label setText:@"The Decentralized Trust Network for Sharing Economies" lineSpacing:0 wordSpacing:1];
                    [label sizeToFit];
                    label.center = CGPointMake(width / 2.0, imageView.center.y + 50);
                    [view addSubview:label];
                }
            }
            
            view;
        });
        tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.contentView addSubview:self.tableView];
    
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *identifier = @"GSE_About_Cell_1";
        GSE_AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.image.image = [UIImage imageNamed:@"about_official"];
            [cell.titleLabel setText:NSLocalizedString(@"Official Site", nil) lineSpacing:0 wordSpacing:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            {
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                CGRect frame = CGRectMake( MARGIN, 50, width - 2 * MARGIN, 0);
                UIButton *button = [[UIButton alloc] initWithFrame:frame];
                [button setTitleColor:UIColorFromRGB(0x226ecd) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [button setTitle:@"https://www.gse.network" forState:UIControlStateNormal];
                [button.titleLabel setText:button.titleLabel.text lineSpacing:0 wordSpacing:1];
                [button addTarget:self action:@selector(didClickOfficialSite:) forControlEvents:UIControlEventTouchUpInside];
                [button sizeToFit];
                frame.size.height = button.bounds.size.height;
                button.frame = frame;
                [cell addSubview:button];
            }
        }
        return cell;
    }
    
    if (indexPath.row == 1) {
        static NSString *identifier = @"GSE_About_Cell_2";
        GSE_AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            cell.image.image = [UIImage imageNamed:@"about_tg"];
            [cell.titleLabel setText:NSLocalizedString(@"Telegram",nil) lineSpacing:0 wordSpacing:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            {
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                UIImage *image = [UIImage imageNamed:@"about_tg_en"];
                
                UIButton *button = [[UIButton alloc] init];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [button setTitle:@"EN" forState:UIControlStateNormal];
                [button setImage:image forState:UIControlStateNormal];
                [button sizeToFit];
                [button centerVerticallyWithPadding:7];
                [button setCenter: CGPointMake(width / 2.0 - 218/2.0, 180 / 2.0)];
                [button addTarget:self action:@selector(didClickTelegram:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
            }
            
            {
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                UIImage *image = [UIImage imageNamed:@"about_tg_cn"];
                
                UIButton *button = [[UIButton alloc] init];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [button setTitle:@"CN" forState:UIControlStateNormal];
                [button setImage:image forState:UIControlStateNormal];
                [button sizeToFit];
                [button centerVerticallyWithPadding:7];
                [button setCenter: CGPointMake(width / 2.0, 180 / 2.0)];
                [button addTarget:self action:@selector(didClickTelegram:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
            }
            
            {
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                UIImage *image = [UIImage imageNamed:@"about_tg_kr"];
                
                UIButton *button = [[UIButton alloc] init];
                [button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [button setTitle:@"KR" forState:UIControlStateNormal];
                [button setImage:image forState:UIControlStateNormal];
                [button sizeToFit];
                [button centerVerticallyWithPadding:7];
                [button setCenter: CGPointMake(width / 2.0 + 218/2.0, 180 / 2.0)];
                [button addTarget:self action:@selector(didClickTelegram:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button];
            }
        }
        return cell;
    }
    
    if (indexPath.row == 2) {
        static NSString *identifier = @"GSE_About_Cell_3";
        GSE_AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.image.image = [UIImage imageNamed:@"about_twitter"];
            [cell.titleLabel setText:NSLocalizedString(@"Twitter",nil) lineSpacing:0 wordSpacing:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            {
                CGFloat width = [UIScreen mainScreen].bounds.size.width;
                CGRect frame = CGRectMake( MARGIN, 50, width - 2 * MARGIN, 0);
                UIButton *button = [[UIButton alloc] initWithFrame:frame];
                [button setTitleColor:UIColorFromRGB(0x226ecd) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [button setTitle:@"https://twitter.com/gselabofficial" forState:UIControlStateNormal];
                [button.titleLabel setText:button.titleLabel.text lineSpacing:0 wordSpacing:1];
                [button addTarget:self action:@selector(didClickTwitter:) forControlEvents:UIControlEventTouchUpInside];
                [button sizeToFit];
                frame.size.height = button.bounds.size.height;
                button.frame = frame;
                [cell addSubview:button];
            }
        }
        return cell;
    }
    
    if (indexPath.row == 3) {
        static NSString *identifier = @"GSE_About_Cell_4";
        GSE_AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[GSE_AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.image.image = [UIImage imageNamed:@"about_wechat"];
            [cell.titleLabel setText:NSLocalizedString(@"WeChat ",nil) lineSpacing:0 wordSpacing:1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            {
                UIImage *image =[@"http://weixin.qq.com/r/jC_Lkx7EGkNlrVrw93qe" qrCodeImage:120 * [UIScreen mainScreen].scale];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                imageView.center = CGPointMake(self.view.bounds.size.width / 2.0, 226 / 2.0);
                [cell addSubview:imageView];
                
                CGFloat originY = imageView.frame.origin.y + imageView.frame.size.height + 20;
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0x333333);
                    label.font = [UIFont systemFontOfSize:12];
                    label.text = [NSString stringWithFormat:@"ID: %@",@"GSE社区"];
                    [label sizeToFit];
                    label.center = CGPointMake(self.view.bounds.size.width / 2.0, originY);
                    [cell addSubview:label];
                }
            }
            
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 170 / 2.0;
    }else if (indexPath.row == 1){
        return 254 / 2.0;
    }else if (indexPath.row == 2){
        return 170 / 2.0;
    }else if (indexPath.row == 3){
        return 394 / 2.0 + 30;
    }
    return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 3) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Open WeChat", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weixin.qq.com/r/jC_Lkx7EGkNlrVrw93qe"]];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Save QRCode to Album", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImage *image =[@"http://weixin.qq.com/r/jC_Lkx7EGkNlrVrw93qe" qrCodeImageForSave:400  * [UIScreen mainScreen].scale];
            
            NSLog(@"%@",image);
            
            if (image) {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
            
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel",nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - action

- (void)didClickOfficialSite:(id)sender{
    NSURL *url = [NSURL URLWithString:@"https://www.gse.network"];
    GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
    browser.customTitle = @"GSENetwork";
    browser.url = url;
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)didClickTwitter:(id)sender{
    
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/gselabofficial"];
    GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
    browser.customTitle = @"GSENetwork";
    browser.url = url;
    [self.navigationController pushViewController:browser animated:YES];
    
}

- (void)didClickTelegram:(UIButton *)sender{
    NSURL *url = [NSURL URLWithString:@"https://t.me/GSENetworkOfficial"];
    if ([sender.titleLabel.text isEqualToString:@"CN"]) {
        url = [NSURL URLWithString:@"https://t.me/GSENetworkOfficial_CN"];
    }else if ([sender.titleLabel.text isEqualToString:@"KR"]){
        url = [NSURL URLWithString:@"https://t.me/GSENetworkOfficial_KR"];
    }
    [[UIApplication sharedApplication] openURL:url];
}
#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
