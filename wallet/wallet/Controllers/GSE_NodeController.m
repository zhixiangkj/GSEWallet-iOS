//
//  GSE_NodeController.m
//  GSEWallet
//
//  Created by user on 27/12/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_NodeController.h"

#import "GSE_Node.h"
#import "GSE_NodeViewCell.h"
#import "GSE_NodePlanViewCell.h"
#import "GSE_NodePlanDetailCell.h"
#import "GSE_NodeHistoryViewCell.h"

@interface GSE_NodeController ()
@property (nonatomic, strong) GSE_Node *node;
@end

@implementation GSE_NodeController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    return CGSizeMake(width, 330 / 2.0 + 25);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    GSE_NodeViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_NodeViewCell class] forSectionController:self atIndex:index];
    [cell setGse:_node.stake?:@"-"];
    [cell setIncome:_node.income?:@"-"];
    [cell setPercentage:_node.percentage?:@"-"];
    [cell setDelegate:self];
    return cell;
}

- (void)didUpdateToObject:(id)object{
    _node = object;
}

#pragma mark - action

- (void)detailAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(detailAction:)]) {
        [self.delegate detailAction:self.node];
    }
}

@end

@interface GSE_NodePlanController ()
@property (nonatomic, strong) GSE_NodePlan * plan;
@end

@implementation GSE_NodePlanController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    return CGSizeMake(width, 308 / 2.0 + 20);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    GSE_NodePlanViewCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_NodePlanViewCell class] forSectionController:self atIndex:index];
    cell.name = _plan.name?:@"GSE节点计划";
    cell.percentage = _plan.percentage?:@"0%";
    cell.days = _plan.days?:@"0";
    cell.gse = _plan.stake?:@"0";
    [cell setDelegate:self];
    return cell;
}


- (void)didUpdateToObject:(id)object{
    _plan = object;
}

- (void)detailAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(detailAction:)]) {
        [self.delegate detailAction:self.plan];
    }
}
@end

@interface GSE_NodePlanDetailController ()
@property (nonatomic, strong) GSE_NodePlan * plan;
@end

@implementation GSE_NodePlanDetailController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    return CGSizeMake(width, 640);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    GSE_NodePlanDetailCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_NodePlanDetailCell class] forSectionController:self atIndex:index];
    [cell setDelegate:self];
    return cell;
}

- (void)didUpdateToObject:(id)object{
    _plan = object;
}

- (void)transferAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(transferAction:)]) {
        [self.delegate transferAction:self.plan];
    }
}

- (void)detailAction:(id)sender{
    if ([self.delegate respondsToSelector:@selector(detailAction:)]) {
        [self.delegate detailAction:self.plan];
    }
}
@end

@interface GSE_NodeStakeController ()
@property (nonatomic, strong) GSE_NodeStake *node;
@end

@implementation GSE_NodeStakeController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    CGFloat width = self.collectionContext.containerSize.width;
    if ([_node isKindOfClass:[NSString class]]) {
        return CGSizeMake(width, 96 / 2.0);
    }
    return CGSizeMake(width, 60);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index{
    if ([_node isKindOfClass:[NSString class]]) {
        
        GSE_NodeHistoryMenuCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_NodeHistoryMenuCell class] forSectionController:self atIndex:index];
        
        return cell;
    }
    
    GSE_NodeHistoryInfoCell *cell = [self.collectionContext dequeueReusableCellOfClass:[GSE_NodeHistoryInfoCell class] forSectionController:self atIndex:index];
    
    return cell;
}

- (void)didUpdateToObject:(id)object{
    _node = object;
}

@end



