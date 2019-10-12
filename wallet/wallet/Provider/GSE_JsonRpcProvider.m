//
//  GSE_JsonRpcProvider.m
//  GSEWallet
//
//  Created by user on 06/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_JsonRpcProvider.h"

static NSString *providerHost = nil;

@interface GSE_JsonRpcProvider()
- (id)sendMethod: (NSString*)method params: (NSObject*)params fetchType: (ApiProviderFetchType)fetchType;
@end

@implementation GSE_JsonRpcProvider

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData * urlHostData = [GSENETWORK_HOST dataUsingEncoding:NSUTF8StringEncoding];
        NSData * urlData = [NSData dataWithBytes:urlHostData.bytes length:urlHostData.length];
        providerHost = urlData.UTF8String;
    });
}

- (instancetype)initWithChainId:(ChainId)chainId{
    
    self = [super initWithChainId:chainId];
    if (self) {
        
    }    
    return self;
}

- (id)sendMethod: (NSString*)method params: (NSObject*)params fetchType: (ApiProviderFetchType)fetchType {
    
    NSDictionary *request = @{
                              @"jsonrpc": @"2.0",
                              @"method": method,
                              @"id": @(42),
                              @"params": params,
                              };
    
    NSError *error = nil;
    NSData *body = [NSJSONSerialization dataWithJSONObject:request options:0 error:&error];
    
    if (error) {
        NSDictionary *userInfo = @{@"reason": @"invalid JSON values", @"error": error};
        return [Promise rejected:[NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorInvalidParameters userInfo:userInfo]];
    }
    
    NSObject* (^processResponse)(NSDictionary*) = ^NSObject*(NSDictionary *response) {
        NSDictionary *rpcError = [response objectForKey:@"error"];
        if (rpcError) {
            NSDictionary *userInfo = @{@"reason": [NSString stringWithFormat:@"%@", [rpcError objectForKey:@"message"]]};
            return [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:userInfo];
        }
        
        NSObject *result = [response objectForKey:@"result"];
        if (!result) {
            NSDictionary *userInfo = @{@"reason": @"invalid result"};
            return [NSError errorWithDomain:ProviderErrorDomain code:ProviderErrorBadResponse userInfo:userInfo];
        }
        
        return result; //coerceValue(result, fetchType);
    };
    
    NSString *sign = [[[body.mutableCopy sign] hex] md5];
    unsigned char bByte [] = {0x2f,0x61,0x70,0x69,0x2f,0x76,0x31,0x2f,0x77,0x61,0x6c,0x6c,0x65,0x74,0x2f,0x72,0x70,0x63,0x3f,0x73,0x69,0x67,0x6e};
    NSData * urlData = [NSData dataWithBytes:bByte length:sizeof(bByte)];
    
    NSString *url = [NSString stringWithFormat:@"%@%@=%@",providerHost,urlData.UTF8String,sign];
    NSURL *signedURL = [NSURL URLWithString: url];
    NSLog(@"url: %@",signedURL.absoluteString);
    if (!signedURL) {
        return nil;
    }
    
    return [self promiseFetchJSON:signedURL
                             body:body
                        fetchType:fetchType
                          process:processResponse];
}

- (DictionaryPromise *)getUpdate:(NSDictionary *)params{
    return [self sendMethod:@"gse_getUpdate" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (DictionaryPromise *)getPrices:(NSDictionary *)params{
    return [self sendMethod:@"gse_getPrices" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (DictionaryPromise *)getNonce:(NSDictionary *)params{
    return [self sendMethod:@"gse_getNonce" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (DictionaryPromise *)getTokens:(NSDictionary *)params{
    return [self sendMethod:@"gse_getTokens" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (ArrayPromise *)getTxns:(NSDictionary *)params{
    return [self sendMethod:@"gse_getTxns" params:params fetchType:ApiProviderFetchTypeArray];
}
- (DictionaryPromise *)syncAPNs:(NSDictionary *)params{
    return [self sendMethod:@"gse_syncAPNs" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (DictionaryPromise *)syncPending:(NSDictionary *)params{
    return [self sendMethod:@"gse_syncPending" params:params fetchType:ApiProviderFetchTypeDictionary];
}

- (ArrayPromise *)getFAQ:(NSDictionary *)params{
    return [self sendMethod:@"gse_getFAQ" params:params fetchType:ApiProviderFetchTypeArray];
}

- (DictionaryPromise*)getTransactionByHash:(Hash *)transactionHash {
    
    return [self sendMethod:@"eth_getTransactionByHash"
                     params:@[transactionHash.hexString]
                  fetchType:ApiProviderFetchTypeDictionary];
}

- (DictionaryPromise*)getTransactionReceipt:(Hash *)transactionHash {
    
    return [self sendMethod:@"eth_getTransactionReceipt"
                     params:@[transactionHash.hexString]
                  fetchType:ApiProviderFetchTypeDictionary];
}

- (DictionaryPromise *)getRebateCode:(NSDictionary *)params{
    return [self sendMethod:@"gse_getRebateCode" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (DictionaryPromise *)checkRebateCode:(NSDictionary *)params{
    return [self sendMethod:@"gse_checkRebateCode" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (DictionaryPromise *)redeemRebateCode:(NSDictionary *)params{
    return [self sendMethod:@"gse_redeemRebateCode" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (DictionaryPromise *)withdrawRebate:(NSDictionary *)params{
    return [self sendMethod:@"gse_withdrawRebate" params:params fetchType:ApiProviderFetchTypeDictionary];
}
- (DictionaryPromise *)getRebateHistory:(NSDictionary *)params{
    return [self sendMethod:@"gse_getRebateHistory" params:params fetchType:ApiProviderFetchTypeDictionary];
}

@end
