//
//  GSE_WalletTxnDetail.h
//  wallet
//
//  Created by user on 30/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletTxnDetail : GSE_WalletBase
@property (nonatomic, strong) id transaction;
@property (nonatomic, assign) BOOL isContract;
@property (nonatomic, assign) BOOL isTxnOut;
@property (nonatomic, strong) NSDictionary *token;
@property (nonatomic, assign) BOOL isFromRebateHistory;
@end
