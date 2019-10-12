//
//  GSE_Base.m
//  wallet
//
//  Created by user on 21/08/2018.
//  Copyright © 2018 VeslaChi. All rights reserved.
//

#import "GSE_Base.h"

@implementation Base

- (id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self addEntriesFromDictionray:dic];
    }
    return self;
}

- (void)addEntriesFromDictionray:(NSDictionary *)dic{
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"hash"]) {
            key = @"txhash";
        }
        @try{
            [self setValue:obj forKey:key];
        }@catch(NSException *exception){
            NSLog(@"%s,%@",__FUNCTION__,exception);
        }
    }];
}

- (id)initWithJSONData:(NSData *)data{
    
    @try{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            return [self initWithDictionary:dic];
        }
    }
    @catch(NSException *exception){
        NSLog(@"%s,%@",__FUNCTION__,exception);
    }
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (NSMutableArray *)parseFromJSONData:(NSData *)data forClass:(NSString *)className{
    
    @try{
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        if (array && [array isKindOfClass:[NSArray class]]) {
            
            NSMutableArray * objects = @[].mutableCopy;
            
            Class class = NSClassFromString(className);
            
            for (NSDictionary * dic in array) {
                if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                id objc = [[class alloc] initWithDictionary:dic];
                if (!objc) {
                    continue;
                }
                [objects addObject:objc];
            }
            return objects;
        }
    }
    @catch(NSException *exception){
        
    }
    return nil;
}

- (id<NSObject>)diffIdentifier {
    return self;
}

- (BOOL)isEqualToDiffableObject:(id)object {
    // since the diff identifier returns self, object should only be compared with same instance
    return self == object;
}

@end
