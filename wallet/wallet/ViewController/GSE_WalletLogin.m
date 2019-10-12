//
//  GSE_WalletLogin.m
//  wallet
//
//  Created by user on 28/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletLogin.h"

@interface GSE_WalletLogin ()
@property (nonatomic, strong) UITextField *phone;
@property (nonatomic, strong) UITextField *verifycode;
@property (nonatomic, strong) UIButton *verify_btn;
@property (nonatomic, strong) UIButton *continue_btn;
@end

@implementation GSE_WalletLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat padding = 40;
    
    {
        UIImage *image = [UIImage imageNamed:@"gse_logo"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.center = CGPointMake(width / 2.0, 133 + padding);
        [self.view addSubview:imageView];
    }
    
    self.phone = ({
        CGRect rect = CGRectMake(MARGIN, 215 + padding, width - MARGIN * 2, 40);
        UITextField *textField = [[UITextField alloc] initWithFrame:rect];
        [textField setText:@"" color:nil wordSpacing:1];
        [textField setPlaceholder:@"Please enter phone number" color:UIColorFromRGB(0x999999) wordSpacing:1];
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = UIColorFromRGB(0x333333);
        textField;
    });
    [self.view addSubview:self.phone];
    
    {
        CGRect rect = self.phone.frame;
        rect.origin.y = self.phone.frame.origin.y + self.phone.frame.size.height;
        rect.size.height = 1;
        UIView *separator = [[UIView alloc] initWithFrame:rect];
        separator.backgroundColor = UIColorFromRGB(0xeaeaea);
        [self.view addSubview:separator];
    }
    
    self.verifycode = ({
        CGRect rect = CGRectMake(MARGIN, 215 + 70 + padding, width - MARGIN * 2, 40);
        UITextField *textField = [[UITextField alloc] initWithFrame:rect];
        [textField setText:@"" color:nil wordSpacing:1];
        [textField setPlaceholder:@"Enter verification code" color:UIColorFromRGB(0x999999) wordSpacing:1];
        textField.font = [UIFont systemFontOfSize:15];
        textField.textColor = UIColorFromRGB(0x333333);
        textField;
    });
    [self.view addSubview:self.verifycode];
    
    self.verify_btn = ({
        CGFloat originY = self.phone.frame.origin.y + self.phone.frame.size.height;
        CGRect rect = CGRectMake( width - MARGIN - 100, originY + 30, 100, 30);
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button setTitle:@"Get Opt" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xeaeaea) forState:UIControlStateDisabled];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
        button.layer.cornerRadius = button.frame.size.height / 2.0;
        button.layer.masksToBounds = YES;
        button;
    });
    [self.view addSubview:self.verify_btn];
    
    {
        CGRect rect = self.verifycode.frame;
        rect.origin.y = self.verifycode.frame.origin.y + self.verifycode.frame.size.height;
        rect.size.height = 1;
        UIView *separator = [[UIView alloc] initWithFrame:rect];
        separator.backgroundColor = UIColorFromRGB(0xeaeaea);
        [self.view addSubview:separator];
    }
    
    self.continue_btn = ({
        CGFloat origin = [UIScreen iPhoneX] ? height+ padding - 144  - 36 - 50 : height + padding - 104 - 36 - 50;
        CGRect rect = CGRectMake(MARGIN_2, origin, width - 90, 50);
        //NSLog(@"%@",NSStringFromCGRect(rect));
        UIButton *button = [[UIButton alloc] initWithFrame:rect];
        [button.layer setCornerRadius:25];
        [button.layer setMasksToBounds:NO];
        [button setClipsToBounds:YES];
        [button setBackgroundColor:GSE_Blue forState:UIControlStateNormal];
        [button setBackgroundColor:UIColorFromRGB(0xdbdbdb) forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle: @"Sign Up" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [button setEnabled:NO];
        button;
    });
    [self.view addSubview:self.continue_btn];
    
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Account already registered\nproceed to log in";
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textColor = UIColorFromRGB(0xbdbdbd);
        [label setText:label.text lineSpacing:8 wordSpacing:1];
        [label sizeToFit];
        CGFloat originY = self.continue_btn.frame.origin.y + self.continue_btn.frame.size.height + 10;
        label.center = CGPointMake(width / 2.0, originY + label.frame.size.height / 2.0);
        [self.view addSubview:label];
    }
    
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.view addGestureRecognizer:tap];
    }
}
#pragma mark - action

- (void)nextAction:(id)sender{
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    [self.phone resignFirstResponder];
    [self.verifycode resignFirstResponder];
}

#pragma mark - system

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
