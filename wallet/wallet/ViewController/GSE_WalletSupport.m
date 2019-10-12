//
//  GSE_WalletSupport.m
//  wallet
//
//  Created by user on 25/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletSupport.h"
#import "GSE_FAQCell.h"
#import "GSE_TableView.h"


@interface GSE_WalletSupport ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) GSE_TableView *tableView;
@property (nonatomic, strong) NSArray *questions;
@end

@implementation GSE_WalletSupport

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Feedback / Support",nil);
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.questions = [GSE_Wallet shared].faq;
    
    self.tableView = ({
        CGRect rect = self.contentView.bounds;
        GSE_TableView *tableView = [[GSE_TableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tableHeaderView = ({
            CGRect frame = CGRectMake(0, 0, width, 150);
            UIView *view = [[UIView alloc] initWithFrame:frame];
            {
                CGRect rect = CGRectMake(0, 0, width - 2 * MARGIN, 0);
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = UIColorFromRGB(0x333333);
                label.font = [UIFont systemFontOfSize:12];
                label.numberOfLines = 0;
                //label.textAlignment = NSTextAlignmentCenter;
                [label setText:NSLocalizedString(@"Should you need any assistance or have any feedback, please email us at",nil) lineSpacing:8 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake( MARGIN + label.bounds.size.width / 2.0, 50 + label.bounds.size.height / 2.0);
                [view addSubview:label];
                
                rect.size.height = 80;
                UIButton *button = [[UIButton alloc] initWithFrame:rect];
                [button setTitleColor:UIColorFromRGB(0x226ecd) forState:UIControlStateNormal];
                [button setTitle:@"support@gse.network" forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [button.titleLabel setText:button.titleLabel.text lineSpacing:0 wordSpacing:1];
                button.center = CGPointMake(width / 2.0, label.frame.origin.y + label.frame.size.height + button.frame.size.height / 2.0);
                [button addTarget:self action:@selector(emailAction:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }

            view;
        });
        tableView.tableFooterView = [UIView new];
        tableView;
    });
    [self.contentView addSubview:self.tableView];

    [self reloadData];
}

#pragma mark - data

- (void)reloadData{
    __weak typeof(self)weakSelf = self;
    Provider *provider = [[GSE_Wallet shared] getProvider];
    [[provider getFAQ:@{}] onCompletion:^(ArrayPromise * promise) {
        //NSLog(@"%@",promise.result);
        if (!promise.result) {
            return;
        }
        [GSE_Wallet shared].faq = promise.value;
        weakSelf.questions = promise.value;
        [weakSelf.tableView reloadData];
        
    }];
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"GSE_Wallet_Support_Cell";
    GSE_FAQCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GSE_FAQCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary *dic = self.questions[indexPath.row];
    
    NSString *question = dic[@"q"];
    [cell setQuestion:question];
    
    NSString *answer = dic[@"a"];
    [cell setAnswer:answer];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"GSE_Wallet_Support_Cell";
    static GSE_FAQCell *cell = nil;
    if (!cell) {
        cell = [[GSE_FAQCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.questions[indexPath.row];
    
    NSString *question = dic[@"q"];
    [cell setQuestion:question];
    
    NSString *answer = dic[@"a"];
    [cell setAnswer:answer];
    
    [cell layoutSubviews];
    return cell.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.questions.count) {
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = [self tableView:tableView heightForHeaderInSection:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = UIColorFromRGB(0x999999);
        label.font = [UIFont systemFontOfSize:14];
        [label setText:NSLocalizedString(@"FAQ:",nil) lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        label.center = CGPointMake(MARGIN + label.bounds.size.width / 2.0, height / 2.0);
        [view addSubview:label];
    }
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)emailAction:(id)sender{
    
    NSString *recipients = [NSString stringWithFormat: @"mailto:support@gse.network?subject=%@",NSLocalizedString(@"Feedback from GSE Wallet",nil)];
    
    NSDictionary *dic = [UIDevice deviceInfo];
    
    NSString * deviceTip = NSLocalizedString(@"Device",nil);
    NSString * device = dic[@"device_model_name"];
    
    NSString * versionTip = NSLocalizedString(@"Version",nil);
    
    NSString * version = dic[@"CFBundleShortVersionString"];
    NSString * build = dic[@"CFBundleVersion"];
    
    NSString * helpTip = NSLocalizedString(@"if you have any problem, write down below.", nil);
    
    NSString *body = [NSString stringWithFormat:@"&body=%@:%@ %@:%@(build %@), %@",deviceTip,device,versionTip,version,build,helpTip];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    
    email = [email stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
