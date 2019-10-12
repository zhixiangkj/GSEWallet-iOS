//
//  GSE_WalletTransfer.h
//  wallet
//
//  Created by user on 30/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletTransfer : GSE_WalletBase
@property (nonatomic, assign) BOOL onlyOne;
@property (nonatomic, strong) NSDictionary * token;
@property (nonatomic, strong) NSString *wallet;
@end
