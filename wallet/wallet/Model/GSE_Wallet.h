//
//  GSE_Wallet.h
//  wallet
//
//  Created by user on 22/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ethers/Address.h>
#import <ethers/BigNumber.h>
#import <ethers/Payment.h>
#import <ethers/Provider.h>
#import <ethers/Transaction.h>
#import <ethers/TransactionInfo.h>

#import "GSE_Provider.h"

#define GSENETWORK_HOST @"https://app.gsenetwork.io"

@interface GSE_Wallet : NSObject
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) ChainId chainId;
@property (nonatomic, strong) NSDictionary *prices;
@property (nonatomic, strong) NSString *blockNumber;
@property (nonatomic, strong) NSArray *faq;

+ (GSE_Wallet *)shared;
- (NSString *)getClientid;

- (Provider*)getProvider;
- (Provider*)getProvider: (ChainId)chainId;

- (Address *)getAddressForWallet:(NSString *)wallet;
- (NSString *)getWalletNameForAddress:(Address *)address;

- (NSArray *)getWallets;
- (NSString *)getTotalAssets;
- (NSString *)getAssetsForAddress:(Address *)address;
- (NSString *)getAssetsPercentageForAddress:(Address *)address;
- (NSDictionary *)getAddresses;

- (void)setCurrentWallet:(NSString *)wallet;
- (NSString *)getCurrentWallet;
- (Address *)getCurrentWalletAddress;
- (BigNumber *)getEtherBalance;


- (NSDictionary *)getKeystore:(NSString *)wallet;
- (NSString *)getKeystoreString:(NSString *)wallet;
- (BOOL)storeKeystore:(id)keystore forWallet:(NSString *)wallet;

- (id)getTokensForAddress:(Address *)address;
- (void)storeTokens:(id)tokens forAddress:(Address *)address;
- (NSString *)getTokensEtagForAddress:(Address *)address;

- (id)getTxnsForAddress:(Address *)address atContract:(Address *)contract;
- (void)storeTxns:(id)txns forAddress:(Address *)address atContract:(Address *)contract;

- (BOOL)renameWallet:(NSString *)current withName:(NSString *)name;
- (BOOL)removeWallet:(NSString *)current withPassword:(NSString *)password;

- (void)reloadTokens:(void (^)(NSDictionary *object))finish;

- (NSDictionary *)getRebateForClient:(NSString *)clientid;
- (void)storeRebate:(NSDictionary *)info forClient:(NSString *)clientid;

- (NSArray *)getRebateHistoryForClient:(NSString *)clientid;
- (void)storeRebateHistory:(NSArray *)info forClient:(NSString *)clientid;
@end
