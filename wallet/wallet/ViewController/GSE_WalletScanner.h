//
//  GSE_WalletScanner.h
//  wallet
//
//  Created by user on 03/09/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletScanner : GSE_WalletBase
@property (nonatomic, strong) void(^finish)(NSString *address);
@end
