//
//  GSE_WalletWebBrowser.h
//  GSEWallet
//
//  Created by user on 01/10/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_WalletBase.h"

@interface GSE_WalletWebBrowser : GSE_WalletBase
@property (nonatomic, strong) NSString *customTitle;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL modal;
@end
