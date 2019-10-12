//
//  GSE_WalletReferral.h
//  GSEWallet
//
//  Created by user on 05/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletReferral : UIViewController
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) void(^createdOrImported)(NSString *);
@property (nonatomic, strong) void(^finish)(void);
@end
