//
//  GSE_Rebate.h
//  GSEWallet
//
//  Created by user on 03/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Base.h"

@interface GSE_Rebate : Base
@property (nonatomic, copy) NSString *quantity;
@end

@interface GSE_RebateCode : GSE_Rebate
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *invited;
@property (nonatomic, copy) NSString *acquire;
@property (nonatomic, copy) NSString *require;
@property (nonatomic, copy) NSString *rebates;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *withdraw;
@property (nonatomic, copy) NSString *url;
@end;

@interface GSE_RebateInfo : Base
@property (nonatomic, copy) NSString *rebateid;
//@property (nonatomic, copy) NSString *reduce;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *contractAddress;
@property (nonatomic, copy) NSString *txhash;
@property (nonatomic, strong) NSDictionary *transaction;
@property (nonatomic, strong) NSDictionary *contract;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *clientid;
@property (nonatomic, copy) NSString *eth_usd;
@property (nonatomic, copy) NSString *eth_gse;
@property (nonatomic, copy) NSString *valueInETH;
@property (nonatomic, copy) NSString *valueInUSD;
@property (nonatomic, copy) NSString *valueInGSE;
@property (nonatomic, copy) NSString *source;
@end
