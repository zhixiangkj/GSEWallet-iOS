//
//  Settings.m
//  wallet
//
//  Created by user on 18/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "Settings.h"

#import "GSE_WalletExporter.h"
#import "GSE_WalletSupport.h"
#import "GSE_WalletAbout.h"

#import "GSE_TableView.h"

#import "GSE_WalletWebBrowser.h"

@interface Settings () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) GSE_TableView *tableView;
@end

@implementation Settings

- (void)awakeFromNib{
    [super awakeFromNib];
    self.title = NSLocalizedString(@"Settings",nil);
    
    UIImage *image = [[UIImage imageNamed:@"tab_home_icon_settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIImage *selectedImage = [[UIImage imageNamed:@"tab_home_icon_settings_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.tabBarItem.image = image;
    self.tabBarItem.selectedImage = selectedImage;
    
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x4775f4)} forState:UIControlStateSelected];
    self.hideBack = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    
    self.tableView = ({
        GSE_TableView *tableView = [[GSE_TableView alloc] initWithFrame:self.contentView.bounds style:UITableViewStylePlain];
        tableView.tableFooterView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 50)];
            {
                CGRect rect = CGRectMake(MARGIN, 0, view.bounds.size.width - MARGIN * 2, 0.25);
                UIView *separator = [[UIView alloc] initWithFrame:rect];
                separator.backgroundColor = UIColorFromRGB(0xdedede);
                [view addSubview:separator];
            }
            {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = UIColorFromRGB(0x999999);
                label.font = [UIFont systemFontOfSize:13];
                NSDictionary *dic = [UIDevice deviceInfo];
                [label setText:[NSString stringWithFormat:@"v%@ Build %@",dic[@"CFBundleShortVersionString"],dic[@"CFBundleVersion"]] lineSpacing:0 wordSpacing:0.5];
                [label sizeToFit];
                [label setCenter:CGPointMake(MARGIN + label.bounds.size.width / 2.0, MARGIN + 10 + label.bounds.size.height / 2.0)];
                [view addSubview:label];
            }
            view;
        });
        tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
        tableView.separatorColor = UIColorFromRGB(0xdedede);
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView;
    });
    [self.contentView addSubview:self.tableView];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"GSE_SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Export Private Key",nil);
        }else if (indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"Export Keystore",nil);
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"Terms & Privacy Policy",nil);
        }else if (indexPath.row == 1){
            cell.textLabel.text = NSLocalizedString(@"Feedback / Support",nil);
        }else{
            cell.textLabel.text = NSLocalizedString(@"About",nil);
        }
    }
    [cell.textLabel setText:cell.textLabel.text lineSpacing:0 wordSpacing:1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,  60)];
    view.backgroundColor = [UIColor whiteColor];
    /*
    if (section == 1) {
        CGRect rect = CGRectMake(MARGIN, 0, view.bounds.size.width - MARGIN * 2, 0.25);
        UIView *separator = [[UIView alloc] initWithFrame:rect];
        separator.backgroundColor = UIColorFromRGB(0xdedede);
        [view addSubview:separator];
    }*/
    
    {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = UIColorFromRGB(0x999999);
        //label.backgroundColor = [UIColor yellowColor];
        label.text = NSLocalizedString(section == 0 ? @"" : @"Info",nil);
        [label setText:label.text lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, 86 / 2.0);
        [view addSubview:label];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        GSE_WalletExporter *exporter = [[GSE_WalletExporter alloc] init];
        NSString *current = [[GSE_Wallet shared] getCurrentWallet];
        exporter.wallet = current;
        exporter.exportType = indexPath.row == 0 ? 1 : 2;
        exporter.title = indexPath.row == 0 ? NSLocalizedString(@"Export Private Key",nil) : NSLocalizedString(@"Export Keystore",nil);
        [self.navigationController pushViewController:exporter animated:YES];
    }else{
        if (indexPath.row == 0) {
            NSURL *url = [NSURL URLWithString:GSENETWORK_HOST@"/wallet/terms"];
            GSE_WalletWebBrowser *browser = [[GSE_WalletWebBrowser alloc] init];
            if ([UIScreen mainScreen].bounds.size.width <= 320) {
                browser.customTitle = NSLocalizedString(@"Terms & Policy",nil);
            }else{
                browser.customTitle = NSLocalizedString(@"Terms & Privacy Policy",nil);
            }
            browser.url = url;
            [self.navigationController pushViewController:browser animated:YES];
        }else if (indexPath.row == 1) {
            GSE_WalletSupport *support = [[GSE_WalletSupport alloc] init];
            [self.navigationController pushViewController:support animated:YES];
        }else if (indexPath.row == 2){
            GSE_WalletAbout *about = [[GSE_WalletAbout alloc] init];
            [self.navigationController pushViewController:about animated:YES];
        }
    }
}

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
