//
//  GSE_NodeHistoryViewCell.h
//  GSEWallet
//
//  Created by user on 09/01/2019.
//  Copyright © 2019 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_NodeHistoryMenuCell : UICollectionViewCell

@end

@interface GSE_NodeHistoryInfoCell : GSE_NodeHistoryMenuCell
@property (nonatomic, copy) NSString *txhash;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *stake;
@property (nonatomic, copy) NSString *income;
@end
