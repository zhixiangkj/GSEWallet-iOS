//
//  GSE_Menu.m
//  wallet
//
//  Created by user on 26/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Menu.h"

@interface GSE_Menu () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *background_mask;
@property (nonatomic, strong) UIView *background_menu;

@property (nonatomic, strong) UIButton *head;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *menuArray;
@end

@implementation GSE_Menu

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
        frame.size.width = 300;
        self.background_menu = ({
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = [UIColor whiteColor];
            view;
        });
        [self addSubview:self.background_menu];
        
        self.menuArray = @[
          @[@{@"title":@"Wallets",@"icon":@"menu_wallet"}],
          @[@{@"title":NSLocalizedString(@"Create Wallet",nil),@"icon":@"menu_create"},
            @{@"title":NSLocalizedString(@"Import Wallet",nil),@"icon":@"menu_import"}
          ],
          @[@{@"title":@"Settings",@"icon":@"menu_settings"}]
        ];
        
        CGFloat headHeight = [UIScreen iPhoneX] ? 180 :120;
        {
            CGRect headFrame = CGRectMake(0, 0, frame.size.width, headHeight);
            UIView * view = [[UIView alloc] initWithFrame:headFrame];
            view.backgroundColor = [UIColor whiteColor];
            [self.background_menu addSubview:view];
            
            self.head = ({
                UIButton * button = [[UIButton alloc] init];
                [button setImage:[UIImage imageNamed:@"sample_head.png"] forState:UIControlStateNormal];
                [button sizeToFit];
                button.center = CGPointMake(MARGIN + button.bounds.size.width / 2.0, [UIScreen iPhoneX] ? 130: 70);
                button;
            });
            [view addSubview:self.head];
            
            self.name = ({
                UILabel * label = [[UILabel alloc] init];
                label.text = @"Libby";
                label.font = [UIFont systemFontOfSize:15];
                [label sizeToFit];
                CGFloat centerX = MARGIN + self.head.bounds.size.width + 20 + label.bounds.size.width / 2.0;
                label.center = CGPointMake( centerX, [UIScreen iPhoneX] ? 130: 70);
                label;
            });
            [view addSubview:self.name];
        }
        
        frame.origin.y = headHeight;
        frame.size.height -= frame.origin.y;
                
        self.tableView = ({
            UITableView *tableView = [[UITableView alloc]
                                      initWithFrame:frame
                                      style:UITableViewStylePlain];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.backgroundColor = UIColorFromRGB(0xfbfbfb);
            tableView.tableFooterView = [UIView new];
            tableView.separatorColor = UIColorFromRGB(0xfbfbfb);
            tableView.separatorInset = UIEdgeInsetsMake(0, MARGIN, 0, MARGIN);
            tableView;
        });
        [self.background_menu addSubview:self.tableView];
    }
    return self;
}

#pragma mark - delegate && datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.menuArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menuArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"GSE_Menu_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    NSDictionary *info = self.menuArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:info[@"icon"]];
    cell.textLabel.text = info[@"title"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    CGRect rect = CGRectMake(0, 0, 300, 20);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = UIColorFromRGB(0xfbfbfb);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self close:^{
                if ([self.delegate respondsToSelector:@selector(menu:runCreateWallet:)]) {
                    [self.delegate menu:self runCreateWallet:YES];
                }
            }];
        }else if (indexPath.row == 1){
            [self close:^{
                if ([self.delegate respondsToSelector:@selector(menu:runImportWallet:)]) {
                    [self.delegate menu:self runImportWallet:YES];
                }
            }];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            [self close:^{
                if ([self.delegate respondsToSelector:@selector(menu:runSettings:)]) {
                    [self.delegate menu:self runSettings:YES];
                }
            }];
        }
    }
}

#pragma mark - action

- (void)open{
    self.hidden = NO;
    self.background_mask.hidden = NO;
    
    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.background_menu.frame;
        frame.origin.x = 0;
        self.background_menu.frame = frame;
        self.background_mask.alpha = 0.3;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)close{
    
    self.background_mask.alpha = 0;
    self.background_mask.hidden = YES;
    self.hidden = YES;
    
    CGRect frame = self.background_menu.frame;
    frame.origin.x = -300;
    self.background_menu.frame = frame;
}

- (void)close:(void(^)(void))finish{
    
    [UIView animateWithDuration:0.2f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.background_menu.frame;
        frame.origin.x = -300;
        self.background_menu.frame = frame;
        self.background_mask.alpha = 0;
    } completion:^(BOOL finished) {
        self.background_mask.hidden = YES;
        self.hidden = YES;
    }];
    
    if(finish){
        finish();
    }
}

- (void)closeAction:(UITapGestureRecognizer *)tap{
    [self close:nil];
}

@end
