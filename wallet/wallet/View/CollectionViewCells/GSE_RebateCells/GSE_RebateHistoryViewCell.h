//
//  RebateHistoryViewCell.h
//  GSEWallet
//
//  Created by user on 06/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_RebateHistoryMenuCell : UICollectionViewCell

@end

@interface GSE_RebateHistoryInfoCell : GSE_RebateHistoryMenuCell
@property (nonatomic, copy) NSString *txhash;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *gse;
@end
