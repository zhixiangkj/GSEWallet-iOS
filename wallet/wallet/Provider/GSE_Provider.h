//
//  GSE_Provider.h
//  wallet
//
//  Created by user on 29/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <ethers/ethers.h>

@interface Provider (GSE)

- (DictionaryPromise *)getUpdate:(NSDictionary *)params;
- (DictionaryPromise *)getPrices:(NSDictionary *)params;
- (DictionaryPromise *)getNonce:(NSDictionary *)params;
- (DictionaryPromise *)getTokens:(NSDictionary *)params;
- (ArrayPromise *)getTxns:(NSDictionary *)params;

- (DictionaryPromise *)syncAPNs:(NSDictionary *)params;
- (DictionaryPromise *)syncPending:(NSDictionary *)params;

- (ArrayPromise *)getFAQ:(NSDictionary *)params;
- (DictionaryPromise *)getTransactionByHash:(Hash *)transactionHash;
- (DictionaryPromise *)getTransactionReceipt:(Hash *)transactionHash;

- (DictionaryPromise *)getRebateCode:(NSDictionary *)params;
- (DictionaryPromise *)checkRebateCode:(NSDictionary *)params;
- (DictionaryPromise *)redeemRebateCode:(NSDictionary *)params;
- (DictionaryPromise *)withdrawRebate:(NSDictionary *)params;
- (DictionaryPromise *)getRebateHistory:(NSDictionary *)params;
@end
