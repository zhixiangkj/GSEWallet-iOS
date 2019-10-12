//
//  GSE_WalletSuccessor.h
//  wallet
//
//  Created by user on 25/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletSuccessor : GSE_WalletBase
@property (nonatomic, strong) NSString *wallet;
@property (nonatomic, assign) BOOL import;
@property (nonatomic, strong) void(^finish)(void);
@end
