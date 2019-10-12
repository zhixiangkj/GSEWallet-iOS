//
//  GSE_Provider.m
//  wallet
//
//  Created by user on 29/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Provider.h"

@interface Provider ()
- (id)sendNotImplemented: (NSString*)method promiseClass: (Class)promiseClass;
@end

@implementation Provider (GSE)

- (DictionaryPromise *)getUpdate:(NSDictionary *)params{
    return [self sendNotImplemented:@"getUpdate:" promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getPrices:(NSDictionary *)params{
    return [self sendNotImplemented:@"getPrices:" promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getNonce:(NSDictionary *)params{
    return [self sendNotImplemented:@"getPrices:" promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getTokens:(NSDictionary *)params{
    return [self sendNotImplemented:@"getTokens:" promiseClass:[DictionaryPromise class]];
}
- (ArrayPromise *)getTxns:(NSDictionary *)params{
    return [self sendNotImplemented:@"getTxns:" promiseClass:[ArrayPromise class]];
}
- (DictionaryPromise *)syncAPNs:(NSDictionary *)params{
    return [self sendNotImplemented:@"syncAPNs:" promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)syncPending:(NSDictionary *)params{
    return [self sendNotImplemented:@"syncPending:" promiseClass:[DictionaryPromise class]];
}
- (ArrayPromise *)getFAQ:(NSDictionary *)params{
    return [self sendNotImplemented:@"getFAQ:" promiseClass:[ArrayPromise class]];
}
- (DictionaryPromise *)getTransactionByHash:(Hash *)transactionHash{
    return [self sendNotImplemented:@"getTransactionByHash:" promiseClass:[ArrayPromise class]];
}
- (DictionaryPromise*)getTransactionReceipt:(Hash *)transactionHash{
    return [self sendNotImplemented:@"getTransactionReceipt:" promiseClass:[ArrayPromise class]];
}
- (DictionaryPromise *)getRebateCode:(NSDictionary *)params{
    return [self sendNotImplemented:@"getRebateCode:" promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)checkRebateCode:(NSDictionary *)params{
    return [self sendNotImplemented:@"checkRebateCode:" promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)redeemRebateCode:(NSDictionary *)params{
    return [self sendNotImplemented:@"redeemRebateCode:" promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)withdrawRebate:(NSDictionary *)params{
    return [self sendNotImplemented:@"withdrawRebate:" promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getRebateHistory:(NSDictionary *)params{
    return [self sendNotImplemented:@"getRebateHistory:" promiseClass:[DictionaryPromise class]];
}
@end

@interface FallbackProvider (GSE)

@end

@interface FallbackProvider ()
- (id)executeOperation: (Promise* (^)(Provider*))startCallback promiseClass: (Class)promiseClass;
@end

@implementation FallbackProvider (GSE)

- (DictionaryPromise *)getUpdate:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getUpdate:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getPrices:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getPrices:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getNonce:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getNonce:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getTokens:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getTokens:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (ArrayPromise *)getTxns:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getTxns:params];
    };
    return [self executeOperation:startCallback promiseClass:[ArrayPromise class]];
}
- (DictionaryPromise *)syncAPNs:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider syncAPNs:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)syncPending:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider syncPending:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (ArrayPromise *)getFAQ:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getFAQ:params];
    };
    return [self executeOperation:startCallback promiseClass:[ArrayPromise class]];
}
- (DictionaryPromise *)getTransactionByHash:(Hash *)transactionHash{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getTransactionByHash:transactionHash];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise*)getTransactionReceipt:(Hash *)transactionHash{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getTransactionReceipt:transactionHash];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getRebateCode:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getRebateCode:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)checkRebateCode:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider checkRebateCode:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)redeemRebateCode:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider redeemRebateCode:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)withdrawRebate:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider withdrawRebate:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
- (DictionaryPromise *)getRebateHistory:(NSDictionary *)params{
    Promise* (^startCallback)(Provider*) = ^Promise*(Provider *provider) {
        return [provider getRebateHistory:params];
    };
    return [self executeOperation:startCallback promiseClass:[DictionaryPromise class]];
}
@end
