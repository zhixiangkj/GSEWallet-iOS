//
//  GSE_WalletTransaction.h
//  wallet
//
//  Created by user on 28/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletTxns : GSE_WalletBase
@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) Address *contract;
@property (nonatomic, strong) NSDictionary *token;
@property (nonatomic, strong) NSString *symbol;
//@property (nonatomic, strong) NSString *value;
//@property (nonatomic, strong) NSString *valueInUSD;
@property (nonatomic, strong) NSString *name;

- (void)reloadData;
- (void)reloadData:( void (^)(void) ) finish;
@end
