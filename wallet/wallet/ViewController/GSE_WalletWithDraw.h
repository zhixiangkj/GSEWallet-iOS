//
//  GSE_WalletWithDraw.h
//  GSEWallet
//
//  Created by user on 06/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletBase.h"

@interface GSE_WalletWithDraw : GSE_WalletBase

@end

@interface GSE_WalletWithDrawSuccess : GSE_WalletBase
@property (nonatomic, copy) NSString *tip;
@end
