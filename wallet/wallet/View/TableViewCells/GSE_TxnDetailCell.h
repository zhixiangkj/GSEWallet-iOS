//
//  GSE_TxnDetailCell.h
//  wallet
//
//  Created by user on 30/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_TxnDetailCell : UITableViewCell
@property (nonatomic, assign) BOOL txn_out;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) BOOL largeBlue;
@end

@interface GSE_TxnDetailAmountCell : UITableViewCell
@property (nonatomic, assign) BOOL txn_out;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *value;
@end
