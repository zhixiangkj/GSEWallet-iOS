//
//  GSE_WalletCreator.h
//  wallet
//
//  Created by user on 24/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletCreator : GSE_WalletBase
@property (nonatomic, strong) Account *import;
@property (nonatomic, strong) void(^finish)(NSString *);
@end
