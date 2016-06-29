//
//  NSArray+Null.m
//  Nextdoors
//
//  Created by hfhouse on 15/6/2.
//  Copyright (c) 2015年 hfw. All rights reserved.
//

#import "NSArray+Null.h"
#import "NSDictionary+Null.h"

@implementation NSArray (Null)

- (NSArray *)arrayWithoutNull {
    
    NSMutableArray *mutableSelf = [self mutableCopy];
    NSMutableArray *nullObjects = [NSMutableArray new];
    
    for (int i = 0; i < mutableSelf.count; i++) {
        id obj = mutableSelf[i];
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            mutableSelf[i] = [obj dictionaryWithoutNull];
        }
        else if ([obj isKindOfClass:[NSArray class]]) {
            mutableSelf[i] = [obj arrayWithoutNull];
        }
        else if ([obj isEqual:[NSNull null]]) {
            [nullObjects addObject:obj];
        }
    }
    
    [mutableSelf removeObjectsInArray:nullObjects];
    
    return [mutableSelf copy];
}

@end

