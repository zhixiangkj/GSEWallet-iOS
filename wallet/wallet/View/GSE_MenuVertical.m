//
//  GSE_MenuVertical.m
//  wallet
//
//  Created by user on 19/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_MenuVertical.h"

@interface GSE_MenuVertical() <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *background_mask;
@property (nonatomic, strong) UIView *background_menu;

@property (nonatomic, strong) UILabel *total;
@property (nonatomic, strong) UILabel *total_tip;
@property (nonatomic, strong) UILabel *title_label;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *close_btn;

@property (nonatomic, strong) NSArray *wallets;
@property (nonatomic, strong) NSDictionary *addresses;
@end

@implementation GSE_MenuVertical

- (instancetype)init
{
    CGRect rect = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.background_mask = ({
            UIView *view = [[UIView alloc] initWithFrame:self.bounds];
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.3;
            view;
        });
        [self addSubview:self.background_mask];
        
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeAction:)];
            [self.background_mask addGestureRecognizer:tap];
        }
        
        CGRect frame = rect;
        
        UIImage *image = [UIImage imageNamed:@"blue_back"];
        
        CGFloat ratio =  self.bounds.size.width / image.size.width;
        
        frame.origin.y = 84 * ratio / 5.0 * 4;
        frame.size.height -= frame.origin.y;
        
        self.background_menu = ({
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = UIColorFromRGB(0xf9f9f9);
            view.layer.cornerRadius = 5;
            view;
        });
        [self addSubview:self.background_menu];
        
        {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont boldSystemFontOfSize:18];
            [label setText:NSLocalizedString(@"My Wallets",nil) lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            CGFloat originX = ([UIScreen iPhonePlus] ? 20 : 20);
            label.center = CGPointMake( originX + label.bounds.size.width / 2.0, 40);
            self.title_label = label;
            [self.background_menu addSubview:label];
        }
        self.close_btn = ({
            CGRect rect = CGRectMake(0, 0, 44, 44);
            UIButton *button = [[UIButton alloc] initWithFrame:rect];
            UIImage *image = [UIImage imageNamed:@"menu_wallet_close"];
            [button setImage:image forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateHighlighted];
            //[button sizeToFit];
            button.center = CGPointMake(self.bounds.size.width / 2.0 , 20);
            [button addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        [self.background_menu addSubview:self.close_btn];
        self.total = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont systemFontOfSize:15];
            [label setText:@"$ 0.00" lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake( self.bounds.size.width - 15 - label.bounds.size.width / 2, 40);
            label;
        });
        [self.background_menu addSubview:self.total];
        
        {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x999999);
            label.font = [UIFont systemFontOfSize:10];
            label.text = NSLocalizedString(@"Total Assets",nil);
            [label sizeToFit];
            label.center = CGPointMake(self.total.frame.origin.x - 10 - label.bounds.size.width / 2, 40);
            [self.background_menu addSubview:label];
            self.total_tip = label;
        }
        
        self.tableView = ({
            CGFloat originY = 156 / 2.0;
            CGRect rect = CGRectMake(15, originY,
                                     self.bounds.size.width - 30,
                                     self.background_menu.bounds.size.height - originY);
            UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.backgroundColor = [UIColor clearColor];
            tableView.separatorColor = self.background_menu.backgroundColor;
            tableView;
        });
        
        [self.background_menu addSubview:self.tableView];
        
        [self reloadData];
    }
    return self;
}

- (void)setHideTotalAssets:(BOOL)hideTotalAssets{
    _hideTotalAssets = hideTotalAssets;
    
    self.total_tip.hidden = YES;
    self.total.hidden = _hideTotalAssets;
    [self reloadData];
}

#pragma mark - reload

- (void)reloadData{
    self.wallets = [[GSE_Wallet shared] getWallets];
    self.addresses = [[GSE_Wallet shared] getAddresses];
    
    NSLog(@"wallets: %@",self.wallets);
    
    [self.tableView reloadData];
    
    UILabel *label = self.total;
    
    NSString *totalAssets = [[GSE_Wallet shared] getTotalAssets];
    [label setText:totalAssets lineSpacing:0 wordSpacing:1];
    [label sizeToFit];
    label.center = CGPointMake(self.bounds.size.width - 15 - label.bounds.size.width / 2, 40);
    
    label = self.total_tip;
    label.center = CGPointMake(self.total.frame.origin.x - 10 - label.bounds.size.width / 2, 40);
    
    if (self.menuTitle) {
        UILabel *label = self.title_label;
        [label setText:self.menuTitle lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        CGFloat originX = ([UIScreen iPhonePlus] ? 20 : 20);
        label.center = CGPointMake( originX + label.bounds.size.width / 2.0, label.center.y);
    }
}

#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2 + self.wallets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < self.wallets.count) {
        return 1;
    }
    if (self.hideCreateAndImport) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section >= self.wallets.count) {
        static NSString *identifier = @"GSE_MenuVerticalCellMenu";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.textColor = UIColorFromRGB(0x2f7cf6);
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            UIImage * image = [UIImage imageNamed:@"wallet_add"];
            cell.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [cell.imageView setTintColor:UIColorFromRGB(0x2f7cf6)];
        }
        
        if (indexPath.section == self.wallets.count) {
            [cell.textLabel setText:NSLocalizedString(@"Create Wallet",nil) lineSpacing:0 wordSpacing:1];
        }else if (indexPath.section == self.wallets.count + 1) {
            [cell.textLabel setText:NSLocalizedString(@"Import Wallet",nil) lineSpacing:0 wordSpacing:1];
        }
        
        return cell;
    }else{
        static NSString *identifier = @"GSE_MenuVerticalCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            
            cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            
            cell.layer.cornerRadius = 5;
            cell.layer.masksToBounds = YES;
            cell.imageView.image = [UIImage imageNamed:@"icon_coin"];
            
            CGFloat width = 80;
            if (!self.hidePercentage) {
                cell.accessoryView = ({
                    CGRect rect = CGRectMake(0, 0, width, 40);
                    UIView *view = [[UIView alloc] initWithFrame:rect];
                    {
                        UILabel *label = [[UILabel alloc] init];
                        label.textColor = UIColorFromRGB(0x333333);
                        label.font = [UIFont systemFontOfSize:15];
                        [label setText:@"$ 0.00" lineSpacing:0 wordSpacing:1];
                        [label sizeToFit];
                        {
                            CGRect frame = label.frame;
                            if (frame.size.width > width) {
                                frame.size.width = width;
                            }
                            label.frame = frame;
                        }
                        label.center = CGPointMake(width - label.bounds.size.width / 2.0, 12);
                        label.tag = 7777;
                        [view addSubview:label];
                    }
                    
                    {
                        UILabel *label = [[UILabel alloc] init];
                        label.textColor = UIColorFromRGB(0xdbdbdb);
                        label.font = [UIFont systemFontOfSize:12];
                        [label setText:@"+ 0%" lineSpacing:0 wordSpacing:1];
                        [label sizeToFit];
                        {
                            CGRect frame = label.frame;
                            if (frame.size.width > width) {
                                frame.size.width = width;
                            }
                            label.frame = frame;
                        }
                        label.center = CGPointMake(width - label.bounds.size.width / 2.0, 32);
                        label.tag = 7778;
                        [view addSubview:label];
                    }
                    view;
                });
            }
        }
        
        CGFloat width = 80;
        NSString *wallet = self.wallets[indexPath.section];
        [cell.textLabel setText:wallet lineSpacing:0 wordSpacing:1];
        Address *address = self.addresses[wallet];
        cell.detailTextLabel.text = address.checksumAddress;
        {
            NSString *asset = [[GSE_Wallet shared] getAssetsForAddress:address];
            NSLog(@"asset: %@",asset);
            UILabel *label = [cell.accessoryView viewWithTag:7777];
            [label setText:asset lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            {
                CGRect frame = label.frame;
                if (frame.size.width > width) {
                    frame.size.width = width;
                }
                label.frame = frame;
            }
            label.center = CGPointMake(width - label.bounds.size.width / 2.0, 12);
        }
        {
            NSString *asset = [[GSE_Wallet shared] getAssetsPercentageForAddress:address];
            UILabel *label = [cell.accessoryView viewWithTag:7778];
            [label setText:asset lineSpacing:0 wordSpacing:1];
            NSString *assetValue = [asset stringByReplacingOccurrencesOfString:@"%%" withString:@""];
            if ([asset hasPrefix:@"+"] || assetValue.doubleValue > 0) {
                label.textColor = UIColorFromRGB(0x47b930);
            }else if ([asset hasPrefix:@"-"]){
                label.textColor = UIColorFromRGB(0xe83c3c);
            }else{
                label.textColor = UIColorFromRGB(0xdbdbdb);
            }
            [label sizeToFit];
            {
                CGRect frame = label.frame;
                if (frame.size.width > width) {
                    frame.size.width = width;
                }
                label.frame = frame;
            }
            label.center = CGPointMake(width - label.bounds.size.width / 2.0, 32);
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width, 10);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = self.background_menu.backgroundColor;
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section >= self.wallets.count) {
        if (indexPath.section == self.wallets.count) {
            if ([self.delegate respondsToSelector:@selector(menu:runCreateWallet:)]) {
                [self.delegate menu:self runCreateWallet:YES];
            }
            /*[self close:^{

            }];*/
        }else{
            if ([self.delegate respondsToSelector:@selector(menu:runImportWallet:)]) {
                [self.delegate menu:self runImportWallet:YES];
            }
            /*[self close:^{

            }];*/
        }
    }else{
        NSString *wallet = self.wallets[indexPath.section];
        if ([self.delegate respondsToSelector:@selector(menu:runSelectWallet:)]) {
            [self.delegate menu:self runSelectWallet:wallet];
        }
    }
}

#pragma mark - action

- (void)toggle:(void(^)(void))finish{
    if (self.background_menu.frame.origin.y ==
        [UIScreen mainScreen].bounds.size.height) {
        [self open:finish];
    }else{
        [self close:finish];
    }
}

- (void)open:(void(^)(void))finish{
    self.hidden = NO;
    self.background_mask.hidden = NO;
    
    UIImage *image = [UIImage imageNamed:@"blue_back"];
    
    CGFloat ratio =  self.bounds.size.width / image.size.width;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.background_menu.frame;
        frame.origin.y = 84 * ratio / 5.0 * 4;
        self.background_menu.frame = frame;
        self.background_mask.alpha = 0.3;
        self.viewIsAnimating = YES;
    } completion:^(BOOL finished) {
        self.viewIsAnimating = NO;
        if (finish) {
            finish();
        }
    }];
}

- (void)open{
    [self open:nil];
}

- (void)close{
    
    self.background_mask.alpha = 0;
    self.background_mask.hidden = YES;
    self.hidden = YES;
    
    CGRect frame = self.background_menu.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.background_menu.frame = frame;
}

- (void)close:(void(^)(void))finish{
    
    //[GSE_HapticHelper generateFeedback:FeedbackType_Notification_Success];
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.background_menu.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        self.background_menu.frame = frame;
        self.background_mask.alpha = 0;
        self.viewIsAnimating = YES;
    } completion:^(BOOL finished) {
        self.background_mask.hidden = YES;
        self.hidden = YES;
        self.viewIsAnimating = NO;
        
        if(finish){
            finish();
        }
    }];
}

- (void)closeAction:(UITapGestureRecognizer *)tap{
    [self close:^{
        if ([self.delegate respondsToSelector:@selector(closeAction:)]) {
            [self.delegate closeAction:tap];
        }
    }];
}

@end
