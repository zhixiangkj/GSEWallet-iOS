//
//  GSE_WalletBase.m
//  wallet
//
//  Created by user on 18/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletBase.h"

@interface GSE_WalletBase ()
@property (nonatomic, strong) UIButton *back_btn;
@property (nonatomic, strong) UILabel *title_label;
@end

@implementation GSE_WalletBase

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    UIImage *image = [UIImage imageNamed:@"blue_back"];
    
    CGFloat ratio =  width / image.size.width;
    
    CGFloat height = ratio * 84;
    
    self.navigationBarView = ({
        CGRect frame = CGRectMake(0, 0, width, height);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.clipsToBounds = YES;
        //view.backgroundColor = UIColorFromRGB(0x3d44ea);
        
        {
            UIImage *image = [UIImage imageNamed:@"blue_back_2"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            CGRect rect = imageView.frame;
            rect.size.width = frame.size.width;
            CGFloat ratio =  frame.size.width / image.size.width;
            rect.size.height = ratio * image.size.height;
            imageView.frame = rect;
            [view addSubview:imageView];
        }
        CGFloat originY = [UIScreen iPhoneX] ? ratio * 40 : ratio * 32;
        {
            UIImage *image = [UIImage imageNamed:@"back_white"];
            CGRect rect = CGRectMake(0,  originY , 44, 44);
            UIButton *button = [[UIButton alloc] initWithFrame:rect];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            if (self.hideBack) {
                button.hidden = YES;
            }
            self.back_btn = button;
        }
        {
            UILabel *label = [[UILabel alloc] init];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:18];
            label.lineBreakMode = NSLineBreakByTruncatingMiddle;
            [label setText:self.title lineSpacing:0 wordSpacing:1];
            [label sizeToFit];
            {
                CGRect frame = label.frame;
                if (frame.size.width > 200) {
                    frame.size.width = 200;
                }
                label.frame = frame;
            }
            label.center = CGPointMake(width / 2.0,  originY + 22 );
            [view addSubview:label];
            self.title_label = label;
        }
        view;
    });
    [self.view addSubview:self.navigationBarView];
    
    CGFloat contentHeight = self.view.bounds.size.height - height;
    
    self.contentView = ({
        CGRect rect = CGRectMake(0, height, width, contentHeight);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.backgroundColor = [UIColor whiteColor];
        view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        view;
    });
    [self.view addSubview:self.contentView];
}

- (void)setHideBack:(BOOL)hideBack{
    _hideBack = hideBack;
    [self.back_btn setHidden:hideBack];
}

- (void)setTitle:(NSString *)title{
    [super setTitle:title];
    
    UILabel * label = self.title_label;
    CGPoint center = label.center;
    
    [label setText:self.title lineSpacing:0 wordSpacing:1];
    [label sizeToFit];
    {
        CGRect frame = label.frame;
        if (frame.size.width > 200) {
            frame.size.width = 200;
        }
        label.frame = frame;
    }
    label.center = center;
}

#pragma mark - action
- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - system
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
