//
//  GSE_Guide.m
//  wallet
//
//  Created by user on 25/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Guide.h"

@interface GSE_Guide () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation GSE_Guide

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect frame = self.bounds;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
        CGSize contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        [scrollView setContentSize:contentSize];
        [scrollView setPagingEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setBounces:NO];
        [scrollView setBackgroundColor: [UIColor whiteColor]];
        [scrollView setDelegate:self];
        [self addSubview:scrollView];
        
        self.scrollView = scrollView;
        
        {
            UIPageControl *pageControl = [[UIPageControl alloc] init];
            pageControl.numberOfPages = 3;
            pageControl.pageIndicatorTintColor = UIColorFromRGB(0xb5c8f9);
            pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x1f58ed);
            pageControl.center = CGPointMake(frame.size.width / 2.0, frame.size.height - 75);
            pageControl.currentPage = 0;
            [scrollView.superview addSubview:pageControl];
            
            self.pageControl = pageControl;
        }
        
        CGFloat originY = 0;
        
        {
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:view];
            
            UIImage *image = [UIImage imageNamed:@"guide_1"];
            CGFloat ratio = self.bounds.size.width / image.size.width;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            CGRect frame = imageView.frame;
            if ([UIScreen mainScreen].bounds.size.height <= 480) {
                frame.origin.y = -80;
            }
            frame.size.width = ratio * image.size.width;
            frame.size.height = ratio * image.size.height;
            imageView.frame = frame;
            [view addSubview:imageView];
            
            originY = imageView.frame.origin.y + imageView.frame.size.height;
            
            {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = UIColorFromRGB(0x333333);
                label.font = [UIFont systemFontOfSize:24];
                [label setText:NSLocalizedString(@"Crypto Currency Wallet", nil) lineSpacing:0 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake( view.bounds.size.width / 2.0, originY + 35);
                [view addSubview:label];
            }
            {
                CGRect rect = CGRectMake(0, 0, view.bounds.size.width - 30, 0);
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = UIColorFromRGB(0x666666);
                label.font = [UIFont systemFontOfSize:12];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentCenter;
                [label setText:NSLocalizedString(@"Manage ERC20 tokens\nInclude major tokens on the market",nil) lineSpacing:10 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake( view.bounds.size.width / 2.0, originY + 125);
                [view addSubview:label];
            }
        }
        
        {
            frame.origin.x = frame.size.width;
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:view];
            
            UIImage *image = [UIImage imageNamed:@"guide_2"];
            CGFloat ratio = self.bounds.size.width / image.size.width;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            CGRect frame = imageView.frame;
            if ([UIScreen mainScreen].bounds.size.height <= 480) {
                frame.origin.y = -80;
            }
            frame.size.width = ratio * image.size.width;
            frame.size.height = ratio * image.size.height;
            imageView.frame = frame;
            [view addSubview:imageView];
            
            {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = UIColorFromRGB(0x333333);
                label.font = [UIFont systemFontOfSize:24];
                [label setText:NSLocalizedString(@"Asset Safety Guaranteed",nil) lineSpacing:0 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake( view.bounds.size.width / 2.0, originY + 35);
                [view addSubview:label];
            }
            {
                CGRect rect = CGRectMake(0, 0, view.bounds.size.width - 30, 0);
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = UIColorFromRGB(0x666666);
                label.font = [UIFont systemFontOfSize:12];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentCenter;
                [label setText:NSLocalizedString(@"Wallet access only belongs to you\nAsset is 100% safe",nil) lineSpacing:10 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake( view.bounds.size.width / 2.0, originY  + 125);
                [view addSubview:label];
            }
        }
        
        {
            frame.origin.x = frame.size.width * 2;
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = [UIColor whiteColor];
            [scrollView addSubview:view];
            
            UIImage *image = [UIImage imageNamed:@"guide_3"];
            CGFloat ratio = self.bounds.size.width / image.size.width;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            CGRect frame = imageView.frame;
            if ([UIScreen mainScreen].bounds.size.height <= 480) {
                frame.origin.y = -80;
            }
            frame.size.width = ratio * image.size.width;
            frame.size.height = ratio * image.size.height;
            imageView.frame = frame;
            [view addSubview:imageView];
            
            {
                UILabel *label = [[UILabel alloc] init];
                label.textColor = UIColorFromRGB(0x333333);
                label.font = [UIFont systemFontOfSize:24];
                [label setText:NSLocalizedString(@"Easy to Use",nil) lineSpacing:0 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake( view.bounds.size.width / 2.0, originY + 35);
                [view addSubview:label];
            }
            {
                CGRect rect = CGRectMake(0, 0, view.bounds.size.width - 30, 0);
                UILabel *label = [[UILabel alloc] initWithFrame:rect];
                label.textColor = UIColorFromRGB(0x666666);
                label.font = [UIFont systemFontOfSize:12];
                label.numberOfLines = 0;
                label.textAlignment = NSTextAlignmentCenter;
                [label setText:NSLocalizedString(@"No geeky design\nEveryone can use blockchain",nil) lineSpacing:10 wordSpacing:1];
                [label sizeToFit];
                label.center = CGPointMake( view.bounds.size.width / 2.0, originY  + 125);
                
                if ([UIScreen mainScreen].bounds.size.height < 736) {
                    [label setCenter:CGPointMake(view.bounds.size.width / 2.0, originY  + 100)];
                }
                
                [view addSubview:label];
            }
            {
                CGRect rect = CGRectMake(0, 0, 140, 45);
                UIButton *button = [[UIButton alloc] initWithFrame:rect];
                [button.layer setCornerRadius:rect.size.height / 2.0];
                [button.layer setMasksToBounds:YES];
                [button setBackgroundColor:UIColorFromRGB(0x1f58ed) forState:UIControlStateNormal];
                [button addTarget:self action:@selector(createAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:NSLocalizedString(@"Create Wallet",nil) forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
                [button setCenter:CGPointMake(view.bounds.size.width / 2.0, view.bounds.size.height - 210 / 2.0)];
                if ([UIScreen mainScreen].bounds.size.height <= 568) {
                    [button setCenter:CGPointMake(view.bounds.size.width / 2.0, view.bounds.size.height - 140 / 2.0)];
                }
                [view addSubview:button];
            }
            
            {
                CGRect rect = CGRectMake(0, 0, 140, 45);
                UIButton *button = [[UIButton alloc] initWithFrame:rect];
                [button addTarget:self action:@selector(importAction:) forControlEvents:UIControlEventTouchUpInside];
                [button setTitle:NSLocalizedString(@"Import Wallet",nil) forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromRGB(0x1f58ed) forState:UIControlStateNormal];
                [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
                [button setCenter:CGPointMake(view.bounds.size.width / 2.0, view.bounds.size.height - 116 / 2.0)];
                
                if ([UIScreen mainScreen].bounds.size.height <= 568) {
                    [button setCenter:CGPointMake(view.bounds.size.width / 2.0, view.bounds.size.height - 60 / 2.0)];
                }
                
                [view addSubview:button];
            }
        }
        
    }
    return self;
}

#pragma mark - action

- (void)createAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(createAction:)]) {
        [self.delegate createAction:sender];
    }
}

- (void)importAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(importAction:)]) {
        [self.delegate importAction:sender];
    }
}

#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x / self.bounds.size.width;
    self.pageControl.hidden = scrollView.contentOffset.x >= 1.7 * self.bounds.size.width;
}

@end
