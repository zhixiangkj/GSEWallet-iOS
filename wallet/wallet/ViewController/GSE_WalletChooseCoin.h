//
//  GSE_WalletTransferChooseCoin.h
//  wallet
//
//  Created by user on 29/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletBase.h"

@interface GSE_WalletTransferChooseCoin : GSE_WalletBase
@property (nonatomic, assign) NSDictionary * token;
@property (nonatomic, strong) void(^finish)(NSDictionary * token);
@end

