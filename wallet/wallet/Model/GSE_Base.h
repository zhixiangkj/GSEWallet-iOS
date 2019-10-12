//
//  GSE_Base.h
//  wallet
//
//  Created by user on 21/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <IGListKit/IGListDiffable.h>

@interface Base : NSObject  <IGListDiffable>

- (id)initWithDictionary:(NSDictionary *)dic;
- (id)initWithJSONData:(NSData *)data;
- (void)addEntriesFromDictionray:(NSDictionary *)dic;

+ (NSMutableArray *)parseFromJSONData:(NSData *)data forClass:(NSString *)className;

@end
