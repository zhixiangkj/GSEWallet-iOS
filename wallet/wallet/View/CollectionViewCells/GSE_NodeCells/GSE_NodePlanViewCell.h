//
//  GSE_NodePlanViewCell.h
//  GSEWallet
//
//  Created by user on 29/12/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSE_NodePlanViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *percentage;
@property (nonatomic, copy) NSString *days;
@property (nonatomic, copy) NSString *gse;
@property (nonatomic, assign) id delegate;
@end
