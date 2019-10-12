//
//  GSE_RebateShareViewCell.h
//  GSEWallet
//
//  Created by user on 01/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_RebateShareViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *require;
@property (nonatomic, copy) NSString *acquire;
@property (nonatomic, copy) NSString *invited;
@property (nonatomic, copy) NSString *rebates;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) id delegate;
- (void)reloadData;
@end
