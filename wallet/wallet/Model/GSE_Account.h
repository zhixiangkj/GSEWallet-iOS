//
//  GSE_Account.h
//  wallet
//
//  Created by user on 21/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Base.h"

@interface GSE_Account : Base
@property (nonatomic, strong) NSString * _id;
@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSData * publicKey;
@property (nonatomic, strong) NSData * privateKey;
@end
