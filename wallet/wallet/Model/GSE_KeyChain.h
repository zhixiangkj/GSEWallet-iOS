//
//  GSE_KeyChain.h
//  GSEWallet
//
//  Created by user on 15/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

static NSString * const kKeychainService = @"network.gse.wallet";
static NSString * const kKeychainAccessGroup = nil;

@interface GSE_KeyChain : NSObject
@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *accessGroup;

- (instancetype)initWithSevice:(NSString *)service account :(NSString *)account accessGroup:(NSString *)accessGroup;

- (void)savePassword:(NSString *)password;
- (BOOL)deleteItem;

- (NSString *)readPassword;

+ (NSArray *)passwordItemsForService:(NSString *)service accessGroup:(NSString *)accessGroup;

@end
