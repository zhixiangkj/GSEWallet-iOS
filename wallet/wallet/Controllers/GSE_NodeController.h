//
//  GSE_NodeController.h
//  GSEWallet
//
//  Created by user on 27/12/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "IGListSectionController.h"

@interface GSE_NodeController : IGListSectionController
@property (nonatomic, assign) id delegate;
@end

@interface GSE_NodePlanController : IGListSectionController
@property (nonatomic, assign) id delegate;
@end

@interface GSE_NodePlanDetailController: IGListSectionController
@property (nonatomic, assign) id delegate;
@end

@interface GSE_NodeStakeController : IGListSectionController
@property (nonatomic, assign) id delegate;
@end
