//
//  GSE_Node.h
//  GSEWallet
//
//  Created by user on 27/12/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Base.h"

@interface GSE_Node : Base
@property (nonatomic, copy) NSString *stake;
@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *percentage;
@property (nonatomic, strong) NSDictionary *plan;
@end

@interface GSE_NodePlan : Base
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *stake;
@property (nonatomic, copy) NSString *percentage;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, assign) BOOL enable;
@property (nonatomic, copy) NSString *url;
@end

@interface GSE_NodeStake : Base
@property (nonatomic, copy) NSString *stakeid;
@property (nonatomic, copy) NSString *stake;
@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *status;
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
