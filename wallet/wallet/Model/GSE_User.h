//
//  GSE_User.h
//  wallet
//
//  Created by user on 21/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSE_Base.h"

@interface GSE_User : Base
@property (nonatomic, strong) NSString * _id;
@property (nonatomic, strong) NSString * username;
@property (nonatomic, strong) NSString * password;
@property (nonatomic, strong) NSString * headurl;
@end
