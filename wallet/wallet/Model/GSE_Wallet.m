//
//  GSE_Wallet.m
//  wallet
//
//  Created by user on 22/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Wallet.h"

#import <ethers/Account.h>
#import <ethers/EtherscanProvider.h>
#import <ethers/FallbackProvider.h>
#import <ethers/InfuraProvider.h>
#import <ethers/Payment.h>
#import <ethers/SecureData.h>

#import "GSE_JsonRpcProvider.h"
#import "GSE_KeyChain.h"

//#define ETHERSCAN_API_KEY                   @"YTCX255XJGH9SCBUDP2K48S4YWACUEFSJX"
#define ETHERSCAN_API_KEY @"PVD2X7TPHHN85RB81EPF5N73N2PP4CJWHJ"

@interface GSE_Wallet ()
@property NSMutableDictionary<NSNumber*, Provider*> *providers;
@end

@implementation GSE_Wallet

+ (GSE_Wallet *)shared{
    static GSE_Wallet * wallet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wallet = [[GSE_Wallet alloc] init];
    });
    return wallet;
}

- (Provider*)getProvider{
    return [self getProvider:self.chainId];
}

- (Provider*)getProvider: (ChainId)chainId {
    NSNumber *key = [NSNumber numberWithInteger:chainId];
    
    Provider *provider = [_providers objectForKey:key];
    
    if (!provider) {
        
        // Prepare a new provider
        FallbackProvider *fallbackProvider = [[FallbackProvider alloc] initWithChainId:chainId];
        
        [fallbackProvider addProvider:[[GSE_JsonRpcProvider alloc] initWithChainId:chainId]];
        
        //[fallbackProvider addProvider:[[GSE_ApiProvider alloc] initWithChainId:chainId]];
        
        //[fallbackProvider addProvider:[[EtherscanProvider alloc] initWithChainId:chainId apiKey:ETHERSCAN_API_KEY]];
        // Add INFURA and Etherscan unless explicitly disabled
        //[fallbackProvider addProvider:[[InfuraProvider alloc] initWithChainId:chainId]];
        
        //[fallbackProvider addProvider:[[JsonRpcProvider alloc] initWithChainId:chainId url:[NSURL URLWithString:@"http://192.168.4.244:8545/"]]];
        
        //[provider startPolling];
        
        /*
        if (chainId == ChainIdHomestead) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(notifyEtherPriceChanged:)
                                                         name:ProviderEtherPriceChangedNotification
                                                       object:provider];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notifyBlockNumber:)
                                                     name:ProviderDidReceiveNewBlockNotification
                                                   object:provider];
         */
        
        [_providers setObject:fallbackProvider forKey:key];
        provider = fallbackProvider;
    }
    
    return provider;
}

+ (NSString*)formatToken: (BigNumber*)wei withDecimal:(NSUInteger)decimal {
    return [self formatToken:wei options:0 decimal:decimal];
}

+ (NSString*)formatToken: (BigNumber*)wei options: (NSUInteger)options decimal:(NSUInteger)decimal {
    
    if (!wei) { return nil; }
    
    NSString *weiString = [wei decimalString];
    
    BOOL negative = NO;
    if ([weiString hasPrefix:@"-"]) {
        negative = YES;
        weiString = [weiString substringFromIndex:1];
    }
    
    while (weiString.length < decimal + 1) {
        weiString = [@"0" stringByAppendingString:weiString];
    }
    
    NSUInteger decimalIndex = weiString.length - decimal;
    NSString *wholeString = [weiString substringToIndex:decimalIndex];
    NSString *decimalString = [weiString substringFromIndex:decimalIndex];
    
    if (options & EtherFormatOptionCommify) {
        NSString *commified = @"";
        //NSMutableArray *parts = [NSMutableArray arrayWithCapacity:(whole.length + 2) / 3];
        while (wholeString.length) {
            //NSLog(@"FOO: %@", whole);
            NSInteger chunkStart = wholeString.length - 3;
            if (chunkStart < 0) { chunkStart = 0; }
            commified = [NSString stringWithFormat:@"%@,%@", [wholeString substringFromIndex:chunkStart], commified];
            wholeString = [wholeString substringToIndex:chunkStart];
        }
        
        wholeString = [commified substringToIndex:commified.length - 1];
    }
    
    if (options & EtherFormatOptionApproximate) {
        decimalString = [decimalString substringToIndex:5];
    }
    
    // Trim trailing 0's
    while (decimalString.length > 1 && [decimalString hasSuffix:@"0"]) {
        decimalString = [decimalString substringToIndex:decimalString.length - 1];
    }
    
    if (negative) {
        wholeString = [@"-" stringByAppendingString:wholeString];
    }
    
    return [NSString stringWithFormat:@"%@.%@", wholeString, decimalString];
}

- (Address *)getAddressForWallet:(NSString *)wallet{
    NSString *table = [NSString stringWithFormat:@"wallet/%@",self.userId];
    NSDictionary * keystore = [[SSDB shared] hGetJson:table forKey:wallet];
    NSString *address = keystore[@"address"];
    if (address && [address isKindOfClass:[NSString class]]) {
        return [Address addressWithString:address]; //@"0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
    }
    return nil;
}

- (NSString *)getWalletNameForAddress:(Address *)address{
    NSString *table = [NSString stringWithFormat:@"addresses/%@",self.userId];
    return [[SSDB shared] hGetString:table forKey:address.checksumAddress.lowercaseString];
}

- (NSDictionary *)getAddresses{
    NSString *table = [NSString stringWithFormat:@"addresses/%@",self.userId];
    NSMutableDictionary * wallets = [NSMutableDictionary dictionary];
    NSDictionary * dic = [[SSDB shared] hGetAllString:table];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        Address *address = [Address addressWithString:key];
        if (address) {
            [wallets setObject:address forKey:obj];
        }
    }];
    return wallets;
}

- (NSArray *)getWallets{
    NSString *table = [NSString stringWithFormat:@"wallet/%@",self.userId];
    return [[SSDB shared] hGetAllStringSortedKey:table];
}

- (NSString *)getTotalAssets{
    
    NSDictionary *addresses = [self getAddresses];
    
    __block double total = 0;
    [addresses enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull wallet, Address *  _Nonnull address, BOOL * _Nonnull stop) {
        NSLog(@"%s,%@,%@",__FUNCTION__,wallet,address);
        
        NSDictionary *obj = [[SSDB shared] hGetJson:@"tokens/address" forKey:address.checksumAddress.lowercaseString];
        if ([obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@",obj);
            NSString *totalString = obj[@"totalusd"];
            if(totalString && [totalString isKindOfClass:[NSString class]] && totalString.length){
                totalString = [totalString stringByReplacingOccurrencesOfString:@"$" withString:@""];
                totalString = [totalString stringByReplacingOccurrencesOfString:@"," withString:@""];
                totalString = [totalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            NSLog(@"totalString: %@",totalString);
            total  += [totalString doubleValue];
            NSLog(@"total: %@",@(total));
        }else{
            NSLog(@"%@,%@",wallet,obj.class);
        }
    }];
    NSString *totalUsd = [NSString stringWithFormat:@"%.2f",total];
    
    return [totalUsd separateNumberUseComma];
}

- (NSString *)getAssetsForAddress:(Address *)address{
    
    double total = 0;
    
    NSString *wallet = [self getWalletNameForAddress:address];
    
    if (!wallet.length) {
        return @"$ 0.00";
    }
    
    NSDictionary *obj = [[SSDB shared] hGetJson:@"tokens/address" forKey:address.checksumAddress.lowercaseString];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@",obj);
        NSString *totalString = obj[@"totalusd"];
        if(totalString && [totalString isKindOfClass:[NSString class]] && totalString.length){
            totalString = [totalString stringByReplacingOccurrencesOfString:@"$" withString:@""];
            totalString = [totalString stringByReplacingOccurrencesOfString:@"," withString:@""];
            totalString = [totalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        NSLog(@"totalString: %@",totalString);
        total  += [totalString doubleValue];
        NSLog(@"total: %@",@(total));
    }else{
        NSLog(@"%@,%@",wallet,obj.class);
        return @"$ 0.00";
    }
    
    NSString *totalUsd = [NSString stringWithFormat:@"%.2f",total];
    
    return [totalUsd separateNumberUseComma];
}

- (NSString *)getAssetsPercentageForAddress:(Address *)address{
    
    NSString *wallet = [self getWalletNameForAddress:address];
    
    if (!wallet.length) {
        return @"0%";
    }
    
    NSDictionary *obj = [[SSDB shared] hGetJson:@"tokens/address" forKey:address.checksumAddress.lowercaseString];
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"%@",obj);
        NSString *totalString = obj[@"usdpercentagechange"];
        if(totalString && [totalString isKindOfClass:[NSString class]] && totalString.length){
            totalString = [totalString stringByReplacingOccurrencesOfString:@"$" withString:@""];
            totalString = [totalString stringByReplacingOccurrencesOfString:@"," withString:@""];
            totalString = [totalString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        NSLog(@"totalString: %@",totalString);
        return totalString.length? totalString : @"0%";
    }else{
        NSLog(@"%@,%@",wallet,obj.class);
        return @"0%";
    }
}

- (NSString *)getCurrentWallet{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/current",self.userId];
    NSString *wallet = [[SSDB shared] stringValueForKey:key];
    if (!wallet.length) {
        NSArray *wallets = [self getWallets];
        if (wallets.count && wallets.firstObject) {
            [[SSDB shared] setStringValue:wallet forKey:key];
            wallet = wallets.firstObject;
        }
    }
    return wallet;
}

- (Address *)getCurrentWalletAddress{
    NSString *wallet = [self getCurrentWallet];
    if (!wallet.length) {
        return nil;
    }
    return  [self getAddressForWallet:wallet];
}

- (BigNumber *)getEtherBalance{
    Address *address = [self getCurrentWalletAddress];
    if (!address) {
        return [BigNumber bigNumberWithNumber:@(0)];
    }
    NSDictionary *list = [self getTokensForAddress:address];
    if (!list || !list.count || ![list isKindOfClass:[NSDictionary class]]) {
        return [BigNumber bigNumberWithNumber:@(0)];
    }
    
    NSArray *tokens = list[@"tokens"];
    if (!tokens || !tokens.count || ![tokens isKindOfClass:[NSArray class]]) {
        return [BigNumber bigNumberWithNumber:@(0)];
    }
    
    NSDictionary *eth = tokens.firstObject;
    if (![eth isKindOfClass:[NSDictionary class]] || !eth.count) {
        return [BigNumber bigNumberWithNumber:@(0)];
    }
    
    NSString *value = eth[@"value"];
    NSLog(@"value: %@",eth);
    if (!value || ![value isKindOfClass:[NSString class]]) {
        return [BigNumber bigNumberWithNumber:@(0)];
    }
    
    return [BigNumber bigNumberWithDecimalString:value];
}

- (BOOL)renameWallet:(NSString *)current withName:(NSString *)name{
    NSDictionary *wallet = [self getKeystore:name];
    if(wallet.count){
        return NO;
    }

    if (!current.length) {
        return NO;
    }
    NSDictionary *old = [self getKeystore:current];
    if(!old.count){
        return NO;
    }
    NSString *table = [NSString stringWithFormat:@"wallet/%@",self.userId];
    [self storeKeystore:old forWallet:name];
    [self setCurrentWallet:name];
    [[SSDB shared] hDel:table Key:current];
    
    return YES;
}

- (BOOL)removeWallet:(NSString *)current withPassword:(NSString *)password{
    NSMutableDictionary *wallet = [self getKeystore:current].mutableCopy;
    if(!wallet.count){
        return NO;
    }
    
    NSString *table = [NSString stringWithFormat:@"wallet/%@",self.userId];
    Address * address = [self getAddressForWallet:current];
    if (!address) {
        return NO;
    }
    NSString *deleted = [NSString stringWithFormat:@"%@/deleted",table];
    
    [wallet setObject:password forKey:@"password"];
    [wallet setObject:current forKey:@"wallet"];
    
    [[SSDB shared] hSet:deleted jsonValue:wallet forKey:address.checksumAddress.lowercaseString];
    [[SSDB shared] hDel:table Key:current];
    
    NSString *address_table = [NSString stringWithFormat:@"addresses/%@",self.userId];
    [[SSDB shared] hDel:address_table Key:address.checksumAddress.lowercaseString];
    
    NSString *key = [NSString stringWithFormat:@"wallet/%@/current",self.userId];
    [[SSDB shared] del:key];
    return YES;
}

- (void)setCurrentWallet:(NSString *)wallet{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/current",self.userId];
    [[SSDB shared] setStringValue:wallet forKey:key];
}

- (NSString *)getClientid{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/clientid",self.userId];
    NSString *clientid = [[SSDB shared] stringValueForKey:key];
    if (!clientid.length) {
        GSE_KeyChain *keychain = [[GSE_KeyChain alloc] initWithSevice:kKeychainService account:key accessGroup:kKeychainAccessGroup];
        NSString *keychainId = [keychain readPassword];
        if (!keychainId.length) {
            NSLog(@"keychain: %@, clientid: %@, created new id",keychainId,clientid);
            clientid = [[NSUUID UUID] UUIDString].lowercaseString;
            [keychain savePassword:clientid.lowercaseString];
            
        }else{
            NSLog(@"keychain: %@, clientid: %@, imported from keychain",keychainId,clientid);
            clientid = keychainId;
        }
        [[SSDB shared] setStringValue:clientid forKey:key];
    }else{
        GSE_KeyChain *keychain = [[GSE_KeyChain alloc] initWithSevice:kKeychainService account:key accessGroup:kKeychainAccessGroup];
        
        NSString *keychainId = [keychain readPassword];
        if (!keychainId.length) {
            [keychain savePassword:clientid.lowercaseString];
        }else{
            if (keychainId.length && ![keychainId isEqualToString:clientid]) {
                NSLog(@"keychain: %@, clientid: %@, not same",keychainId,clientid);
                clientid = keychainId;
                [[SSDB shared] setStringValue:keychainId forKey:key];
            }else{
                NSLog(@"keychain: %@, clientid: %@, same",keychainId,clientid);
            }
        }
    }
    return clientid.lowercaseString;
}

- (id)getTokensForAddress:(Address *)address{
    NSString *table = [NSString stringWithFormat:@"tokens/address"];
    return [[SSDB shared] hGetJson:table forKey:address.checksumAddress.lowercaseString];
}

- (void)storeTokens:(id)tokens forAddress:(Address *)address{
    NSString *table = [NSString stringWithFormat:@"tokens/address"];
    [[SSDB shared] hSet:table jsonValue:tokens forKey:address.checksumAddress.lowercaseString];
}
- (NSString *)getTokensEtagForAddress:(Address *)address{
    NSString *table = [NSString stringWithFormat:@"tokens/address"];
    NSString *value = [[SSDB shared] hGetString:table forKey:address.checksumAddress.lowercaseString];
    if (!value.length) {
        return nil;
    }
    return [value md5];
}

- (id)getTxnsForAddress:(Address *)address atContract:(Address *)contract{
    NSString *table = [NSString stringWithFormat:@"tokens/txns/%@",contract.checksumAddress.lowercaseString];
    return [[SSDB shared] hGetJson:table forKey:address.checksumAddress.lowercaseString];
}
- (void)storeTxns:(id)txns forAddress:(Address *)address atContract:(Address *)contract{
    NSString *table = [NSString stringWithFormat:@"tokens/txns/%@",contract.checksumAddress.lowercaseString];
    [[SSDB shared] hSet:table jsonValue:txns forKey:address.checksumAddress.lowercaseString];
}

- (NSString *)getKeystoreString:(NSString *)wallet{
    NSString *table = [NSString stringWithFormat:@"wallet/%@",self.userId];
    return [[SSDB shared] hGetString:table forKey:wallet];
}

- (NSDictionary *)getKeystore:(NSString *)wallet{
    NSString *table = [NSString stringWithFormat:@"wallet/%@",self.userId];
    return [[SSDB shared] hGetJson:table forKey:wallet];
}

- (BOOL)storeKeystore:(id)keystore forWallet:(NSString *)wallet{
    if (!self.userId) {
        return NO;
    }
    NSString *table = [NSString stringWithFormat:@"wallet/%@",self.userId];
    NSString *address_table = [NSString stringWithFormat:@"addresses/%@",self.userId];
    
    NSDictionary *keystoreDic = nil;
    if ([keystore isKindOfClass:[NSDictionary class]]) {
        keystoreDic = keystore;
    }else if ([keystore isKindOfClass:[NSString class]]){
        keystoreDic = [NSJSONSerialization JSONObjectWithData:[(NSString *)keystore dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }else if ([keystore isKindOfClass:[NSData class]]){
        keystoreDic = [NSJSONSerialization JSONObjectWithData:keystore options:kNilOptions error:nil];
    }else{
        return NO;
    }
    if (!keystoreDic || !keystoreDic[@"address"]) {
        return NO;
    }
    NSString *key = keystoreDic[@"address"];
    if (!key || ![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    Address *address = [Address addressWithString:key];
    if (address) {
        [[SSDB shared] hSet:address_table stringValue:wallet forKey:address.checksumAddress.lowercaseString];
        [[SSDB shared] hSet:table jsonValue:keystoreDic forKey:wallet];
    }
    return YES;
}

- (NSDictionary *)prices{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/prices",self.userId];
    return [[SSDB shared] jsonValueForKey:key];
}

- (void)setPrices:(NSDictionary *)prices{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/prices",self.userId];
    [[SSDB shared] setJsonValue:prices forKey:key];
}

- (NSString *)blockNumber{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/blockNumber",self.userId];
    return [[SSDB shared] stringValueForKey:key];
}

- (void)setBlockNumber:(NSString *)blockNumber{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/blockNumber",self.userId];
    [[SSDB shared] setStringValue:blockNumber forKey:key];
}

- (NSArray *)faq{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/faq",self.userId];
    return [[SSDB shared] jsonValueForKey:key];
}

- (void)setFaq:(NSArray *)faq{
    NSString *key = [NSString stringWithFormat:@"wallet/%@/faq",self.userId];
    [[SSDB shared] setJsonValue:faq forKey:key];
}

- (void)reloadTokens:( void (^)(NSDictionary *object) ) finish{
    
    NSString *current = [self getCurrentWallet];
    
    if (!current.length) {
        if (finish) {
            finish(nil);
        }
        return;
    }
    
    Address *address = [self getAddressForWallet:current];
    if (!address) {
        if (finish) {
            finish(nil);
        }
        return;
    }
    
    Provider * provider = [self getProvider];
    __weak typeof(self) weakSelf = self;
    
    [[provider getBlockNumber] onCompletion:^(IntegerPromise *promise) {
        NSLog(@"blockNumber: %@",@(promise.value));
        if (!promise.result) {
            return ;
        }
        weakSelf.blockNumber = @(promise.value).stringValue;
    }];
    
    NSLog(@"address: %@",address.checksumAddress.lowercaseString);
    NSString * addressString = address.checksumAddress.lowercaseString; //@"0x46705dfff24256421a05d056c29e81bdc09723b8";
    if (!addressString) {
        if (finish) {
            finish(nil);
        }
        return;
    }
    
    NSDictionary *dic = @{@"address":address.checksumAddress.lowercaseString,@"clientid": self.getClientid};
    /*[[provider getPrices:dic] onCompletion:^(DictionaryPromise *promise) {
        if (!promise.result) {
            return ;
        }
        weakSelf.prices = promise.value;
    }];*/
    
    [[provider getTokens:dic] onCompletion:^(DictionaryPromise *promise) {
        NSLog(@"%@",promise.result);
        if (!promise.result) {
            if (finish) {
                finish(nil);
            }
            NSLog(@"%s,promise.result error",__FUNCTION__);
            return ;
        }
        NSDictionary *object = promise.value;
        
        if (!object || ![object isKindOfClass:[NSDictionary class]]) {
            NSLog(@"object error: %@",object);
            if (finish) {
                finish(nil);
            }
            return;
        }
        
        NSArray *tokens = object[@"tokens"];
        if ([tokens isKindOfClass:[NSArray class]]) {
            //NSLog(@"userTokens success: %@",tokens);
            [weakSelf storeTokens:object forAddress:address];
        }
        
        NSDictionary *rebate = object[@"rebate"];
        NSLog(@"rebate: %@",rebate);
        if([rebate isKindOfClass:[NSDictionary class]] && rebate.count){

            NSString *ok = rebate[@"ok"];
            if (![ok respondsToSelector:@selector(boolValue)] || !ok.boolValue) {
                if (finish) {
                    finish(object);
                }
                return;
            }
            NSDictionary *data = rebate[@"data"];
            if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                if(![data isKindOfClass:[NSString class]]){
                    if (finish) {
                        finish(object);
                    }
                    return;
                }
                NSString *base64 = (id)data;
                NSData *base64Data = [[NSData alloc] initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
                NSData *decryptedData = [base64Data sign];
                data = [NSJSONSerialization JSONObjectWithData:decryptedData options:kNilOptions error:nil];
            }
            if (!data || ![data isKindOfClass:[NSDictionary class]]) {
                if (finish) {
                    finish(object);
                }
                return;
            }
            NSLog(@"%@",data);
            
            [weakSelf storeRebate:data forClient: weakSelf.getClientid];
        }
        
        if (finish) {
            finish(object);
        }
    }];
}

- (NSDictionary *)getRebateForClient:(NSString *)clientid{
    NSString *key = [NSString stringWithFormat:@"rebate/device/%@",self.userId];
    return [[SSDB shared] hGetJson:key forKey:clientid];
}
- (void)storeRebate:(NSDictionary *)info forClient:(NSString *)clientid{
    NSString *key = [NSString stringWithFormat:@"rebate/device/%@",self.userId];
    [[SSDB shared] hSet:key jsonValue:info forKey:clientid];
}

- (NSArray *)getRebateHistoryForClient:(NSString *)clientid{
    NSString *key = [NSString stringWithFormat:@"rebate/history/%@",self.userId];
    return [[SSDB shared] hGetJson:key forKey:clientid];
}
- (void)storeRebateHistory:(NSArray *)info forClient:(NSString *)clientid{
    NSString *key = [NSString stringWithFormat:@"rebate/history/%@",self.userId];
    [[SSDB shared] hSet:key jsonValue:info forKey:clientid];
}

@end
