//
//  GSE_WalletReName.h
//  GSEWallet
//
//  Created by user on 30/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletBase.h"

@interface GSE_WalletReName : GSE_WalletBase
@property (nonatomic, strong) NSString *wallet;
@property (nonatomic, strong) void(^finish)(void);
@end
