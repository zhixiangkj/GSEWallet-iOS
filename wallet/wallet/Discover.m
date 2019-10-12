//
//  Discover.m
//  wallet
//
//  Created by user on 18/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "Discover.h"
#import "GSE_Discover.h"

@interface Discover ()
@property (nonatomic, strong) GSE_Discover *discover;
@end

@implementation Discover

- (void)awakeFromNib{
    [super awakeFromNib];
    UIImage *image = [UIImage imageNamed:@"tab_discover"];
    self.navigationController.tabBarItem.image = image;
    self.title = @"Discover";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    self.discover = [[GSE_Discover alloc] initWithFrame:self.view.bounds];
    self.discover.hostVC = self;
    [self.view addSubview:self.discover];
    
}

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
