//
//  RebateController.m
//  GSEWallet
//
//  Created by user on 01/11/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_RebateController.h"

#import "GSE_RebateMenuViewCell.h"
#import "GSE_RebateShareViewCell.h"
#import "GSE_RebateHistoryViewCell.h"

#import "GSE_Rebate.h"

@interface GSE_RebateController ()
@property (nonatomic, strong) GSE_RebateCode *rebate;
@end

@implementation GSE_RebateController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    if (![_rebate isKindOfClass:[GSE_RebateCode class]]) {
        
        return CGSizeMake(width, 150);
    }
    if ([self.delegate respondsToSelector:@selector(sizeForItemAtIndex:)]) {
        return [self.delegate sizeForItemAtIndex:index];
    }
    return CGSizeMake(width, 756 / 2.0 + 22);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    
    if (![_rebate isKindOfClass:[GSE_RebateCode class]]) {
        
        GSE_RebateMenuViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_RebateMenuViewCell class] forSectionController:self atIndex:index];
        [cell setQuantity: _rebate.quantity ];
        cell.delegate = self.delegate;
        return cell;
    }else{
        
        GSE_RebateShareViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_RebateShareViewCell class] forSectionController:self atIndex:index];
        [cell setCode: _rebate.code ];
        [cell setRequire:_rebate.require];
        [cell setAcquire:_rebate.acquire];
        [cell setInvited:_rebate.invited];
        [cell setRebates:_rebate.rebates];
        [cell reloadData];
        cell.delegate = self.delegate;
        return cell;
    }
}

- (void)didUpdateToObject:(id)object {
    _rebate = object;
}

@end

@interface GSE_RebateHistoryController ()
@property (nonatomic, strong) GSE_RebateInfo *rebate;
@end

@implementation GSE_RebateHistoryController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    if ([_rebate isKindOfClass:[NSString class]]) {
        return CGSizeMake(width, 96 / 2.0);
    }
    return CGSizeMake(width, 60);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    if ([_rebate isKindOfClass:[NSString class]]) {
        
        GSE_RebateHistoryMenuCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_RebateHistoryMenuCell class] forSectionController:self atIndex:index];
        
        return cell;
    }
    
    GSE_RebateHistoryInfoCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_RebateHistoryInfoCell class] forSectionController:self atIndex:index];
    cell.txhash = _rebate.txhash;
    cell.date = [[NSDate dateWithTimeIntervalSince1970:_rebate.timestamp.doubleValue] dateString];
    cell.source = _rebate.source;
    cell.gse = _rebate.valueInGSE;
    return cell;
}

- (void)didUpdateToObject:(id)object {
    _rebate = object;
}

@end
