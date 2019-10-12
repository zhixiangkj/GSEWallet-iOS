//
//  GSE_Discover.m
//  wallet
//
//  Created by user on 20/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Discover.h"
#import "GSE_WebViewController.h"
#import "GSEWallet-Swift.h"
#define COLLECTION_PADDING ([UIScreen iPhonePlus] ? 30 : 20)
@interface GSE_Discover () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *gseWalletServices; // gse钱包提供的服务
@end
static NSString * const discoverCollectionCell = @"discoverCollectionCell";
@implementation GSE_Discover
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
#ifdef DEBUG
    self.gseWalletServices =
    @[
      // ofo生产环境（debug调试的时候，访问的是本地服务）
      @{@"image": @"service_card_1", @"url": OFO_H5_URL},
      // ofo测试环境
      @{@"image": @"service_card_2", @"url": @"https://dapp.gsenetwork.co"},
      // 访问项目内部的网址(用于cordova集成插件的测试)
      @{@"image": @"service_card_3", @"url": @""}
    ];
#else
    self.gseWalletServices =
    @[
      @{@"image": @"service_card_1", @"url": OFO_H5_URL}
      ];
#endif
    if (self) {
        self.header = ({
            
            UIImage *image = [UIImage imageNamed:@"blue_back_discover"];
            
            CGFloat ratio =  frame.size.width / image.size.width;
            
            CGRect rect = CGRectMake(0, 0, frame.size.width, ratio * (700 / 2.0));
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
                self.title = ({
                    UILabel *label = [[UILabel alloc] init];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont boldSystemFontOfSize:18];
                    [label setText:@"Discover" lineSpacing:0 wordSpacing:1];
                    [label sizeToFit];
                    label.center = CGPointMake(frame.size.width / 2.0, 60);
                    label;
                });
                [view addSubview:self.title];
            }
            
            {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont boldSystemFontOfSize:24];
                [label setText:@"GSENetwork" lineSpacing:0 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake(frame.size.width / 2, ratio * 120);
                [view addSubview:label];
            }
            
            {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = [UIColor whiteColor];
                label.font = [UIFont systemFontOfSize:12];
                label.numberOfLines = 0;
                [label setText:@"Explore services, Dapps, Green Mining\n and more in the decentralised world" lineSpacing:8 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake(frame.size.width / 2, ratio * 330 / 2.0);
                [view addSubview:label];
            }
        
            {
                CGRect rect = CGRectMake(10, ratio * 400 / 2, frame.size.width - 20, ratio * (300 / 2.0));
                UIView *menu = [[UIView alloc] initWithFrame:rect];
                menu.backgroundColor = [UIColor whiteColor];
                menu.layer.cornerRadius = 5;
                menu.layer.borderColor = UIColorFromRGB(0xdedede).CGColor;
                menu.layer.borderWidth = 0.5;
                [view addSubview:menu];
                
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0x333333);
                    label.font = [UIFont systemFontOfSize:15];
                    [label setText:@"Green Mining" lineSpacing:0 wordSpacing:1];
                    [label sizeToFit];
                    label.center = CGPointMake(15 + label.bounds.size.width / 2, 25);
                    [menu addSubview:label];
                }
                {
                    CGRect rect = CGRectMake(15, 45, menu.bounds.size.width - 30, 0.5);
                    UIView *view = [[UIView alloc] initWithFrame:rect];
                    view.backgroundColor = UIColorFromRGB(0xdedede);
                    [menu addSubview:view];
                }
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0x666666);
                    label.font = [UIFont systemFontOfSize:12];
                    [label setText:@"Token" lineSpacing:0 wordSpacing:1];
                    [label sizeToFit];
                    label.center = CGPointMake(20 + label.bounds.size.width / 2.0, 80);
                    [menu addSubview:label];
                    
                    {
                        UIImage *image = [UIImage imageNamed:@"icon_gse"];
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                        imageView.center = CGPointMake(label.center.x, 110);
                        [menu addSubview:imageView];
                    }
                }
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0x666666);
                    label.font = [UIFont systemFontOfSize:12];
                    [label setText:NSLocalizedString(@"Amount",nil) lineSpacing:0 wordSpacing:1];
                    [label sizeToFit];
                    label.center = CGPointMake(210 / 2.0 + label.bounds.size.width / 2.0, 80);
                    [menu addSubview:label];
                    
                    {
                        UILabel *value = [[UILabel alloc] init];
                        value.textColor = UIColorFromRGB(0x333333);
                        value.font = [UIFont systemFontOfSize:15];
                        [value setText:@"1,492" lineSpacing:0 wordSpacing:1];
                        [value sizeToFit];
                        value.center = CGPointMake(label.center.x, 110);
                        [menu addSubview:value];
                    }
                }
                {
                    UILabel *label = [[UILabel alloc] init];
                    label.textColor = UIColorFromRGB(0x666666);
                    label.font = [UIFont systemFontOfSize:12];
                    [label setText:@"Worth" lineSpacing:0 wordSpacing:1];
                    [label sizeToFit];
                    label.center = CGPointMake(400 / 2.0 + label.bounds.size.width / 2.0, 80);
                    [menu addSubview:label];
                    
                    {
                        UILabel *value = [[UILabel alloc] init];
                        value.textColor = UIColorFromRGB(0x333333);
                        value.font = [UIFont systemFontOfSize:15];
                        [value setText:@"$24.22" lineSpacing:0 wordSpacing:1];
                        [value sizeToFit];
                        value.center = CGPointMake(label.center.x, 110);
                        [menu addSubview:value];
                    }
                }
                {
                    CGRect rect = CGRectMake(0, 0, 134/2.0, 22);
                    UIButton *button = [[UIButton alloc] initWithFrame:rect];
                    button.layer.cornerRadius = rect.size.height / 2.0;
                    button.layer.masksToBounds = YES;
                    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
                    [button setTitle:@"Collect" forState:UIControlStateNormal];
                    [button.titleLabel setText:button.titleLabel.text lineSpacing:0 wordSpacing:1];
                    [button setBackgroundColor:UIColorFromRGB(0x3e72fd) forState:UIControlStateNormal];
                    button.center = CGPointMake(menu.frame.size.width - 20 - button.bounds.size.width / 2.0, 110);
                    [menu addSubview:button];
                }
            }
            view;
        });
        [self addSubview:self.header];
        
        CGFloat originY = self.header.frame.origin.y + self.header.frame.size.height + 32;
        {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = UIColorFromRGB(0x333333);
            label.font = [UIFont systemFontOfSize:18];
            [label setText:@"Services" lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            label.center = CGPointMake(COLLECTION_PADDING  + label.bounds.size.width / 2.0, originY);
            
            [self addSubview:label];
            UIButton *button = [[UIButton alloc] init];
            [button setTitle:@"订单" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(PRIMARY_COLOR) forState:UIControlStateNormal];
            [button sizeToFit];
            button.center = CGPointMake(SCREEN_WIDTH - COLLECTION_PADDING - button.bounds.size.width / 2.0, originY);
            [self addSubview:button];
            [button addTarget:self action:@selector(handleOrderButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            originY += label.bounds.size.height / 2.0 + 5;
        }
    
        
        {
            CGRect rect = CGRectMake(MARGIN, originY + 10, frame.size.width - MARGIN * 2, 0.5);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            view.backgroundColor = UIColorFromRGB(0xdedede);
            [self addSubview:view];
        }
        
        frame.origin.y = originY + 40;
        frame.size.height -= frame.origin.y;
       
        self.collectionView = ({
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
            [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
            // 设置CollectionView的属性
            UICollectionView *collectionView = [[UICollectionView alloc]
                                      initWithFrame:frame collectionViewLayout:flowLayout];
             collectionView.backgroundColor = [UIColor clearColor];
            collectionView.dataSource = self;
            collectionView.delegate = self;
            collectionView.scrollEnabled = YES;
            collectionView.bounces = YES;
            [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:discoverCollectionCell];
            collectionView;
        });
        [self addSubview:self.collectionView];
    }
    return self;
}
// "订单"按钮点击
-(void)handleOrderButtonTapped: (UIButton *) button {
    if (self.hostVC != nil) {
        GSE_OrderList* vc = [[GSE_OrderList alloc]initWithNibName:@"GSE_OrderList" bundle:nil];
        vc.hidesBottomBarWhenPushed = YES;
        [self.hostVC.navigationController pushViewController:vc animated:YES];
    }
   
}
// MARK: 打开wevbview 访问站点
- (void)visitWebsit: (NSString *)urlStr {
    if (self.hostVC != nil) {
        GSE_WebViewController *vc = [[GSE_WebViewController alloc] init];
        if (urlStr != nil && urlStr.length > 0) {
            vc.wwwFolderName = @"";
            vc.startPage = urlStr;
        }
        vc.hidesBottomBarWhenPushed = YES;
         [self.hostVC.navigationController pushViewController:vc animated:YES];
    }
   
}
// TODO: stripe支付测试
- (void)gsePayTest: (UIButton *)sender {
    [[GSE_Pay shared] popupPayViewWithAmount:1 country:nil currency:nil attachView:self completion:^(GSE_PayStatus status, NSDictionary * info) {
        
    }];
}

#pragma mark - UICollectionViewDataSource
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gseWalletServices.count;
    
}

#pragma mark  设置CollectionCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *service = self.gseWalletServices[indexPath.row];
    UIImage *image = [UIImage imageNamed:service[@"image"]];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:discoverCollectionCell forIndexPath:indexPath];
    CGFloat width = cell.bounds.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width * image.size.height / image.size.width)];
    imageView.image = image;
    [cell.contentView addSubview: imageView];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
#pragma mark  定义每个UICollectionView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 3*COLLECTION_PADDING) / 2;
    return  CGSizeMake(width, 133 * width / 155);
}



#pragma mark  定义整个CollectionViewCell与整个View的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, COLLECTION_PADDING, 0, COLLECTION_PADDING);//（上、左、下、右）
}


#pragma mark  定义每个UICollectionView的横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

#pragma mark  定义每个UICollectionView的纵向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return COLLECTION_PADDING;
}
#pragma mark - UICollectionViewDelegate
#pragma mark  点击CollectionView触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *service = self.gseWalletServices[indexPath.row];
    [self visitWebsit: service[@"url"]];
}

#pragma mark  设置CollectionViewCell是否可以被点击
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
