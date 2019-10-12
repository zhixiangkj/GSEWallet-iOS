//
//  GSE_TxnsCell.h
//  wallet
//
//  Created by user on 29/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_TxnsCell : UITableViewCell

@property (nonatomic, assign) BOOL txn_out;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *timestamp;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *status;

@end
