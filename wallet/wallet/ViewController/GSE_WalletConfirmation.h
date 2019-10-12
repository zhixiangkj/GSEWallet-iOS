//
//  GSE_WalletTransferConfirmation.h
//  wallet
//
//  Created by user on 29/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletBase.h"

@interface GSE_WalletTransferConfirmation : GSE_WalletBase
@property (nonatomic, strong) Transaction * transaction;
@property (nonatomic, assign) BOOL isContract;
@property (nonatomic, assign) BOOL isTxnOut;
@property (nonatomic, strong) NSDictionary *token;

@property (nonatomic, strong) Address *fromAddress;
@property (nonatomic, strong) Address *toAddress;
@property (nonatomic, strong) BigNumber *value;
@property (nonatomic, strong) NSString *wallet;

@end
