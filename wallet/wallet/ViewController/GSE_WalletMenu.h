//
//  GSE_WalletMenu.h
//  GSEWallet
//
//  Created by user on 08/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletMenu : UIViewController
@property (nonatomic, assign) BOOL chooseWallet;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) void(^createdOrImported)(NSString *);
@property (nonatomic, strong) void(^finish)(void);
@end
