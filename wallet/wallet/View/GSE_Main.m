//
//  GSE_Main.m
//  wallet
//
//  Created by user on 26/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Main.h"
#import "GSE_Rebate.h"

@interface GSE_Main () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIButton *title;
@property (nonatomic, strong) UIButton *more;
@property (nonatomic, strong) UILabel *total;
@property (nonatomic, strong) UILabel *percentage;
@property (nonatomic, strong) UIButton *send;
@property (nonatomic, strong) UIButton *receive;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tokens;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIButton *rebate;
@end

@implementation GSE_Main

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.header = ({
            
            UIImage *image = [UIImage imageNamed:@"blue_back"];
            
            CGFloat ratio =  frame.size.width / image.size.width;
            
            CGRect rect = CGRectMake(0, 0, frame.size.width, ratio * (518 / 2.0));
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.backgroundColor = [UIColor whiteColor];

            {
                
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                CGRect rect = imageView.frame;
                rect.size.width = frame.size.width;
                rect.size.height = ratio * image.size.height;
                imageView.frame = rect;
                [view addSubview:imageView];
            }
            
            {
                CGFloat originY = [UIScreen iPhoneX] ? ratio * 40 : ratio * 32;
                self.title = ({
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
                    [button setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
                    button.titleLabel.font = [UIFont systemFontOfSize:18];
                    [button setTitle:@"Wallet" forState:UIControlStateNormal];
                    [button.titleLabel setText:button.titleLabel.text lineSpacing:0 wordSpacing:1];
                    UIImage *image = [UIImage imageNamed:@"menu_arrow"];
                    [button setImage:image forState:UIControlStateNormal];
                    [button setImage:image forState:UIControlStateHighlighted];
                    //[button sizeToFit];
                    [button alignImageToRightWithGap:10];
                    if (button.bounds.size.width > 180) {
                        CGRect frame = button.frame;
                        frame.size.width = 180;
                        button.frame = frame;
                    }
                    button.center = CGPointMake(frame.size.width / 2.0, originY + 22);
                    [button addTarget:self action:@selector(titleAction:) forControlEvents:UIControlEventTouchUpInside];
                    
                    button;
                });
                [view addSubview:self.title];
                
                self.more = ({
                    CGRect rect = CGRectMake(0, 0, 44, 44);
                    UIButton *button = [[UIButton alloc] initWithFrame:rect];
                    [button setImage:[UIImage imageNamed:@"icon_more"] forState:UIControlStateNormal];
                    button.center = CGPointMake(frame.size.width - 10 - button.bounds.size.width / 2.0, self.title.center.y);
                    [button addTarget:self action:@selector(moreAction:) forControlEvents:UIControlEventTouchUpInside];
                    button;
                });
                [view addSubview:self.more];
            }
            
            {
                CGRect rect = CGRectMake(10, ratio * 168 / 2, frame.size.width - 20, ratio * (350 / 2.0));
                UIView *menu = [[UIView alloc] initWithFrame:rect];
                menu.backgroundColor = [UIColor whiteColor];
                menu.layer.cornerRadius = 5;
                menu.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
                menu.layer.borderWidth = 0.5;
                [view addSubview:menu];
                
                self.total = ({
                    UILabel * label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0x333333);
                    label.font = [UIFont boldSystemFontOfSize:26];
                    [label setText:@"$ 0.00" lineSpacing:0 wordSpacing:1.5];
                    [label sizeToFit];
                    label.center = CGPointMake(menu.frame.size.width / 2.0, ratio * (136 / 2.0));
                    label;
                });
                [menu addSubview:self.total];
                
                self.percentage = ({
                    UILabel * label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0xdbdbdb);
                    label.font = [UIFont systemFontOfSize:14];
                    [label setText:@"0%" lineSpacing:0 wordSpacing:1.5];
                    [label sizeToFit];
                    CGFloat centerX = self.total.center.x + self.total.bounds.size.width / 2.0 + label.bounds.size.width / 2.0 + 10;
                    label.center = CGPointMake( centerX, self.total.center.y + 2);
                    label;
                });
                [menu addSubview:self.percentage];
                
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0x999999);
                    label.text = NSLocalizedString(@"Total Assets",nil);
                    label.font = [UIFont systemFontOfSize:12];
                    [label sizeToFit];
                    label.center = CGPointMake(self.total.center.x, ratio * (74 / 2.0));
                    [menu addSubview:label];
                }
                
                self.send = ({
                    CGRect rect = CGRectMake(0, 0, 120, 44);
                    UIButton * button = [[UIButton alloc] initWithFrame:rect];
                    button.layer.cornerRadius = rect.size.height / 2.0;
                    button.layer.masksToBounds = YES;
                    [button setBackgroundColor:UIColorFromRGB(0x326fff) forState:UIControlStateNormal];
                    UIImage *image = [UIImage imageNamed:@"menu_send"];
                    [button setImage:image forState:UIControlStateNormal];
                    [button setImage:image forState:UIControlStateHighlighted];
                    [button setTitle:NSLocalizedString(@"  Transfer",nil) forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    button.center = CGPointMake(menu.frame.size.width / 2.0 - rect.size.width / 2.0 - 15, ratio * 248 / 2.0);
                    [button addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
                    button;
                });
                [menu addSubview:self.send];
                
                self.rebate = ({
                    UIImage *image = [UIImage imageNamed:@"rebate_free_no"];
                    UIImage *selected = [UIImage imageNamed:@"rebate_free"];
                    UIButton *button = [[UIButton alloc] init];
                    [button setImage:image forState:UIControlStateNormal];
                    [button setImage:selected forState:UIControlStateSelected];
                    [button sizeToFit];
                    button.center = CGPointMake(CGRectGetWidth(self.send.bounds) - CGRectGetWidth(button.bounds) / 2.0 + 0.5, CGRectGetHeight(button.bounds) / 2.0);
                    button.userInteractionEnabled = NO;
                    button;
                });
                [self.send addSubview:self.rebate];
                
                self.receive = ({
                    CGRect rect = CGRectMake(0, 0, 120, 44);
                    UIButton * button = [[UIButton alloc] initWithFrame:rect];
                    button.layer.cornerRadius = rect.size.height / 2.0;
                    button.layer.masksToBounds = YES;
                    [button setBackgroundColor:UIColorFromRGB(0x326fff) forState:UIControlStateNormal];
                    UIImage *image = [UIImage imageNamed:@"menu_receive"];
                    [button setImage:image forState:UIControlStateNormal];
                    [button setImage:image forState:UIControlStateHighlighted];
                    [button setTitle:NSLocalizedString(@"  Receive",nil) forState:UIControlStateNormal];
                    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                    button.center = CGPointMake(menu.frame.size.width / 2.0 + rect.size.width / 2.0 + 15, ratio * 248 / 2.0);
                    [button addTarget:self action:@selector(receiveAction:) forControlEvents:UIControlEventTouchUpInside];
                    button;
                });
                [menu addSubview:self.receive];
            }
            view;
        });
        [self addSubview:self.header];
        
        CGFloat originY = self.header.frame.origin.y + self.header.frame.size.height + 32;
        {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont systemFontOfSize:18];
            [label setText:NSLocalizedString(@"Tokens",nil) lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            CGFloat originX = ([UIScreen iPhonePlus] ? 30 : 20);
            label.center = CGPointMake( originX  + label.bounds.size.width / 2.0, originY);
            [self addSubview:label];
            originY += label.bounds.size.height / 2.0 + 5;
        }
        
        frame.origin.y = originY;
        frame.size.height -= frame.origin.y;
        frame.size.height -= 50;
        
        CGFloat margin = [UIScreen iPhonePlus] ? 20 : 15;
        
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc]
                                      initWithFrame:frame
                                      style:UITableViewStylePlain];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.backgroundColor = [UIColor whiteColor];
            tableView.separatorColor = UIColorFromRGB(0xdedede);
            
            //tableView.tableHeaderView = self.header;
            tableView.tableFooterView = [UIView new];
            tableView.separatorInset = UIEdgeInsetsMake(0, margin, 0, margin);
            tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            tableView;
        });
        [self addSubview:self.tableView];
        
        {
            UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
            refreshControl.transform = CGAffineTransformMakeScale(0.8, 0.8);
            refreshControl.tintColor = UIColorFromRGB(0xdbdbdb);
            //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
            [refreshControl addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
            self.refreshControl = refreshControl;
            
            [self.tableView addSubview:refreshControl];
        }
    }
    return self;
}

#pragma mark - delegate && datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tokens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"GSE_Main_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        //cell.backgroundColor = UIColorFromRGB(0xfdfdfd);
        
        cell.accessoryView = ({
            CGRect rect = CGRectMake(0, 0, 180, 73);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.backgroundColor = [UIColor clearColor];
            {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = UIColorFromRGB(0x333333);
                label.font = [UIFont systemFontOfSize:15];
                [label setText:@"0.0000" lineSpacing:0 wordSpacing:1];
                //label.textAlignment = NSTextAlignmentRight;
                label.backgroundColor = [UIColor clearColor];
                label.tag = 1000;
                [label sizeToFit];
                CGFloat label_width = label.bounds.size.width > 180 ? 180 :  label.bounds.size.width;
                {
                    CGRect frame = label.frame;
                    frame.size.width = label_width;
                    label.frame = frame;
                }
                label.center = CGPointMake( 180 - label_width / 2.0, 58 / 2.0);
                [view addSubview:label];
            }
            
            {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = UIColorFromRGB(0xbdbdbd);
                label.font = [UIFont systemFontOfSize:12];
                [label setText:@"$ 0.00" lineSpacing:0 wordSpacing:1];
                //label.textAlignment = NSTextAlignmentRight;
                label.backgroundColor = [UIColor clearColor];
                label.tag = 2000;
                [label sizeToFit];
                CGFloat label_width = label.bounds.size.width > 180 ? 180 : label.bounds.size.width;
                {
                    CGRect frame = label.frame;
                    frame.size.width = label_width;
                    label.frame = frame;
                }
                label.center = CGPointMake( 180 - label_width / 2.0, 104 / 2.0);
                [view addSubview:label];
            }
            view;
        });
    }
    NSDictionary *dic = self.tokens[indexPath.row];
    
    //NSString *tokenImg = dic[@"tokenImg"];
    
    cell.textLabel.text = dic[@"symbol"] ? : @"";
    
    if ([cell.textLabel.text isEqualToString:@"GSE"]) {
        cell.imageView.image =  [UIImage imageNamed:@"icon_gse"];
    }else if ([cell.textLabel.text isEqualToString:@"ETH"]) {
        cell.imageView.image =  [UIImage imageNamed:@"icon_coin"];
    }
    else{
        cell.imageView.image =  [UIImage imageNamed:@"icon_default"];
    }
    [cell.textLabel setText:cell.textLabel.text lineSpacing:0 wordSpacing:1];
    
    {
        UILabel *label = (UILabel *) [cell.accessoryView viewWithTag:1000];
        [label setText: dic[@"quantity"]? :@"0.0000" lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        CGFloat label_width = label.bounds.size.width > 180 ? 180 :  label.bounds.size.width;
        {
            CGRect frame = label.frame;
            frame.size.width = label_width;
            label.frame = frame;
        }
        label.center = CGPointMake( 180 - label_width / 2.0, 58 / 2.0);
    }
    
    {
        UILabel *label = (UILabel *) [cell.accessoryView viewWithTag:2000];
        [label setText: dic[@"valueInUSD"]? :@"$0.00" lineSpacing:0 wordSpacing:1];
        [label sizeToFit];
        CGFloat label_width = label.bounds.size.width > 180 ? 180 : label.bounds.size.width;
        {
            CGRect frame = label.frame;
            frame.size.width = label_width;
            label.frame = frame;
        }
        label.center = CGPointMake( 180 - label_width / 2.0, 104 / 2.0);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.delegate respondsToSelector:@selector(main:didSelectToken:)]) {
        NSDictionary *token = self.tokens[indexPath.row];
        [self.delegate main:self didSelectToken:token];
    }
}
#pragma mark - reload

- (void)setCanRebate:(BOOL)canRebate{
    _canRebate = canRebate;
    self.rebate.selected = canRebate;
}

- (void)setTotalUSD:(NSString *)totalUSD{
    _totalUSD = totalUSD;
    UILabel *label = self.total;
    CGPoint point = label.center;
    [label setText:totalUSD lineSpacing:0 wordSpacing:1.5];
    [label sizeToFit];
    {
        CGRect frame = label.frame;
        if (frame.size.width > label.superview.bounds.size.width - 60) {
            frame.size.width = label.superview.bounds.size.width - 60;
        }
        label.frame = frame;
    }
    label.center = point;
}

- (void)setPercentageChange:(NSString *)asset{
    _percentageChange = asset;
    
    UILabel *label = self.percentage;
    CGPoint center = label.center;
    NSString *assetValue = [asset stringByReplacingOccurrencesOfString:@"%%" withString:@""];
    if ([asset hasPrefix:@"+"] || assetValue.doubleValue > 0) {
        label.textColor = UIColorFromRGB(0x47b930);
    }else if ([asset hasPrefix:@"-"]){
        label.textColor = UIColorFromRGB(0xe83c3c);
    }else{
        label.textColor = UIColorFromRGB(0xdbdbdb);
    }
    [label setText:asset lineSpacing:0 wordSpacing:1.5];
    [label sizeToFit];
    CGFloat centerX = self.total.center.x + self.total.bounds.size.width / 2.0 + label.bounds.size.width / 2.0 + 10;
    label.center = CGPointMake( centerX, center.y);
}

- (void)setWallet:(NSString *)wallet{
    _wallet = wallet;
    [self reloadData];
}

- (void)refresh{
    [self.tableView setContentOffset:CGPointZero];
    dispatch_async(dispatch_get_main_queue(), ^{
        CGPoint point = CGPointMake(0, -self.refreshControl.frame.size.height * 0.8);
        [self.tableView setContentOffset:point animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.refreshControl beginRefreshing];
            [self refreshAction:self.refreshControl];
        });
    });
}

- (void)reloadData{
    
    UIButton *button = self.title;
    //[button setBackgroundColor:[UIColor yellowColor] forState:UIControlStateNormal];
    CGPoint point = CGPointMake(button.center.x, button.center.y);
    
    NSString *wallet = self.wallet;
    if (!wallet || !wallet.length) {
        wallet = @"Wallet";
    }
    [button setTitle: wallet forState:UIControlStateNormal];
    [button.titleLabel setText:button.titleLabel.text lineSpacing:0 wordSpacing:1];
    //[button sizeToFit];
    [button alignImageToRightWithGap:10];
    
    if (button.bounds.size.width > 180) {
        CGRect frame = button.frame;
        frame.size.width = 180;
        button.frame = frame;
    }
    
    button.center = point;
    
    GSE_Wallet *shared = [GSE_Wallet shared];
    Address *address = [shared getAddressForWallet:self.wallet];
    if (!address) {
        return;
    }
    NSDictionary *tokensInfo = [shared getTokensForAddress:address];
    if ([tokensInfo isKindOfClass:[NSArray class]]) {
        tokensInfo = @{@"tokens":tokensInfo};
    }else{
        NSString *totalusd = tokensInfo[@"totalusd"];
        totalusd ? self.totalUSD = totalusd : nil;
        
        NSString *percentchange = tokensInfo[@"usdpercentagechange"];
        percentchange ? self.percentageChange = percentchange : nil;
    }
    NSArray *tokens = [tokensInfo isKindOfClass:[NSDictionary class]] ? tokensInfo[@"tokens"] : nil;
    if (!tokens || !tokens.count) {
        tokens = @[@{@"name" : @"Ethereum (ETH)",@"symbol":@"ETH",@"decimals":@(18)}];
    }
    NSMutableArray *array = [NSMutableArray array];
    [tokens enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *symbol = obj[@"symbol"];
            if ( [symbol isKindOfClass:[NSString class]] && symbol.length ){
                    
                if ([symbol isEqualToString:@"ETH"]) {
                    [array insertObject:obj atIndex:0];
                }else{
                    [array addObject:obj];
                }
            }
        }
    }];
    self.tokens = array;
    
    GSE_RebateCode *rebate = [[GSE_RebateCode alloc] init];
    [rebate addEntriesFromDictionray: [shared getRebateForClient:shared.getClientid]];
    self.rebate.selected = rebate.rebates.boolValue;
    [self.tableView reloadData];
}

#pragma mark - action

- (void)refreshAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(refreshAction:)]) {
        [self.delegate refreshAction:sender];
    }
}

- (void)sendAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(main:didClickSend:)]) {
        [self.delegate main:self didClickSend:sender];
    }
}

- (void)receiveAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(main:didClickReceive:)]) {
        [self.delegate main:self didClickReceive:sender];
    }
}

- (void)moreAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(main:didClickMore:)]) {
        [self.delegate main:self didClickMore:sender];
    }
}

- (void)titleAction:(id)sender{
    
    /*[UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.title.imageView.transform = NO ? CGAffineTransformIdentity: CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        
    }];*/
    
    if ([self.delegate respondsToSelector:@selector(main:didClickTitle:)]) {
        [self.delegate main:self didClickTitle:sender];
    }
}

@end
