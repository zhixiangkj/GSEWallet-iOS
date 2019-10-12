//
//  GSE_NodeViewCell.h
//  GSEWallet
//
//  Created by user on 27/12/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_NodeViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *gse;
@property (nonatomic, copy) NSString *income;
@property (nonatomic, copy) NSString *percentage;
@property (nonatomic, assign) id delegate;
@end
