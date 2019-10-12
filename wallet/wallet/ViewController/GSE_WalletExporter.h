//
//  GSE_WalletExporter.h
//  wallet
//
//  Created by user on 25/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_WalletExporter : GSE_WalletBase
@property (nonatomic, strong) NSString *wallet;
@property (nonatomic, assign) NSInteger exportType;
@property (nonatomic, strong) void(^finish)(void);
@end
