//
//  GSE_WalletInsider.h
//  wallet
//
//  Created by user on 26/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletInsider : GSE_WalletBase
@property (nonatomic, assign) NSInteger exportType;
@property (nonatomic, strong) Account *account;
@property (nonatomic, strong) NSString *keystore;
@property (nonatomic, strong) void(^finish)(void);
@end
